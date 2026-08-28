import { describeDb } from './setup';
import { authed, basket, seedFixture, type Fixture } from './helpers';
import { Order } from '../src/modules/orders/order.model';
import { Voucher } from '../src/modules/vouchers/voucher.model';
import { User } from '../src/modules/users/user.model';
import { AgentStatus } from '../src/modules/agents/agent.model';

describeDb('order engine', () => {
  let f: Fixture;

  beforeEach(async () => {
    f = await seedFixture();
  });

  const orderBody = () => ({ ...basket(f), addressId: String(f.address._id) });

  it('quotes a basket without creating anything', async () => {
    const res = await authed('post', '/orders/quote', f.tokens.customer).send(basket(f));
    expect(res.status).toBe(200);
    // 450 + 150 (مضاعف) = 600 دج، + 50 خدمة + 150 توصيل
    expect(res.body.data.subtotalCentimes).toBe(60000);
    expect(res.body.data.totalCentimes).toBe(80000);
    expect(await Order.countDocuments()).toBe(0);
  });

  it('creates an order priced entirely by the server', async () => {
    const res = await authed('post', '/orders', f.tokens.customer)
      .send({ ...orderBody(), totalCentimes: 1, subtotalCentimes: 1 });
    expect(res.status).toBe(400); // unknown keys are rejected outright

    const clean = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    expect(clean.status).toBe(201);
    expect(clean.body.data.status).toBe('pending');
    expect(clean.body.data.totalCentimes).toBe(80000);
    expect(clean.body.data.code).toMatch(/^DR\d{6}$/);
    expect(clean.body.message).toContain('سنتصل بك');
  });

  it('snapshots the address and item names onto the order', async () => {
    const res = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    expect(res.body.data.address.commune).toBe('بئر العاتر');
    expect(res.body.data.items[0].nameSnapshot).toBe('برجر كلاسيك');
    expect(res.body.data.items[0].selectedOptions[0].value).toBe('مضاعف');
  });

  it('drives the full lifecycle across all three roles', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const id = create.body.data.id;

    for (const status of ['confirmed', 'sent_to_vendor', 'preparing', 'ready']) {
      const res = await authed('patch', `/admin/orders/${id}/status`, f.tokens.admin).send({ status });
      expect(res.status).toBe(200);
      expect(res.body.data.status).toBe(status);
    }

    const assign = await authed('post', `/admin/orders/${id}/assign`, f.tokens.admin).send({
      agentId: String(f.agent._id),
    });
    expect(assign.status).toBe(200);
    expect(assign.body.data.order.status).toBe('assigned');

    const accept = await authed('post', `/agent/offers/${id}/accept`, f.tokens.agent);
    expect(accept.status).toBe(200);
    expect(accept.body.data.status).toBe('accepted');

    for (const status of ['picked_up', 'on_the_way']) {
      const res = await authed('patch', `/agent/orders/${id}/status`, f.tokens.agent).send({ status });
      expect(res.status).toBe(200);
    }

    const delivered = await authed('patch', `/agent/orders/${id}/status`, f.tokens.agent).send({
      status: 'delivered',
      cashCollected: true,
    });
    expect(delivered.status).toBe(200);
    expect(delivered.body.data.status).toBe('delivered');

    const order = await Order.findById(id);
    expect(order!.events).toHaveLength(10);
    expect(order!.deliveredAt).toBeTruthy();

    // 600 دج subtotal -> 6 points
    const customer = await User.findById(f.customer._id);
    expect(customer!.points).toBe(6);

    // The agent is free again.
    const status = await AgentStatus.findOne({ agent: f.agent._id });
    expect(status!.currentOrder).toBeNull();
  });

  it('refuses a cash delivery that was not collected', async () => {
    const id = await driveTo('on_the_way');
    const res = await authed('patch', `/agent/orders/${id}/status`, f.tokens.agent).send({
      status: 'delivered',
    });
    expect(res.status).toBe(400);
  });

  it('rejects every illegal transition with 409', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const id = create.body.data.id;

    for (const status of ['delivered', 'ready', 'assigned', 'picked_up']) {
      const res = await authed('patch', `/admin/orders/${id}/status`, f.tokens.admin).send({ status });
      expect(res.status).toBe(409);
      expect(res.body.code).toBe('ILLEGAL_TRANSITION');
    }
  });

  it('refuses to move a terminal order', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const id = create.body.data.id;
    await authed('patch', `/orders/${id}/cancel`, f.tokens.customer).send({ reason: 'غيّرت رأيي' });

    const res = await authed('patch', `/admin/orders/${id}/status`, f.tokens.admin).send({
      status: 'confirmed',
    });
    expect(res.status).toBe(409);
  });

  it('lets only the admin confirm', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const id = create.body.data.id;
    const res = await authed('patch', `/agent/orders/${id}/status`, f.tokens.agent).send({
      status: 'picked_up',
    });
    expect(res.status).toBe(403);
  });

  it('requires a reason to cancel', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const res = await authed('patch', `/orders/${create.body.data.id}/cancel`, f.tokens.customer).send({});
    expect(res.status).toBe(400);
  });

  it('stops a customer cancelling after confirmation', async () => {
    const id = await driveTo('confirmed');
    const res = await authed('patch', `/orders/${id}/cancel`, f.tokens.customer).send({
      reason: 'تأخر كثيراً',
    });
    expect(res.status).toBe(409);
  });

  it('returns a rejected assignment to the pool', async () => {
    const id = await driveTo('assigned');
    const res = await authed('post', `/agent/offers/${id}/reject`, f.tokens.agent).send({
      reason: 'بعيد جداً',
    });
    expect(res.status).toBe(200);
    expect(res.body.data.status).toBe('ready');

    const order = await Order.findById(id);
    expect(order!.agent).toBeNull();

    const status = await AgentStatus.findOne({ agent: f.agent._id });
    expect(status!.currentOrder).toBeNull();
  });

  it('refunds points when an order is cancelled', async () => {
    await User.updateOne({ _id: f.customer._id }, { $set: { points: 100 } });
    const create = await authed('post', '/orders', f.tokens.customer).send({
      ...orderBody(),
      pointsToUse: 20,
    });
    expect(create.body.data.pointsUsed).toBe(20);
    expect((await User.findById(f.customer._id))!.points).toBe(80);

    await authed('patch', `/orders/${create.body.data.id}/cancel`, f.tokens.customer).send({
      reason: 'غيّرت رأيي',
    });
    expect((await User.findById(f.customer._id))!.points).toBe(100);
  });

  it('consumes a voucher once per user limit', async () => {
    await Voucher.create({
      code: 'SAJI10',
      type: 'percentage',
      value: 10,
      perUserLimit: 1,
      isActive: true,
    });

    const first = await authed('post', '/orders', f.tokens.customer).send({
      ...orderBody(),
      voucherCode: 'SAJI10',
    });
    expect(first.body.data.discountCentimes).toBe(6000);

    const second = await authed('post', '/orders/quote', f.tokens.customer).send({
      ...basket(f),
      voucherCode: 'SAJI10',
    });
    expect(second.body.data.voucherCode).toBeNull();
    expect(second.body.data.warnings.join()).toContain('استعملت');
  });

  it('refuses to assign an offline agent', async () => {
    await AgentStatus.updateOne({ agent: f.agent._id }, { $set: { isOnline: false } });
    const id = await driveTo('ready');
    const res = await authed('post', `/admin/orders/${id}/assign`, f.tokens.admin).send({
      agentId: String(f.agent._id),
    });
    expect(res.status).toBe(409);
  });

  it('sorts available agents and reports their load', async () => {
    const res = await authed(
      'get',
      `/admin/agents/available?vendorId=${String(f.vendor._id)}`,
      f.tokens.admin,
    );
    expect(res.status).toBe(200);
    expect(res.body.data[0].agentId).toBe(String(f.agent._id));
    expect(res.body.data[0].currentLoad).toBe(0);
  });

  /** Drives a fresh order up to `target` using the correct actor for each step. */
  async function driveTo(target: string): Promise<string> {
    const create = await authed('post', '/orders', f.tokens.customer).send(orderBody());
    const id = create.body.data.id;
    const adminSteps = ['confirmed', 'sent_to_vendor', 'preparing', 'ready'];

    for (const step of adminSteps) {
      await authed('patch', `/admin/orders/${id}/status`, f.tokens.admin).send({ status: step });
      if (step === target) return id;
    }
    if (target === 'pending') return id;

    await authed('post', `/admin/orders/${id}/assign`, f.tokens.admin).send({
      agentId: String(f.agent._id),
    });
    if (target === 'assigned') return id;

    await authed('post', `/agent/offers/${id}/accept`, f.tokens.agent);
    if (target === 'accepted') return id;

    for (const step of ['picked_up', 'on_the_way']) {
      await authed('patch', `/agent/orders/${id}/status`, f.tokens.agent).send({ status: step });
      if (step === target) return id;
    }
    return id;
  }
});

describeDb('ownership', () => {
  let f: Fixture;
  beforeEach(async () => {
    f = await seedFixture();
  });

  it('hides one customer order from another customer', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send({
      ...basket(f),
      addressId: String(f.address._id),
    });
    const { makeUser, tokenFor } = await import('./helpers');
    const other = await makeUser('customer', '+213770555555');
    const res = await authed('get', `/orders/${create.body.data.id}`, tokenFor(other));
    expect(res.status).toBe(403);
  });

  it('stops an agent touching an order that is not theirs', async () => {
    const create = await authed('post', '/orders', f.tokens.customer).send({
      ...basket(f),
      addressId: String(f.address._id),
    });
    const res = await authed('patch', `/agent/orders/${create.body.data.id}/status`, f.tokens.agent).send({
      status: 'picked_up',
    });
    expect(res.status).toBe(403);
  });

  it('stops a customer editing another customer address', async () => {
    const { makeUser, tokenFor } = await import('./helpers');
    const other = await makeUser('customer', '+213770666666');
    const res = await authed('patch', `/addresses/${String(f.address._id)}`, tokenFor(other)).send({
      street: 'اختراق',
    });
    expect(res.status).toBe(404);
  });
});

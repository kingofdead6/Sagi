import request from 'supertest';
import { describeDb } from './setup';
import { api, app, makeUser, PASSWORD, tokenFor, authed } from './helpers';

describeDb('auth', () => {
  const phone = '0770123456';

  it('registers, logs in, reads me and refreshes', async () => {
    const register = await request(app)
      .post(api('/auth/register'))
      .send({ phone, password: PASSWORD, fullName: 'أمين حملاوي' });
    expect(register.status).toBe(201);
    expect(register.body.success).toBe(true);
    expect(register.body.data.user.phone).toBe('+213770123456');
    expect(register.body.data.user.role).toBe('customer');
    expect(register.body.data.user.passwordHash).toBeUndefined();

    const login = await request(app).post(api('/auth/login')).send({ phone, password: PASSWORD });
    expect(login.status).toBe(200);
    const { accessToken, refreshToken } = login.body.data;

    const me = await request(app).get(api('/auth/me')).set('Authorization', `Bearer ${accessToken}`);
    expect(me.status).toBe(200);
    expect(me.body.data.fullName).toBe('أمين حملاوي');

    const refreshed = await request(app).post(api('/auth/refresh')).send({ refreshToken });
    expect(refreshed.status).toBe(200);
    expect(refreshed.body.data.accessToken).toBeTruthy();
    expect(refreshed.body.data.refreshToken).not.toBe(refreshToken);
  });

  it('normalises every accepted phone form to the same account', async () => {
    await request(app).post(api('/auth/register')).send({ phone, password: PASSWORD, fullName: 'أمين' });
    const login = await request(app)
      .post(api('/auth/login'))
      .send({ phone: '+213770123456', password: PASSWORD });
    expect(login.status).toBe(200);
  });

  it('refuses a duplicate phone', async () => {
    await request(app).post(api('/auth/register')).send({ phone, password: PASSWORD, fullName: 'أ' });
    const again = await request(app)
      .post(api('/auth/register'))
      .send({ phone, password: PASSWORD, fullName: 'ب' });
    expect(again.status).toBe(409);
    expect(again.body.code).toBe('CONFLICT');
  });

  it('rejects a non-Algerian phone with 400', async () => {
    const res = await request(app)
      .post(api('/auth/register'))
      .send({ phone: '+33612345678', password: PASSWORD, fullName: 'أ' });
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('VALIDATION_ERROR');
  });

  it('rejects a wrong password with 401', async () => {
    await request(app).post(api('/auth/register')).send({ phone, password: PASSWORD, fullName: 'أ' });
    const res = await request(app).post(api('/auth/login')).send({ phone, password: 'wrongpass' });
    expect(res.status).toBe(401);
  });

  it('rejects a missing or invalid token with 401', async () => {
    expect((await request(app).get(api('/auth/me'))).status).toBe(401);
    expect(
      (await request(app).get(api('/auth/me')).set('Authorization', 'Bearer nonsense')).status,
    ).toBe(401);
  });

  it('detects refresh token reuse and kills the family', async () => {
    await request(app).post(api('/auth/register')).send({ phone, password: PASSWORD, fullName: 'أ' });
    const login = await request(app).post(api('/auth/login')).send({ phone, password: PASSWORD });
    const first = login.body.data.refreshToken;

    const rotated = await request(app).post(api('/auth/refresh')).send({ refreshToken: first });
    expect(rotated.status).toBe(200);

    // Replaying the consumed token must fail…
    const replay = await request(app).post(api('/auth/refresh')).send({ refreshToken: first });
    expect(replay.status).toBe(401);

    // …and revoke the successor too.
    const after = await request(app)
      .post(api('/auth/refresh'))
      .send({ refreshToken: rotated.body.data.refreshToken });
    expect(after.status).toBe(401);
  });

  it('only writes whitelisted fields on PATCH /auth/me', async () => {
    const user = await makeUser('customer', '+213770999999');
    const res = await authed('patch', '/auth/me', tokenFor(user))
      .send({ fullName: 'اسم جديد', role: 'admin', points: 99999 })
      .expect(400);
    expect(res.body.code).toBe('VALIDATION_ERROR');
  });

  it('keeps OTP endpoints disabled at v1', async () => {
    const res = await request(app).post(api('/auth/otp/request')).send({ phone });
    expect(res.status).toBe(503);
  });
});

describeDb('role guards', () => {
  it('rejects a customer on an admin route with 403', async () => {
    const customer = await makeUser('customer', '+213770000001');
    const res = await authed('get', '/admin/stats', tokenFor(customer));
    expect(res.status).toBe(403);
    expect(res.body.code).toBe('FORBIDDEN');
  });

  it('rejects an agent on an admin route with 403', async () => {
    const agent = await makeUser('agent', '+213661000001');
    expect((await authed('get', '/admin/orders', tokenFor(agent))).status).toBe(403);
  });

  it('rejects a customer on an agent route with 403', async () => {
    const customer = await makeUser('customer', '+213770000002');
    expect((await authed('get', '/agent/offers', tokenFor(customer))).status).toBe(403);
  });

  it('lets an admin through', async () => {
    const admin = await makeUser('admin', '+213555000001');
    expect((await authed('get', '/admin/stats', tokenFor(admin))).status).toBe(200);
  });

  it('takes the role from the database, not the token claim', async () => {
    const customer = await makeUser('customer', '+213770000003');
    // A forged token claiming admin still hits the database check.
    const forged = tokenFor({ _id: customer._id, role: 'admin', phone: customer.phone });
    expect((await authed('get', '/admin/stats', forged)).status).toBe(403);
  });

  it('blocks a suspended account with 403', async () => {
    const customer = await makeUser('customer', '+213770000004');
    const token = tokenFor(customer);
    customer.isBlocked = true;
    await customer.save();
    expect((await authed('get', '/auth/me', token)).status).toBe(403);
  });
});

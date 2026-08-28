import { APK_MIN_ANDROID, APK_SIZE, APK_URL, CATEGORIES, FEATURES, STEPS } from './data';

/** The download call to action, reused in the hero and the closing band. */
function DownloadButton({ variant = 'solid' }) {
  const solid =
    'bg-brand text-white hover:bg-brand-deep focus-visible:outline-brand-deep shadow-lg shadow-brand/25';
  const outline =
    'bg-white text-brand-deep ring-1 ring-inset ring-brand/30 hover:bg-brand/5 focus-visible:outline-brand';

  return (
    <a
      href={APK_URL}
      // The APK is a binary the browser would otherwise try to render.
      download="saji.apk"
      className={`inline-flex items-center justify-center gap-3 rounded-2xl px-8 py-4 text-lg font-bold transition focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 ${
        variant === 'solid' ? solid : outline
      }`}
    >
      <svg
        className="h-6 w-6"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2"
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
      >
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
        <polyline points="7 10 12 15 17 10" />
        <line x1="12" y1="15" x2="12" y2="3" />
      </svg>
      حمّل التطبيق
    </a>
  );
}

function Header() {
  return (
    <header className="sticky top-0 z-20 border-b border-black/5 bg-canvas/80 backdrop-blur">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-5 py-3">
        <div className="flex items-center gap-3">
          <img
            src="./assets/logo-mark.png"
            alt="شعار ساجي"
            className="h-11 w-11 rounded-xl object-contain"
          />
          <span className="text-xl font-extrabold tracking-tight">ساجي</span>
        </div>

        <a
          href="#download"
          className="rounded-xl bg-brand px-5 py-2.5 text-sm font-bold text-white transition hover:bg-brand-deep"
        >
          تحميل
        </a>
      </div>
    </header>
  );
}

function Hero() {
  return (
    <section className="relative overflow-hidden">
      {/* A soft brand wash behind the fold; purely decorative. */}
      <div
        aria-hidden="true"
        className="pointer-events-none absolute inset-x-0 -top-40 h-[28rem] bg-gradient-to-b from-brand/15 to-transparent blur-2xl"
      />

      <div className="relative mx-auto grid max-w-6xl items-center gap-12 px-5 py-16 md:grid-cols-2 md:py-24">
        <div className="text-center md:text-right">
          <span className="inline-block rounded-full bg-brand/10 px-4 py-1.5 text-sm font-bold text-brand-deep">
            توصيل في بئر العاتر
          </span>

          <h1 className="mt-5 text-4xl font-black leading-tight sm:text-5xl md:text-6xl">
            كلش يوصلك
            <span className="text-brand"> بسهولة</span>
          </h1>

          <p className="mx-auto mt-5 max-w-lg text-lg leading-relaxed text-ink-soft md:mx-0">
            أكل، خضر وفواكه، صيدلية وأي حاجة تحتاجها — اطلبها من تطبيق ساجي
            وتوصلك إلى باب دارك.
          </p>

          <div className="mt-8 flex flex-col items-center gap-3 md:flex-row md:items-start">
            <DownloadButton />
            <p className="text-sm text-ink-muted">
              {APK_SIZE} · {APK_MIN_ANDROID}
            </p>
          </div>
        </div>

        <div className="flex justify-center">
          <div className="rounded-[2rem] bg-white p-6 shadow-xl shadow-black/5 ring-1 ring-black/5">
            <img
              src="./assets/logo-full.png"
              alt="ساجي — كلش يوصلك بسهولة"
              className="h-64 w-64 object-contain sm:h-80 sm:w-80"
            />
          </div>
        </div>
      </div>
    </section>
  );
}

function Categories() {
  return (
    <section className="mx-auto max-w-6xl px-5 py-12">
      <div className="grid grid-cols-2 gap-4 md:grid-cols-4">
        {CATEGORIES.map((category) => (
          <div
            key={category.label}
            className="rounded-2xl bg-white p-6 text-center shadow-sm ring-1 ring-black/5 transition hover:-translate-y-1 hover:shadow-md"
          >
            <div className="text-4xl" aria-hidden="true">
              {category.icon}
            </div>
            <h3 className="mt-3 text-lg font-bold">{category.label}</h3>
            <p className="mt-1 text-sm text-ink-muted">{category.hint}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

function Features() {
  return (
    <section className="mx-auto max-w-6xl px-5 py-12">
      <h2 className="text-center text-3xl font-black md:text-4xl">لماذا ساجي؟</h2>

      <div className="mt-10 grid gap-5 sm:grid-cols-2">
        {FEATURES.map((feature) => (
          <div
            key={feature.title}
            className="flex gap-4 rounded-2xl bg-white p-6 shadow-sm ring-1 ring-black/5"
          >
            <div
              className="flex h-12 w-12 shrink-0 items-center justify-center rounded-xl bg-brand/10 text-2xl"
              aria-hidden="true"
            >
              {feature.icon}
            </div>
            <div>
              <h3 className="text-lg font-bold">{feature.title}</h3>
              <p className="mt-1 leading-relaxed text-ink-soft">{feature.body}</p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}

function Steps() {
  return (
    <section className="mx-auto max-w-6xl px-5 py-12">
      <h2 className="text-center text-3xl font-black md:text-4xl">كيف يعمل؟</h2>

      <div className="mt-10 grid gap-5 md:grid-cols-3">
        {STEPS.map((step) => (
          <div key={step.n} className="rounded-2xl bg-white p-6 shadow-sm ring-1 ring-black/5">
            <div className="flex h-11 w-11 items-center justify-center rounded-full bg-brand text-xl font-black text-white">
              {step.n}
            </div>
            <h3 className="mt-4 text-lg font-bold">{step.title}</h3>
            <p className="mt-1 leading-relaxed text-ink-soft">{step.body}</p>
          </div>
        ))}
      </div>
    </section>
  );
}

function Download() {
  return (
    <section id="download" className="scroll-mt-20 px-5 py-16">
      <div className="mx-auto max-w-4xl rounded-3xl bg-brand-deep px-6 py-14 text-center text-white">
        <img
          src="./assets/logo-mark.png"
          alt=""
          aria-hidden="true"
          className="mx-auto h-20 w-20 rounded-2xl bg-white/95 p-2 object-contain"
        />

        <h2 className="mt-6 text-3xl font-black md:text-4xl">حمّل ساجي الآن</h2>
        <p className="mx-auto mt-3 max-w-md leading-relaxed text-white/80">
          التطبيق متاح لأجهزة أندرويد. حمّل الملف وثبّته لتبدأ أول طلب.
        </p>

        <div className="mt-8 flex justify-center">
          <DownloadButton variant="outline" />
        </div>

        <p className="mt-4 text-sm text-white/70">
          {APK_SIZE} · {APK_MIN_ANDROID}
        </p>

        {/* Sideloading needs a step users will not guess on their own. */}
        <p className="mx-auto mt-6 max-w-md text-sm leading-relaxed text-white/70">
          عند التثبيت قد يطلب منك الهاتف السماح بتثبيت التطبيقات من هذا المصدر —
          اقبل الطلب ثم أكمل التثبيت.
        </p>
      </div>
    </section>
  );
}

function Footer() {
  return (
    <footer className="border-t border-black/5 px-5 py-8">
      <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-3 text-sm text-ink-muted sm:flex-row">
        <div className="flex items-center gap-2">
          <img
            src="./assets/logo-mark.png"
            alt=""
            aria-hidden="true"
            className="h-7 w-7 object-contain"
          />
          <span className="font-bold text-ink">ساجي</span>
        </div>
        <p>كل الحقوق محفوظة © {new Date().getFullYear()}</p>
      </div>
    </footer>
  );
}

export default function App() {
  return (
    <>
      <Header />
      <main>
        <Hero />
        <Categories />
        <Features />
        <Steps />
        <Download />
      </main>
      <Footer />
    </>
  );
}

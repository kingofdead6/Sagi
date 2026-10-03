/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        // Sampled from the Saji logo: the deep wordmark green, the leaf green
        // of the ring, the orange of the tagline rules, and the tomato.
        forest: { DEFAULT: '#0E4D2B', deep: '#08341C', soft: '#1E6B3F' },
        leaf: { DEFAULT: '#5BB22F', bright: '#7ACB45', tint: '#E7F5DC' },
        tangerine: { DEFAULT: '#F27A1A', soft: '#FFE6D2' },
        tomato: '#E2402F',
        cream: { DEFAULT: '#FBF8F1', deep: '#F3EDDF' },
        ink: { DEFAULT: '#152218', soft: '#45574A', muted: '#8A9A8D' },
      },
      fontFamily: {
        // Baloo Bhaijaan 2 echoes the logo's rounded wordmark; Tajawal carries
        // body text. Both cover Arabic and Latin, so fr/en need no swap.
        display: ['"Baloo Bhaijaan 2"', 'Tajawal', 'system-ui', 'sans-serif'],
        sans: ['Tajawal', 'system-ui', 'Tahoma', 'sans-serif'],
      },
      borderRadius: { '4xl': '2rem' },
      boxShadow: {
        card: '0 1px 2px rgba(14,77,43,.06), 0 8px 24px -8px rgba(14,77,43,.14)',
        lift: '0 2px 4px rgba(14,77,43,.08), 0 24px 48px -16px rgba(14,77,43,.28)',
        glow: '0 0 0 6px rgba(91,178,47,.18)',
      },
      keyframes: {
        shimmer: { '100%': { transform: 'translateX(100%)' } },
        marquee: { from: { transform: 'translateX(0)' }, to: { transform: 'translateX(-50%)' } },
        floaty: {
          '0%,100%': { transform: 'translateY(0) rotate(0deg)' },
          '50%': { transform: 'translateY(-14px) rotate(4deg)' },
        },
        spinSlow: { to: { transform: 'rotate(360deg)' } },
        speed: {
          '0%': { transform: 'translateX(0)', opacity: '0' },
          '30%': { opacity: '1' },
          '100%': { transform: 'translateX(40px)', opacity: '0' },
        },
        ping2: { '75%,100%': { transform: 'scale(2.2)', opacity: '0' } },
      },
      animation: {
        shimmer: 'shimmer 1.6s infinite',
        marquee: 'marquee 38s linear infinite',
        floaty: 'floaty 6s ease-in-out infinite',
        'spin-slow': 'spinSlow 28s linear infinite',
        speed: 'speed 1.1s ease-out infinite',
        ping2: 'ping2 1.8s cubic-bezier(0,0,.2,1) infinite',
      },
    },
  },
  plugins: [],
};

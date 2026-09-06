/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,jsx}'],
  theme: {
    extend: {
      colors: {
        // Lifted from the app's own token file so the site and the product
        // cannot drift apart.
        brand: {
          DEFAULT: '#16A34A',
          deep: '#017A33',
        },
        ink: {
          DEFAULT: '#1A1D1A',
          soft: '#3E4A3D',
          muted: '#94A3B8',
        },
        canvas: '#F8F9FA',
      },
      fontFamily: {
        // Cairo reads well for Arabic; the stack degrades to the platform's
        // own Arabic face if the webfont never arrives.
        sans: ['Cairo', 'Tahoma', 'Arial', 'sans-serif'],
      },
    },
  },
  plugins: [],
};

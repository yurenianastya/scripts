/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'light': '#D6CFCB',
        'pale': '#CCB7AE',
        'pink': '#A6808C',
        'dim': '#706677',
        'dark': '#565264',
      },
    }
  },
  plugins: [],
}


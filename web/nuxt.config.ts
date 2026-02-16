export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  modules: ['vuetify-nuxt-module'],

  vuetify: {
    moduleOptions: {
      /* module specific options */
    },
    vuetifyOptions: {
      theme: {
        defaultTheme: 'light',
        themes: {
          light: {
            colors: {
              primary: '#1a1a2e',
              secondary: '#16213e',
              accent: '#0f3460',
              surface: '#ffffff',
              background: '#f5f5f5',
              error: '#e74c3c',
              success: '#2ecc71',
            },
          },
        },
      },
      icons: {
        defaultSet: 'mdi',
        sets: ['mdi'],
      },
    },
  },

  runtimeConfig: {
    public: {
      apiBase: process.env.API_BASE_URL || 'http://localhost:3000',
    },
  },

  // Explicitly include MDI css
  css: ['@mdi/font/css/materialdesignicons.min.css'],
  vite: {
    server: {
      watch: {
        usePolling: true,
      },
    },
    ssr: {
      noExternal: ['vuetify'],
    },
  },
})

// src/stores/theme.ts

import { defineStore } from 'pinia'

const themeSettings = localStorage.getItem('themeSettings')
const initialTheme = themeSettings ? JSON.parse(themeSettings) : { darkTheme: false }

export const useThemeStore = defineStore('theme', {
  state: () => ({
    darkTheme: initialTheme.darkTheme,
  }),
  actions: {
    setToogleDarkTheme() {
      this.darkTheme = !this.darkTheme
      localStorage.setItem(
        'themeSettings',
        JSON.stringify({ ...initialTheme, darkTheme: this.darkTheme }),
      )
    },
  },
})

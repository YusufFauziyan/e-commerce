import { definePreset } from '@primevue/themes'
import Aura from '@primevue/themes/aura'
import { getPresetExt } from './pallete'

function getInitialTheme() {
  const savedTheme = localStorage.getItem('themeSettings')
  if (savedTheme) {
    const themeSettings = JSON.parse(savedTheme)

    return getPresetExt(themeSettings.primary)
  } else {
    return getPresetExt('noir')
  }
}

export const DefaultTheme = () => definePreset(Aura, getInitialTheme())

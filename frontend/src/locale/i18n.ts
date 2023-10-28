import i18n from "i18next"
import { initReactI18next } from "react-i18next"
import en from './en/translate.json'
import detector from "i18next-browser-languagedetector"

const resources = {
  en,
}

i18n
  .use(detector)
  .use(initReactI18next)
  .init({
    resources,
    fallbackLng: 'en', // use en if detected lng is not available
    keySeparator: '.',
    interpolation: {
      escapeValue: false
    },
    detection: {
      order: ['cookie'],
      caches: ['cookie']
    }
  })

export default i18n

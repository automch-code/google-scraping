import Cookies from 'js-cookie'

export const setRememberMe = (value: string) => (
  Cookies.set(
    'remember_me',
    value,
    {
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      expires: 365,
      path: '/',
      sameSite: 'strict'
    }
  )
)

export const setCurrentUser = (value: string) => (
  Cookies.set(
    'user',
    value,
    {
      ...(getRememberMe() === 'true' ? { expires: 3 } : {}),
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      path: '/',
      sameSite: 'strict'
    }
  )
)

export const setAccessToken = (token: string) => (
  Cookies.set(
    'access_token',
    token,
    {
      ...(getRememberMe() === 'true' ? { expires: new Date(new Date().getTime() + 10 * 60 * 1000) } : {}),
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      path: '/',
      sameSite: 'strict'
    }
  )
)

export const setRefreshToken = (token: string) => (
  Cookies.set(
    'refresh_token',
    token,
    {
      ...(getRememberMe() === 'true' ? { expires: 3 } : {}),
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      path: '/',
      sameSite: 'strict'
    }
  )
)

export const setTheme = (theme: string) => {
  Cookies.set(
    'theme',
    theme,
    {
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      path: '/',
      sameSite: 'strict'
    }
  )
}

export const setLocale = (locale: string) => {
  Cookies.set(
    'i18next',
    locale,
    {
      secure: process.env.NEXT_PUBLIC_APP_ENV !== 'development',
      path: '/',
      sameSite: 'strict'
    }
  )
}

export const getRememberMe = () => Cookies.get('remember_me')
export const getCurrentUser = () => Cookies.get('user') as string
export const getAccessToken = () => Cookies.get('access_token')
export const getRefreshToken = () => Cookies.get('refresh_token')
export const getTheme = () => Cookies.get('theme')
export const getLocale = () => Cookies.get('i18next')

export const destroyRememberMe = () => Cookies.remove('user')
export const destroyCurrentUser = () => Cookies.remove('user')
export const destroyAccessToken = () => Cookies.remove('access_token')
export const destroyRefreshToken = () => Cookies.remove('refresh_token')

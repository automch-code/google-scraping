import '@/styles/globals.css'
import type { AppProps, AppContext } from 'next/app'
import App from 'next/app'
import { CssBaseline } from '@mui/material'
import { CacheProvider, EmotionCache } from '@emotion/react'
import createEmotionCache from '@/createEmotionCache'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import jwt from 'jsonwebtoken'
import { wrapper } from '@/app/store'
import { CurrentUser } from '@/utils/interface'
import { useAppDispatch } from "@/app/hooks"
import { isEmpty } from 'lodash'
import i18n from '@/locale/i18n'
import nookies from 'nookies'
import NotiStack from '@/components/NotiStack'
import { setUserState } from '@/app/features/App'

const clientSideEmotionCache = createEmotionCache()

export interface MyAppProps extends AppProps {
  emotionCache?: EmotionCache
  user: {}
}

function MyApp(props: MyAppProps) {
  const { Component, pageProps, emotionCache = clientSideEmotionCache, user } = props
  const { isReady } = useRouter()
  const dispatch = useAppDispatch()

  useEffect(() => {
    if (!isEmpty(user)) dispatch(setUserState(user as CurrentUser))
  }, [user, dispatch])

  if (!isReady) return <></>

  return (
    <CacheProvider value={emotionCache}>
      <CssBaseline />
      <NotiStack>
        <Component {...pageProps} />
      </NotiStack>
    </CacheProvider>
  )
}

MyApp.getInitialProps = wrapper.getInitialAppProps(
  (store) => async (appContext: AppContext) => {
    const appProps = await App.getInitialProps(appContext)
    let user = {}
    try {
      i18n.changeLanguage(nookies.get(appContext.ctx).i18next)
      user = jwt.verify(nookies.get(appContext.ctx).user || '', process.env.JWT_SECRET_KEY || '')
    }
    catch (err) { console.log(err) }

    return { ...appProps, user }
  }
)

export default wrapper.withRedux(MyApp)
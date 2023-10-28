import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { useRouter } from 'next/router'
import { useEffect } from 'react'
import { wrapper } from '@/app/store'
import { CurrentUser } from '@/utils/interface'
import { useAppDispatch } from "@/app/hooks"
import { isEmpty } from 'lodash'
import { setUserState } from '@/app/features/App'

export interface MyAppProps extends AppProps {
  user: {}
}

function App(props: MyAppProps) {
  const { Component, pageProps, user } = props
  const { isReady } = useRouter()
  const dispatch = useAppDispatch()

  useEffect(() => {
    if (!isEmpty(user)) dispatch(setUserState(user as CurrentUser))
  }, [user, dispatch])

  if (!isReady) return <></>

  return (
    <Component {...pageProps} />
  )
}

export default wrapper.withRedux(App)
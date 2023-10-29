import { useEffect } from "react"
import { useRouter } from "next/router"
import type { NextPage } from 'next'

const RedirectPage: NextPage = () => {
  const router = useRouter()

  useEffect(() => {
    if (Boolean(router.query.to)) window.location.href = `/${router.asPath.split("?to=")[1]}`
  }, [router.query.to, router.asPath])

  return <></>
}

export default RedirectPage
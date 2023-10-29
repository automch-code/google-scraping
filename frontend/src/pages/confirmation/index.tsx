import { useConfirmationMutation } from "@/app/features/App/Api"
import { useRouter } from "next/router"
import { useEffect } from "react"
import type { NextPage } from 'next'

const Confirmation: NextPage = () => {
  const router = useRouter()
  const { confirmation_token } = router.query
  const [confirmation] = useConfirmationMutation()

  useEffect(() => { onSubmit() }, [])

  const onSubmit = async () => {
    try {
      debugger
      console.log(confirmation_token)
      await confirmation({ confirmation_token }).unwrap()
      router.push('/sign_in')
    } catch (error: any) { }
  }

  return <></>
}

export default Confirmation
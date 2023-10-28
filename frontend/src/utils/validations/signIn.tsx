import * as yup from 'yup'
import i18n from '@/locale/i18n'

const validationsSchema = yup.object({
  email: yup
    .string()
    .email(i18n.t('error.invalid', { name: i18n.t('email') }))
    .required(i18n.t('error.blank', { name: i18n.t('email') })),
  password: yup
    .string()
    .required(i18n.t('error.blank', { name: i18n.t('password') }))
})

export default validationsSchema
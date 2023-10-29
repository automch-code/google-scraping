import * as yup from 'yup'
import i18n from '@/locale/i18n'

const validationSchema = yup.object({
  email: yup
    .string()
    .email(i18n.t('error.invalid', { name: i18n.t('email') }))
    .required(i18n.t('error.blank', { name: i18n.t('email') })),
  password: yup
    .string()
    .min(6, i18n.t('error.minlength', { name: i18n.t('newPassword'), number: 6}))
    .max(128, i18n.t('error.maxlength', { name: i18n.t('newPassword'), number: 128 }))
    .required(i18n.t('error.blank', { name: i18n.t('newPassword') })),
  password_confirmation: yup
    .string()
    .min(6, i18n.t('error.minlength', { name: i18n.t('newPasswordConfirmation'), number: 6 }))
    .max(128, i18n.t('error.maxlength', { name: i18n.t('newPasswordConfirmation'), number: 128 }))
    .required(i18n.t('error.blank', { name: i18n.t('newPassword') }))
    .oneOf([yup.ref('password')], i18n.t('error.match', { name: i18n.t('newPasswordConfirmation') }))
})

export default validationSchema
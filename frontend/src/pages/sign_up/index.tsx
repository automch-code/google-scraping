import {
  Box, Avatar, Grid, Link, Typography, TextField, Container, IconButton, InputAdornment
} from '@mui/material'
import GoogleIcon from '@mui/icons-material/Google';
import LoadingButton from '@mui/lab/LoadingButton'
import ChevronRightIcon from '@mui/icons-material/ChevronRight';
import { useRegisterUserMutation } from "@/app/features/App/Api"
import type { NextPage } from "next"
import { useFormik } from 'formik'
import { useRouter } from "next/router"
import { useSnackbar } from "notistack"
import PublicLayout from '@/components/PublicLayout'
import { useTranslation } from "react-i18next"
import validationSchema from "@/utils/validations/signUp"
import { Visibility, VisibilityOff } from '@mui/icons-material'
import { useState } from 'react'


const SignUp: NextPage = () => {
  const [registration, { isLoading }] = useRegisterUserMutation()
  const { enqueueSnackbar } = useSnackbar()
  const { t } = useTranslation()
  const router = useRouter()
  const [showPassword, setShowPassword] = useState(false)
  const [showPasswordConfirm, setShowPasswordConfirm] = useState(false)

  const formik = useFormik({
    initialValues: { email: '', password: '', password_confirmation: '' },
    validationSchema,
    onSubmit: async (values) => {
      try {
        await registration({user: values}).unwrap()

        router.push('sign_in')
      } catch (error: any) {
        enqueueSnackbar(error.data.message, { variant: 'error' })
        return
      }
    }
  })

  return (
    <PublicLayout>
      <Box component="form" autoComplete="off" onSubmit={formik.handleSubmit}>
        <Container component="main" maxWidth="xs">
          <Box
            sx={{
              mt: 16,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
            }}
          >
            <Avatar sx={{ m: 1, bgcolor: 'secondary.main' }}>
              <GoogleIcon />
            </Avatar>
            <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
              {t('signUp')}
            </Typography>
            <Box sx={{ mt: 1 }}>
              <Grid container spacing={2}>
                <Grid item xs={12}>
                  <TextField
                    margin="dense"
                    fullWidth
                    label={t('email')}
                    id="email"
                    name="email"
                    onChange={formik.handleChange}
                    error={formik.touched.email && Boolean(formik.errors.email)}
                    helperText={formik.touched.email && formik.errors.email}
                    inputProps={{
                      "data-cy": "email"
                    }}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    margin="dense"
                    fullWidth
                    label={t('password')}
                    id="password"
                    name="password"
                    type={showPassword ? 'text' : 'password'}
                    onChange={formik.handleChange}
                    error={formik.touched.password && Boolean(formik.errors.password)}
                    helperText={formik.touched.password && formik.errors.password}
                    inputProps={{
                      "data-cy": "password",
                    }}
                    InputProps={{
                      endAdornment: (
                        <InputAdornment position="end">
                          <IconButton
                            onClick={() => setShowPassword(prev => !prev)}
                            edge="end"
                            data-cy="show-password"
                          >
                            {showPassword ? <Visibility /> : <VisibilityOff />}
                          </IconButton>
                        </InputAdornment>
                      )
                    }}
                  />
                </Grid>
                <Grid item xs={12}>
                  <TextField
                    margin="dense"
                    fullWidth
                    label={t('passwordConfirmation')}
                    id="password_confirmation"
                    name="password_confirmation"
                    type={showPasswordConfirm ? 'text' : 'password'}
                    onChange={formik.handleChange}
                    error={formik.touched.password_confirmation && Boolean(formik.errors.password_confirmation)}
                    helperText={formik.touched.password_confirmation && formik.errors.password_confirmation}
                    inputProps={{
                      "data-cy": "password-confirmation",
                    }}
                    InputProps={{
                      endAdornment: (
                        <InputAdornment position="end">
                          <IconButton
                            onClick={() => setShowPasswordConfirm(prev => !prev)}
                            edge="end"
                            data-cy="show-password-confirmation"
                          >
                            {showPasswordConfirm ? <Visibility /> : <VisibilityOff />}
                          </IconButton>
                        </InputAdornment>
                      )
                    }}
                  />
                </Grid>
              </Grid>
              <LoadingButton
                data-cy='submit'
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                loading={isLoading}
                loadingPosition="start"
                startIcon={<ChevronRightIcon />}
              >
                {t('signUp')}
              </LoadingButton>
              <Grid container justifyContent="flex-end">
                <Grid item>
                  <Link href="/sign_in" data-cy="sign_in" variant="body2">
                    {t('toSignIn')}
                  </Link>
                </Grid>
              </Grid>
            </Box>
          </Box>
        </Container>
      </Box>
    </PublicLayout>
  )
}

export default SignUp
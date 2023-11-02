import { useState } from 'react'
import type { NextPage } from 'next'
import {
  Avatar, TextField, FormControlLabel, Checkbox, Link, Box, Grid, Typography, Container, InputAdornment, IconButton
} from '@mui/material'
import GoogleIcon from '@mui/icons-material/Google';
import Visibility from '@mui/icons-material/Visibility'
import VisibilityOff from '@mui/icons-material/VisibilityOff'
import LoginIcon from '@mui/icons-material/Login';
import { useSignInMutation } from '@/app/features/App/Api'
import { useSnackbar } from 'notistack'
import { useFormik } from 'formik'
import validationSchema from '@/utils/validations/signIn'
import { useTranslation } from 'react-i18next'
import PublicLayout from '@/components/PublicLayout'
import LoadingButton from '@mui/lab/LoadingButton'

const SignIn: NextPage = () => {
  const { t } = useTranslation()
  const [signIn, { isLoading }] = useSignInMutation()
  const { enqueueSnackbar } = useSnackbar()
  const [showPassword, setShowPassword] = useState(false)
  const handleClickShowPassword = () => setShowPassword(show => !show)

  const formik = useFormik({
    initialValues: { email: '', password: '' },
    validationSchema,
    onSubmit: async (values) => {
      try {
        await signIn(values).unwrap()

        window.location.href = '/'
      } catch (error: any) {
        enqueueSnackbar(error.data.error_description, { variant: 'error' })
      }
    }
  })

  return (
    <PublicLayout>
      <Box component="form" onSubmit={formik.handleSubmit}>
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
              {t('signIn')}
            </Typography>
            <Box sx={{ mt: 1 }}>
              <TextField
                margin="normal"
                fullWidth
                label={t('email')}
                id="email"
                name="email"
                autoFocus
                onChange={formik.handleChange}
                error={formik.touched.email && Boolean(formik.errors.email)}
                helperText={formik.touched.email && formik.errors.email}
                inputProps={{
                  "data-cy": "email"
                }}
              />
              <TextField
                margin="normal"
                fullWidth
                label={t('password')}
                id="password"
                name="password"
                type={showPassword ? 'text' : 'password'}
                onChange={formik.handleChange}
                error={formik.touched.password && Boolean(formik.errors.password)}
                helperText={formik.touched.password && formik.errors.password}
                InputProps={{
                  endAdornment: (
                    <InputAdornment position="end">
                      <IconButton
                        onClick={handleClickShowPassword}
                        edge="end"
                        data-cy="show-pass"
                      >
                        {showPassword ? <Visibility /> : <VisibilityOff />}
                      </IconButton>
                    </InputAdornment>
                  )
                }}
              />
              <FormControlLabel
                control={<Checkbox value="remember" color="primary" />}
                label={<Typography sx={{ color: "text.primary" }}>{t('rememberMe')}</Typography>}
              />
              <LoadingButton
                data-cy='submit'
                type="submit"
                fullWidth
                variant="contained"
                sx={{ mt: 3, mb: 2 }}
                loading={isLoading}
                loadingPosition="start"
                startIcon={<LoginIcon />}
              >
                {t('signIn')}
              </LoadingButton>
              <Grid container justifyContent="flex-end">
                <Grid item>
                  <Link href="/sign_up" variant="body2">
                    {t('toSignUp')}
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

export default SignIn

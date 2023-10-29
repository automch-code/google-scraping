import { createRef, ReactNode } from 'react'
import { SnackbarKey, SnackbarProvider, useSnackbar } from 'notistack'
import CloseIcon from '@mui/icons-material/Close'
import { IconButton } from '@mui/material'

function SnackbarCloseButton({ snackbarKey }: { snackbarKey: SnackbarKey }) {
  const { closeSnackbar } = useSnackbar()

  return (
    <IconButton
      data-cy="close-noti"
      onClick={() => closeSnackbar(snackbarKey)}
      color="inherit"
    >
      <CloseIcon fontSize="small" />
    </IconButton>
  )
}

export default function NotiStack({ children }: { children: ReactNode }) {
  const notistackRef = createRef<any>()

  return (
    <SnackbarProvider
      ref={notistackRef}
      maxSnack={3}
      preventDuplicate={true}
      anchorOrigin={{ vertical: 'top', horizontal: 'right' }}
      action={(key: SnackbarKey) => <SnackbarCloseButton snackbarKey={key} />}
    >
      {children}
    </SnackbarProvider>
  )
}

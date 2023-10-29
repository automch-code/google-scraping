import * as React from "react"
import AppBar from "@mui/material/AppBar"
import Box from "@mui/material/Box"
import Toolbar from "@mui/material/Toolbar"
import IconButton from "@mui/material/IconButton"
import Typography from "@mui/material/Typography"
import MenuIcon from "@mui/icons-material/Menu"
import AccountCircle from "@mui/icons-material/AccountCircle"
import Button from "@mui/material/Button"
import { useTheme } from "@mui/material"
import LogoutIcon from "@mui/icons-material/Logout"
import { ColorModeContext } from "@/colorContext"
import { useRouter } from "next/router"
import { getAccessToken } from "@/utils/cookies"
import { useAppSelector } from "@/app/hooks"
import { CurrentUser } from "@/utils/interface"
import Drawer from "@mui/material/Drawer"
import { useTranslation } from "react-i18next"
import DrawerList from "@/components/Drawer"
import Menu from "@mui/material/Menu"
import MenuItem from "@mui/material/MenuItem"
import { setLocale } from "@/utils/cookies"
import Head from "next/head"
import i18n from "@/locale/i18n"
import { useSignOutMutation } from "@/app/features/App/Api"

const drawerWidth = 240

export default function PrivateLayout({
  children,
  title,
}: {
  children?: React.ReactNode
  title?: string
}) {
  const { t } = useTranslation()
  const theme = useTheme()
  const colorMode = React.useContext(ColorModeContext)
  const [mobileOpen, setMobileOpen] = React.useState(false)

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen)
  }

  const { username } = useAppSelector(
    (state: { app: CurrentUser }) => state.app
  )

  const router = useRouter()
  const [signOut] = useSignOutMutation()

  const onSignOut = async () => {
    try {
      await signOut({
        token: getAccessToken(),
        client_id: process.env.NEXT_PUBLIC_CLIENT_ID,
        client_secret: process.env.NEXT_PUBLIC_CLIENT_SECRET,
      }).unwrap()

      router.push("/sign_in")
    } catch (error: any) {
      console.log(error)
    }
  }

  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null)
  const open = Boolean(anchorEl)
  const handleClick = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget)
  }
  const handleClose = () => {
    setAnchorEl(null)
  }

  return (
    <Box sx={{ display: "flex" }}>
      <Head>
        <title>{title || t("appName")}</title>
      </Head>
      <AppBar
        position="fixed"
        sx={{
          width: { sm: `calc(100% - ${drawerWidth}px)` },
          ml: { sm: `${drawerWidth}px` },
        }}
      >
        <Toolbar>
          <IconButton
            edge="start"
            color="inherit"
            onClick={handleDrawerToggle}
            sx={{ mr: 2, display: { sm: "none" } }}
          >
            <MenuIcon />
          </IconButton>
          <Typography
            variant="h6"
            noWrap
            component="div"
            sx={{ display: { xs: "none", sm: "block" } }}
          >
            {t("appName")}
          </Typography>
          <Box sx={{ flexGrow: 1 }} />
          <Box>
            <Button
              color="inherit"
              startIcon={<AccountCircle />}
              onClick={() => router.push("/")}
            >
              {username}
            </Button>
            <IconButton
              size="large"
              edge="end"
              onClick={onSignOut}
              color="inherit"
            >
              <LogoutIcon />
            </IconButton>
          </Box>
        </Toolbar>
      </AppBar>
      <Box
        component="nav"
        sx={{ width: { sm: drawerWidth }, flexShrink: { sm: 0 } }}
      >
        <Drawer
          variant="temporary"
          open={mobileOpen}
          onClose={handleDrawerToggle}
          ModalProps={{
            keepMounted: true, // Better open performance on mobile.
          }}
          sx={{
            display: { xs: "block", sm: "none" },
            "& .MuiDrawer-paper": {
              boxSizing: "border-box",
              width: drawerWidth,
            },
          }}
        >
          <DrawerList />
        </Drawer>
        <Drawer
          variant="permanent"
          sx={{
            display: { xs: "none", sm: "block" },
            "& .MuiDrawer-paper": {
              boxSizing: "border-box",
              width: drawerWidth,
            },
          }}
          open
        >
          <DrawerList />
        </Drawer>
      </Box>
      <Box
        component="main"
        sx={{
          flexGrow: 1,
          p: 3,
          width: { sm: `calc(100% - ${drawerWidth}px)` },
        }}
      >
        <Toolbar />
        {children}
      </Box>
      <Menu
        anchorEl={anchorEl}
        id="account-menu"
        open={open}
        onClose={handleClose}
        onClick={handleClose}
        PaperProps={{
          elevation: 0,
          sx: {
            overflow: "visible",
            filter: "drop-shadow(0px 2px 8px rgba(0,0,0,0.32))",
            mt: 1.5,
            "& .MuiAvatar-root": {
              width: 32,
              height: 32,
              ml: -0.5,
              mr: 1,
            },
            "&:before": {
              content: '""',
              display: "block",
              position: "absolute",
              top: 0,
              right: 14,
              width: 10,
              height: 10,
              bgcolor: "background.paper",
              transform: "translateY(-50%) rotate(45deg)",
              zIndex: 0,
            },
          },
        }}
        transformOrigin={{ horizontal: "right", vertical: "top" }}
        anchorOrigin={{ horizontal: "right", vertical: "bottom" }}
      >
        {["en", "th"].map((locale) => (
          <MenuItem
            key={locale}
            onClick={() => {
              setLocale(locale)
              i18n.changeLanguage(locale)
            }}
          >
            {t(`locale.${locale}`)}
          </MenuItem>
        ))}
      </Menu>
    </Box>
  )
}

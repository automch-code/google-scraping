import Toolbar from '@mui/material/Toolbar'
import List from '@mui/material/List'
import Divider from '@mui/material/Divider'
import ListItem from '@mui/material/ListItem'
import ListItemButton from '@mui/material/ListItemButton'
import ListItemIcon from '@mui/material/ListItemIcon'
import ListItemText from '@mui/material/ListItemText'
import AccountCircle from '@mui/icons-material/AccountCircle'
import { useAppSelector } from '@/app/hooks'
import { useTranslation } from 'react-i18next'
import { compact, get } from 'lodash'
import { useRouter } from 'next/router'

export default function Drawer() {
  const { t } = useTranslation()
  const router = useRouter()
  const permissions = useAppSelector((state) => state.app.permissions)

  const list = compact(Object.entries({
    users: {
      name: t('users'),
      icon: <AccountCircle />,
      path: '/users'
    },
  }).map(([key, value]) => !!get(permissions, [key, 'index']) ? value : null))

  return (
    <div>
      <Toolbar />
      <Divider />
      <List>
        {list.map(({ name, icon, path }) => (
          <ListItem key={name} disablePadding onClick={() => router.push(path)}>
            <ListItemButton>
              <ListItemIcon>
                {icon}
              </ListItemIcon>
              <ListItemText primary={name} />
            </ListItemButton>
          </ListItem>
        ))}
      </List>
    </div>
  )
}

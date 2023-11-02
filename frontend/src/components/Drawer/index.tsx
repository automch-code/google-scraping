import Toolbar from '@mui/material/Toolbar'
import List from '@mui/material/List'
import Divider from '@mui/material/Divider'
import ListItem from '@mui/material/ListItem'
import ListItemButton from '@mui/material/ListItemButton'
import ListItemIcon from '@mui/material/ListItemIcon'
import ListItemText from '@mui/material/ListItemText'
import HistoryToggleOffIcon from '@mui/icons-material/HistoryToggleOff';
import GTranslateIcon from '@mui/icons-material/GTranslate';
import { useTranslation } from 'react-i18next'
import { compact, get } from 'lodash'
import { useRouter } from 'next/router'

export default function Drawer() {
  const { t } = useTranslation()
  const router = useRouter()

  const list = compact(Object.entries({
    users: {
      name: t('keywords'),
      icon: <GTranslateIcon />,
      path: '/keywords'
    },
    import: {
      name: t('importHistory'),
      icon: <HistoryToggleOffIcon />,
      path: '/history'
    }
  }).map(([_, value]) => value))

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

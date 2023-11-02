import { useGetKeywordQuery } from "@/app/features/App/Api"
import PrivateLayout from "@/components/PrivateLayout"
import { Box, Grid, Paper, Typography, styled } from "@mui/material"
import { useParams } from "next/navigation"
import { animated, useSpring } from "react-spring";
import AssistantIcon from '@mui/icons-material/Assistant';
import LinkIcon from '@mui/icons-material/Link';
import SearchIcon from '@mui/icons-material/Search';
import SpeedIcon from '@mui/icons-material/Speed';
import { useTranslation } from "react-i18next";
import parse from 'html-react-parser';

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(2),
  textAlign: 'center',
  color: theme.palette.text.secondary,
}));

function Number(numObject: { n: number }) {
  const n = Math.floor(numObject.n)
  const { number } = useSpring({
    from: { number: 0 },
    number: n,
    delay: 200,
    config: { mass: 1, tension: 20, friction: 10 }
  })
  
  return <animated.div>{number.to((n) => new Intl.NumberFormat().format(n.toFixed(0)))}</animated.div>
}

const Keyword = () => {
  const { t } = useTranslation();
  const params = useParams()
  const { isLoading, data } = useGetKeywordQuery(params!.id)

  return <PrivateLayout>
    {
      isLoading ? <></> :
        <Box sx={{ flexGrow: 1 }}>
          <Box mb={5}>
            <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
              {t('keywordTitle', { word: data.keyword.word })}
            </Typography>
          </Box>
          <Grid container spacing={1}>
            <Grid item xs={3}>
              <Item>
                <AssistantIcon />
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  <Number n={data.keyword.adwords} />
                </Typography>
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  {t('adWords')}
                </Typography>
              </Item>
            </Grid>
            <Grid item xs={3}>
              <Item>
                <LinkIcon />
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  <Number n={data.keyword.links} />
                </Typography>
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  {t('links')}
                </Typography>
              </Item>
            </Grid>
            <Grid item xs={3}>
              <Item>
                <SearchIcon />
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  <Number n={data.keyword.results} />
                </Typography>
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  {t('results')}
                </Typography>
              </Item>
            </Grid>
            <Grid item xs={3}>
              <Item>
                <SpeedIcon />
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  {data.keyword.rep_speed} 
                </Typography>
                <Typography component="h1" variant="h5" sx={{ color: "text.primary" }}>
                  {t('speed')}
                </Typography>
              </Item>
            </Grid>
          </Grid>
          <Box mt={2}>
            <Typography mb={2} component="h1" variant="h5" sx={{ color: "text.primary" }}>
              {t('preview')}
            </Typography>
            <Paper>
              <Box>{parse(data.keyword.html_text)}</Box>
            </Paper>
          </Box>
        </Box>
    }
  </PrivateLayout>
}

export default Keyword
import React, { useEffect, useState } from "react"
import PrivateLayout from "@/components/PrivateLayout"
import {
  Button,
  Stack,
  Box,
  Grid,
  OutlinedInput,
  Paper,
  InputAdornment,
  IconButton,
  styled,
  ButtonProps,
  TableContainer,
  Table,
  TableHead,
  TableRow,
  TableCell,
  TableCellProps,
  TableBody,
  TablePagination
} from "@mui/material"
import ClearIcon from '@mui/icons-material/Clear';
import ImportExportIcon from '@mui/icons-material/ImportExport';
import ArrowUpwardIcon from '@mui/icons-material/ArrowUpward';
import ArrowDownwardIcon from '@mui/icons-material/ArrowDownward';
import type { NextPage } from "next"
import { useRouter } from "next/router";
import { useTranslation } from "react-i18next";
import { isEmpty, debounce } from "lodash"
import { useGetImportsQuery } from "@/app/features/App/Api"
import SkeletonTable from "@/components/SkeletonTable";

const WhiteboxButton = styled(Button)<ButtonProps>(({ theme }) => ({
  color: theme.palette.getContrastText('#FFFFFF'),
  backgroundColor: '#FFFFFF',
  '&:hover': {
    backgroundColor: '#CCCCCC',
  },
}));

const TableHeadCell = styled(TableCell)<TableCellProps>(({ theme }) => ({
  color: '#212121'
}));


const Dashboard: NextPage = () => {
  const router = useRouter()
  const { t } = useTranslation()
  const page = parseInt(router.query.page as string) || 0
  const limit = parseInt(router.query.limit as string) || 15
  const query = (router.query.query) || ""
  const created_at = (router.query.created_at) || "DESC"
  const updated_at = (router.query.updated_at) || ""
  const { data, isLoading, isSuccess } = useGetImportsQuery(
    { page, limit, query, created_at, updated_at },
    { refetchOnMountOrArgChange: true }
  )
  const [searchValue, setSearchValue] = useState("")
  const [createDateSort, setCreateDateSort] = useState("DESC")
  const [updateDateSort, setUpdateDateSort] = useState("")

  const dateTimeToRead = (dateTimeStr: string) => {
    var datetime = new Date(dateTimeStr)
    return datetime.toLocaleString('en-TH', { timeZone: 'Asia/Bangkok' })
  }

  const handleChangePage = debounce((_, newPage: number) => {
    changeParams({ page: newPage })
  }, 200)

  const handleChangeRowsPerPage = debounce((event: React.ChangeEvent<HTMLInputElement>) => {
    changeParams({ limit: parseInt(event.target.value), page: 0 })
  }, 200)

  const handleSearchClickButton = (event: any) => {
    changeParams({ query: searchValue })
  }

  function switchSortState(state: string, setState: any, source: string) {
    if (state == "DESC") {
      setState("ASC")
    }
    else if (state == "ASC") {
      setState("DESC")
    }
    else {
      setState("DESC")
    }
    if (source == "create") {
      setUpdateDateSort("")
    }
    else if (source == "update") {
      setCreateDateSort("")
    }
  }

  function toggleSortIcon(toggleState: string) {
    if (toggleState == "ASC") {
      return (<ArrowDownwardIcon sx={{ color: "black" }} />)
    }
    else if (toggleState == "DESC") {
      return (<ArrowUpwardIcon sx={{ color: "black" }} />)
    }
    else {
      return (<ImportExportIcon sx={{ color: "darkgray" }} />)
    }
  }

  function toggleSortBtn(ItemID: string) {
    if (ItemID == "create_date") {
      return (<IconButton onClick={() => switchSortState(createDateSort, setCreateDateSort, "create")}>
        {toggleSortIcon(createDateSort)}
      </IconButton>
      )
    }
    else if (ItemID == "update_date") {
      return (<IconButton onClick={() => switchSortState(updateDateSort, setUpdateDateSort, "update")}>
        {toggleSortIcon(updateDateSort)}
      </IconButton>
      )
    }
    else {
      return
    }
  }

  const handleSortButton = () => {
    changeParams({ created_at: createDateSort, updated_at: updateDateSort })
  }

  const columns = [
    {
      id: "id",
      align: "left",
      label: t("ID"),
      hide: false,
    },
    {
      id: "filename",
      align: "left",
      label: t("filename"),
      hide: false,
    },
    {
      id: "create_date",
      align: "left",
      label: t("createDate"),
      hide: false,
    },
    {
      id: "update_date",
      align: "left",
      label: t("updateDate"),
      hide: false,
    }
  ]

  const changeParams = (params: any) => {
    router.push({
      pathname: router.pathname,
      query: {
        ...router.query,
        ...params
      },
    })
  }

  const handleClearSearchBtn = () => {
    setSearchValue("")
    changeParams({ query: "" })
  }

  useEffect(
    () => handleSortButton(),
    [createDateSort, updateDateSort])

  interface response {
    message: string
    file_upload: string
  }

  return (
    <PrivateLayout>
      <Stack>
        <Box sx={{ flexGrow: 1, mt: 3 }}>
          <Box sx={{ width: '100%' }}>
            <Grid container alignItems={"center"} spacing={1} width={"70%"}>
              <Grid item xs={6}>
                <OutlinedInput id="keyword"
                  fullWidth
                  name="keyword"
                  placeholder='Keyword'
                  value={searchValue}
                  onChange={(event) => setSearchValue(event.currentTarget.value)}
                  endAdornment={
                    <InputAdornment position="end">
                      <IconButton
                        aria-label="clear search action"
                        onClick={handleClearSearchBtn}
                        edge="end"
                      >
                        <ClearIcon />
                      </IconButton>
                    </InputAdornment>
                  }
                />
              </Grid>
              <Grid item xs={"auto"} sx={{ height: "100%" }}>
                <WhiteboxButton sx={{ height: "100%" }} variant="contained" onClick={handleSearchClickButton}>
                  Search
                </WhiteboxButton>
              </Grid>
            </Grid>
            <Paper sx={{ width: '100%', overflow: 'hidden', mt: 3 }}>
              <TableContainer component={Paper} sx={{ height: '600px' }}  >
                <Table sx={{ minWidth: 750 }} stickyHeader aria-labelledby="tableTitle">
                  <TableHead>
                    <TableRow>
                      {columns.map((column) => (
                        <TableHeadCell
                          sx={{ borderBottom: "none", backgroundColor: '#FAFAFA' }}
                          key={column.id}
                          align={column.align as "left" | "right" | "center"}
                        >
                          {column.label}
                          {
                            toggleSortBtn(column.id)
                          }
                        </TableHeadCell>
                      ))}
                    </TableRow>
                  </TableHead>
                  <TableBody>
                    {
                      isLoading ? <SkeletonTable rowsPerPage={limit} columns={columns.length} /> :
                        (isEmpty(data.import_hisotry) ? (
                          <TableRow>
                            <TableCell align="center" colSpan={6}>
                              {t("emptyList")}
                            </TableCell>
                          </TableRow>) : (
                          data.import_hisotry.map((row: any) => {
                            return (
                              <TableRow key={row.id}>
                                <TableCell component="th">{row.id}</TableCell>
                                <TableCell component="th">{row.filename}</TableCell>
                                <TableCell component="th">{dateTimeToRead(row.created_at)}</TableCell>
                                <TableCell component="th">{dateTimeToRead(row.updated_at)}</TableCell>
                                <TableCell component="th">{row.file}</TableCell>
                              </TableRow>
                            );
                          })
                        )
                        )
                    }
                  </TableBody>
                </Table>
              </TableContainer>
              <TablePagination
                rowsPerPageOptions={[15, 25, 50]}
                component="div"
                rowsPerPage={limit}
                page={page}
                count={-1}
                onPageChange={handleChangePage}
                onRowsPerPageChange={handleChangeRowsPerPage}
              />
            </Paper>
          </Box>
        </Box>
      </Stack>
    </PrivateLayout>
  )
}

export default Dashboard

import { Skeleton, TableRow, TableCell } from '@mui/material'

const SkeletonTable = (props: { rowsPerPage: number, columns: number }) => {
  const { rowsPerPage, columns } = props

  return (
    <>
      {
        [...Array(rowsPerPage)].map((_, index) =>
          <TableRow key={index}>
            {
              [...Array(columns)].map((_, colIndex) =>
                <TableCell key={colIndex}>
                  <Skeleton variant="rounded" />
                </TableCell>
              )
            }
          </TableRow>
        )
      }
    </>
  )
}

export default SkeletonTable
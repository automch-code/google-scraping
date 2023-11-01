import React from "react"
import PrivateLayout from "@/components/PrivateLayout"
import { Button, Stack } from "@mui/material"
import type { NextPage } from "next"
import { useFormik } from "formik"
import { useUploadMutation } from "@/app/features/App/Api"
import { useSnackbar } from "notistack"

const Dashboard: NextPage = () => {
  const { enqueueSnackbar } = useSnackbar()
  const [uploadCSV] = useUploadMutation()
  interface response {
    message: string
    file_upload: string
  }
  const formik = useFormik({
    initialValues: {
      file: "",
    },
    onSubmit: async (values) => {
      let formData = new FormData()
      const files = Object.values(values["file"])
      files.map((data, index) => {
        formData.append(`import[file]`, data)
      })
      try {
        const res = (await uploadCSV(formData).unwrap()) as response
        enqueueSnackbar(res["message"], { variant: "success" })
      } catch (error: any) {
        if (!!error) {
          console.log(error)
          enqueueSnackbar("Upload Faild", { variant: "error" })
        }
      }
    },
  })

  return (
    <PrivateLayout>
      <form onSubmit={formik.handleSubmit} encType="multipart/form-data">
        <Stack spacing={2} direction="row">
          <label htmlFor="file">
            <Button variant="contained" component="label">
              Upload File
              <input
                type="file"
                multiple
                style={{ display: "none" }}
                id="file"
                name="file"
                accept="text/csv"
                onChange={(e) =>
                  formik.setFieldValue("file", e.currentTarget.files)
                }
              />
            </Button>
          </label>
          <Button variant="contained" type="submit">
            Submit
          </Button>
        </Stack>
      </form>
    </PrivateLayout>
  )
}

export default Dashboard

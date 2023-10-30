import { appAPI } from "../app.query"

export const importAPI = appAPI.injectEndpoints({
  endpoints(builder) {
    return {
      getImports: builder.query({
        query: (params) => ({
          url: '/api/v1/import_histories',
          method: 'GET',
          params
        })
      }),
      upload: builder.mutation({
        query: (body) => {
          return {
            url: '/api/v1/import_histories/upload',
            method: 'POST',
            body
          }
        },
      })
    }
  }
})

export const {
  useGetImportsQuery,
  useUploadMutation
} = importAPI
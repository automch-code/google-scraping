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
      getStatus: builder.query({
        query: ({ id }) => ({
          url: `/api/v1/import_histories/${id}`,
          method: 'GET'
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
  useGetStatusQuery,
  useUploadMutation
} = importAPI
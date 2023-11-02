import { appAPI } from "../app.query"

export const keywordAPI = appAPI.injectEndpoints({
  endpoints(builder) {
    return {
      getKeywords: builder.query({
        query: (params) => {
          return {
            url: '/api/v1/keywords',
            method: 'GET',
            params
          }
        }
      }),
      getKeyword: builder.query({
        query: (id) => ({
          url: `/api/v1/keywords/${id}`,
        }),
        providesTags: ['Keyword']
      }),
    }
  }
})

export const {
  useGetKeywordsQuery,
  useGetKeywordQuery
} = keywordAPI
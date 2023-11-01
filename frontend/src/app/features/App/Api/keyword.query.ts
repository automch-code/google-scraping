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
      })
    }
  }
})

export const {
  useGetKeywordsQuery
} = keywordAPI
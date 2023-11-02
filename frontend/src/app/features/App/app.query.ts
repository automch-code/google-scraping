import { createApi } from '@reduxjs/toolkit/query/react'
import { HYDRATE } from 'next-redux-wrapper'
import customFetchBase from '../customFetchBase'

const reducerPath = 'appAPI'
export const appAPI = createApi({
  reducerPath,
  baseQuery: customFetchBase,
  tagTypes: ['Auth', 'User', 'Keyword'],
  extractRehydrationInfo(action, { reducerPath }) {
    if (action.type === HYDRATE) {
      return action.payload[reducerPath]
    }
  },
  endpoints: () => ({}),
})

export const appQueryReducer = { [reducerPath]: appAPI.reducer }
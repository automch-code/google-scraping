import { configureStore } from '@reduxjs/toolkit'
import { createWrapper } from 'next-redux-wrapper'

export const store = () => configureStore({
  reducer: {},
  middleware: []
})

export type AppStore = ReturnType<typeof store>
export type RootState = ReturnType<AppStore["getState"]>
export type AppDispatch = AppStore["dispatch"]

export const wrapper = createWrapper<AppStore>(store, { debug: false });
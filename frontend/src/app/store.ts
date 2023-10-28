import { configureStore } from '@reduxjs/toolkit'
import { combinedReducer } from './features'
import { createWrapper } from 'next-redux-wrapper'
import { appAPI } from './features/App/app.query'

export const store = () => configureStore({
  reducer: combinedReducer,
  middleware: (getDefaultMiddleware) => {
    return getDefaultMiddleware()
      .concat(appAPI.middleware)
  }
})

export type AppStore = ReturnType<typeof store>
export type RootState = ReturnType<AppStore["getState"]>
export type AppDispatch = AppStore["dispatch"]

export const wrapper = createWrapper<AppStore>(store, { debug: false });
import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { authAPI } from './Api/auth.query'
import {
  setAccessToken,
  setRefreshToken,
  destroyAccessToken,
  destroyRefreshToken,
  setCurrentUser,
  destroyCurrentUser,
} from '@/utils/cookies'
import { AuthState, CurrentUser } from '@/utils/interface'

export const initialState: CurrentUser = {
  email: '',
  role: ''
}

const reducerName = 'app'

export const appSlice = createSlice({
  name: reducerName,
  initialState,
  reducers: {
    setUserState: (state, { payload }: PayloadAction<CurrentUser>) => {
      state.email = payload.email
      state.role = payload.role
    },
    setAuthState: (state, { payload }: PayloadAction<AuthState>) => {
      setCurrentUser(payload.user as unknown as string)
      setAccessToken(payload.access_token)
      setRefreshToken(payload.refresh_token)
    },
    clearAuthState(state) {
      state.email = initialState.email
      state.role = initialState.role
      destroyCurrentUser()
      destroyAccessToken()
      destroyRefreshToken()
    }
  },
  extraReducers: builder => {
    builder.addMatcher(
      authAPI.endpoints.signIn.matchFulfilled,
      (state, { payload }: PayloadAction<AuthState>) => {
        setCurrentUser(payload.user as unknown as string)
        setAccessToken(payload.access_token)
        setRefreshToken(payload.refresh_token)
      }
    ).addMatcher(
      authAPI.endpoints.signOut.matchFulfilled,
      (state) => {
        state.email = initialState.email
        state.role = initialState.role
        destroyCurrentUser()
        destroyAccessToken()
        destroyRefreshToken()
      }
    )
  }
})

export const appSliceReducer = { [reducerName]: appSlice.reducer }

export const {
  setUserState,
  setAuthState,
  clearAuthState
} = appSlice.actions
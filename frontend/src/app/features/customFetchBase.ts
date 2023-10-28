import {
  BaseQueryFn,
  FetchArgs,
  FetchBaseQueryError,
  fetchBaseQuery,
} from '@reduxjs/toolkit/query'
import { getAccessToken, getRefreshToken } from '@/utils/cookies'
import { Mutex } from 'async-mutex'
import { AuthState } from '@/utils/interface'
import { setAuthState, clearAuthState } from '@/app/features/App'


const mutex = new Mutex()
const baseQuery = fetchBaseQuery({
  baseUrl: process.env.NEXT_PUBLIC_API_ENDPOINT,
  prepareHeaders(headers) {
    headers.set('authorization', `Bearer ${getAccessToken()}`)

    return headers
  }
})

const customFetchBase: BaseQueryFn<
  string | FetchArgs,
  unknown,
  FetchBaseQueryError
> = async (args, api, extraOptions) => {
  // wait until the mutex is available without locking it
  await mutex.waitForUnlock()
  let result = await baseQuery(args, api, extraOptions)
  if (result.error && result.error.status === 401) {
    // checking whether the mutex is locked
    if (!mutex.isLocked()) {
      const release = await mutex.acquire()
      try {
        const refreshResult = await baseQuery(
          {
            url: `/oauth/token`,
            method: "POST",
            body: {
              grant_type: "refresh_token",
              refresh_token: getRefreshToken(),
              client_id: process.env.NEXT_PUBLIC_CLIENT_ID,
              client_secret: process.env.NEXT_PUBLIC_CLIENT_SECRET
            },
          },
          api,
          extraOptions
        )
        if (refreshResult.data) {
          const { access_token, refresh_token, user }: AuthState = refreshResult.data as AuthState
          api.dispatch(setAuthState({ user, access_token, refresh_token }))
          // retry the initial query

          result = await baseQuery(args, api, extraOptions)
        } else {
          // logout with destroy access_token and refresh_token cookie
          api.dispatch(clearAuthState())

          if (window) window.location.href = '/sign_in'
        }
      } finally {
        // release must be called once the mutex should be released again.
        release()
      }
    } else {
      // wait until the mutex is available without locking it
      await mutex.waitForUnlock()
      result = await baseQuery(args, api, extraOptions)
    }
  } else if (result.error && result.error.status === 403 && window) window.location.href = '/403'
  else if (result.error && result.error.status === 404 && window) window.location.href = '/404'

  return result
}

export default customFetchBase
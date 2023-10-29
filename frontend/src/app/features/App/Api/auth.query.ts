import { getRefreshToken } from "@/utils/cookies"
import { appAPI } from "../app.query"

const baseBody = {
  client_id: process.env.NEXT_PUBLIC_CLIENT_ID,
  client_secret: process.env.NEXT_PUBLIC_CLIENT_SECRET,
}

const signInBody = { grant_type: 'password', ...baseBody }

export const authAPI = appAPI.injectEndpoints({
  endpoints(builder) {
    return {
      signIn: builder.mutation({
        query: (body) => ({
          url: '/oauth/token',
          method: 'POST',
          body: { ...signInBody, ...body  }
        })
      }),
      refreshToken: builder.mutation({
        query: () => ({
          url: '/oauth/token',
          method: 'POST',
          body: {
            grant_type: "refresh_token",
            refresh_token: getRefreshToken(),
            client_id: process.env.NEXT_PUBLIC_CLIENT_ID,
            client_secret: process.env.NEXT_PUBLIC_CLIENT_SECRET
          }
        }),
        invalidatesTags: ['Auth'],
      })
    }
  }
})

export const {
  useSignInMutation,
  useRefreshTokenMutation,
} = authAPI
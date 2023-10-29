import { appAPI } from "../app.query"

export const userAPI = appAPI.injectEndpoints({
  endpoints(builder) {
    return {
      confirmation: builder.mutation({
        query: ({ confirmation_token }) => {
          return {
            url: `/api/v1/users/confirmation?confirmation_token=${confirmation_token}`,
            method: 'GET'
          }
        },
        invalidatesTags: ['User']
      }),
      RegisterUser: builder.mutation({
        query: (body) => { 
          console.log(body)
          return ({
          url: '/api/v1/users/registration',
          method: 'POST',
          body: body
        })},
        invalidatesTags: ['User']
      })
    }
  }
})

export const {
  useRegisterUserMutation,
  useConfirmationMutation
} = userAPI
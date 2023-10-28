export interface AuthState {
  access_token: string
  refresh_token: string
  user: CurrentUser
}

export interface CurrentUser {
  username: string
  profile_image: string
  role: string
  permissions: any
}
export interface AuthState {
  access_token: string
  refresh_token: string
  user: CurrentUser
}

export interface CurrentUser {
  email: string,
  role: string
}
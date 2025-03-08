import { get, post } from '@/utils/api/apiHelper'

export const login = async (email, password) => {
  return await post('/auth/login', { email, password })
}

export const loginWithGoogle = async (token) => {
  return await post('/auth/google-login', { token })
}

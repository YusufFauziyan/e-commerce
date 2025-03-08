import { get, put } from '@/utils/api/apiHelper'

export const getUserInfo = async () => {
  return await get('/collection/user/me')
}

export const updateUserInfo = async (id, data) => {
  return await put(`/collection/user/${id}`, data)
}

export const getUserById = async (id) => {
  return await get(`/collection/user/${id}`)
}

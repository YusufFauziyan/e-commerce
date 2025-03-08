import { get, post, put, del } from '@/utils/api/apiHelper'

export const getAllAddress = async (params) => {
  return await get('/collection/address', params)
}

export const getAddressById = async (id) => {
  return await get(`/collection/address/${id}`)
}

export const createAddress = async (data) => {
  return await post('/collection/address', data)
}

export const updateAddress = async (id, data) => {
  return await put(`/collection/address/${id}`, data)
}

export const deleteAddress = async (id) => {
  return await del(`/collection/address/${id}`)
}

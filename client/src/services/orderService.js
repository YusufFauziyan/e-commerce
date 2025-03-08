import { get, post, put, del } from '@/utils/api/apiHelper'

export const getAllOrder = async (params) => {
  return await get('/collection/order', params)
}

export const getOrderById = async (id) => {
  return await get(`/collection/order/${id}`)
}

export const createOrder = async (data) => {
  return await post('/collection/order', data)
}

export const updateOrder = async (id, data) => {
  return await put(`/collection/order/${id}`, data)
}

export const deleteOrder = async (id) => {
  return await del(`/collection/order/${id}`)
}

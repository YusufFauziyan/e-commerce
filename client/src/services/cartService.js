import { get, post, put, del } from '@/utils/api/apiHelper'

export const getAllCart = async (params) => {
  return await get('/collection/cart', params)
}

export const getCartById = async (id) => {
  return await get(`/collection/cart/${id}`)
}

export const getTotalCart = async () => {
  return await get('/collection/cart/total')
}

export const createCart = async (cart) => {
  return await post('/collection/cart', cart)
}

export const updateCart = async (id, cart) => {
  return await put(`/collection/cart/${id}`, cart)
}

export const deleteCart = async (id) => {
  return await del(`/collection/cart/${id}`)
}

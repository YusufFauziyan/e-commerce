import { get, post, put, del } from '@/utils/api/apiHelper'

export const getAllProducts = async (params) => {
  return await get('/collection/product', params)
}

export const getProductById = async (id) => {
  return await get(`/collection/product/${id}`)
}

export const createProduct = async (product) => {
  return await post('/collection/product', product)
}

export const updateProduct = async (id, product) => {
  return await put(`/collection/product/${id}`, product)
}

export const deleteProduct = async (id) => {
  return await del(`/collection/product/${id}`)
}

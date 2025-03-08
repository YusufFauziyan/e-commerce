import { get, post, put, del } from '@/utils/api/apiHelper'

export const createPayment = async (data) => {
  return await post('/payment', data)
}

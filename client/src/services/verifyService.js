import { post } from '@/utils/api/apiHelper'

export const sendVerificationPhone = async (phoneNumber) => {
  return await post('/phone/send-verification', {
    phoneNumber: phoneNumber,
  })
}

export const verificationPhone = async (phoneNumber, code) => {
  return await post(`/phone/verify-code`, {
    phoneNumber,
    code,
  })
}

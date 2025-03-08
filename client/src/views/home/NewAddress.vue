<script setup>
import { ref, onMounted } from 'vue'

// package
import { useToast } from 'primevue/usetoast'

// form
import { useForm, useField } from 'vee-validate'
import * as yup from 'yup'
import { VueTelInput } from 'vue-tel-input'

// services
import { getAllAddress, createAddress, updateAddress } from '@/services/addressService'
import { getUserInfo, updateUserInfo } from '@/services/userService'
import { sendVerificationPhone, verificationPhone } from '@/services/verifyService'

// css
import 'vue-tel-input/vue-tel-input.css'

// validation
const schema = yup.object({
  addressTitle: yup.string().required('Address Title is required'),
  name: yup.string().required('Name is required'),
  surename: yup.string().required('Surename is required'),
  phone: yup.string().required('Phone is required'),
  city: yup.string().required('City is required'),
  zipCode: yup.number().required('Zip Code is required'),
  address: yup.string().required('Address is required'),
})

// use fun
const toast = useToast()

// ref
const user = ref({
  id: null,
  verified_phone_number: false,
  username: '',
  phone_number: '',
  surename: '',
})
const addressData = ref({
  id: null,
  street_address: '',
  city: '',
  postal_code: '',
  default_address: true,
  title_address: '',
})
const loadingSubmit = ref(false)
const dialogAddress = ref(false)
const otpValue = ref('')
const errorOtp = ref(false)
const countdown = ref(0)
const interval = ref(null)
const step = ref(1)

// form
const { handleSubmit, resetForm } = useForm({
  validationSchema: schema,
})

// definition field
const { value: addressTitle, errorMessage: addressTitleError } = useField('addressTitle')
const { value: name, errorMessage: nameError } = useField('name')
const { value: surename, errorMessage: surenameError } = useField('surename')
const { value: phone, errorMessage: phoneError } = useField('phone')
const { value: city, errorMessage: cityError } = useField('city')
const { value: zipCode, errorMessage: zipCodeError } = useField('zipCode')
const { value: address, errorMessage: addressError } = useField('address')

const startCountdown = () => {
  if (interval.value) clearInterval(interval.value) // Reset jika ada interval sebelumnya

  interval.value = setInterval(() => {
    if (countdown.value > 0) {
      countdown.value--
    } else {
      clearInterval(interval.value)
    }
  }, 1000)
}

// Submit form
const onSubmit = handleSubmit(async (values) => {
  console.log(values)
  loadingSubmit.value = true

  const payloadAddress = {
    title_address: values.addressTitle,
    street_address: values.address,
    city: values.city,
    postal_code: values.zipCode,
    default_address: true,
  }

  try {
    // Create address
    if (!addressData.value.id) {
      await createAddress({
        ...payloadAddress,
        user_id: user.value.id,
      })
    } else {
      await updateAddress(addressData.value.id, payloadAddress)
    }

    await updateUserInfo(user.value.id, {
      phone_number: values.phone,
      surename: values.surename,
    })

    await fetchUser()
  } catch (error) {
    const message = error?.response?.data?.message || 'Something when wrong.'
    toast.add({ severity: 'error', summary: 'Error Message', detail: message, life: 3000 })
    console.error(error)
  } finally {
    loadingSubmit.value = false
  }
})

const handleResendOtp = async () => {
  countdown.value = 60
  startCountdown()

  const cleanedPhone = user.value.phone_number.replace(/\s/g, '')

  try {
    await sendVerificationPhone(cleanedPhone)
  } catch (error) {
    console.log(error)
  }
}

const handleSubmitOtp = async () => {
  if (otpValue.value.length < 6) {
    errorOtp.value = true
    return
  }

  loadingSubmit.value = true

  // Pastikan user.value dan phone_number ada
  const phone = user.value?.phone_number ?? '' // Gunakan fallback jika undefined
  const cleanedPhone = typeof phone === 'string' ? phone.replace(/\s/g, '') : ''

  try {
    await verificationPhone(cleanedPhone, otpValue.value) // Gunakan `.value` untuk otpValue

    errorOtp.value = false
    toast.add({
      severity: 'success',
      summary: 'Success Message',
      detail: 'Success Verification',
      life: 3000,
    })
    fetchUser()
  } catch (error) {
    const message = error?.response?.data?.message || 'Something when wrong.'
    toast.add({ severity: 'error', summary: 'Error Message', detail: message, life: 3000 })
    console.error('Verification failed:', error)
  } finally {
    loadingSubmit.value = false
  }
}

// fetch address
const fetchAddress = async () => {
  try {
    const res = await getAllAddress()

    const findDefaultAddress = res.find((address) => address.default_address)
    if (findDefaultAddress) {
      addressData.value = findDefaultAddress

      dialogAddress.value = true
    }
  } catch (error) {
    console.error(error)
  }
}

const fetchUser = async () => {
  try {
    const res = await getUserInfo()

    user.value = res

    if (res.phone_number) {
      step.value = 2
    }

    if (res.verified_phone_number) {
      dialogAddress.value = false
    }
  } catch (error) {
    console.error(error)
  }
}

onMounted(async () => {
  await fetchUser()
  await fetchAddress()

  startCountdown()

  resetForm({
    values: {
      name: user.value?.username || '',
      phone: user.value?.phone_number || '',
      surename: user.value?.surename || '',
      addressTitle: addressData.value.title_address,
      city: addressData.value.city,
      zipCode: addressData.value.postal_code,
      address: addressData.value.street_address,
    },
  })
})
</script>

<template>
  <Dialog v-model:visible="dialogAddress" modal class="min-w-[30%]" #container="">
    <form v-if="step === 1" @submit.prevent="onSubmit">
      <div class="px-6 py-8 flex flex-col gap-6">
        <h1 class="text-2xl font-semibold text-surface-950 dark:text-surface-0">Add New Address</h1>
        <div class="grid grid-cols-2 gap-3">
          <div class="col-span-2">
            <label
              for="addressTitle"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Address Title</label
            >
            <InputText
              v-model="addressTitle"
              id="addressTitle"
              type="text"
              placeholder="Address Title"
              class="w-full"
              :invalid="!!addressTitleError"
              size="small"
            />
            <Message
              v-if="addressTitleError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ addressTitleError }}</Message
            >
          </div>
          <div class="">
            <label
              for="name"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Name</label
            >
            <InputText
              v-model="name"
              id="name"
              type="text"
              placeholder="Input your Name"
              class="w-full"
              :invalid="!!nameError"
              size="small"
            />
            <Message
              v-if="nameError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ nameError }}</Message
            >
          </div>
          <div class="">
            <label
              for="surename"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Surename</label
            >
            <InputText
              v-model="surename"
              id="surename"
              type="text"
              placeholder="Input your Surename"
              class="w-full"
              :invalid="!!surenameError"
              size="small"
            />
            <Message
              v-if="surenameError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ surenameError }}</Message
            >
          </div>
          <div class="col-span-2">
            <label
              for="phone"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Phone</label
            >

            <VueTelInput
              v-model="phone"
              id="phone"
              label="Input your Phone"
              defaultCountry="id"
              autoFormat
              mode="international"
              :inputOptions="{ required: true, type: 'tel' }"
            />
            <Message
              v-if="phoneError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ phoneError }}</Message
            >
          </div>
          <div class="">
            <label
              for="city"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >City</label
            >
            <InputText
              v-model="city"
              id="city"
              type="text"
              placeholder="Input your City"
              class="w-full"
              :invalid="!!cityError"
              size="small"
            />
            <Message
              v-if="cityError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ cityError }}</Message
            >
          </div>
          <div class="">
            <label
              for="zipCode"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Zip Code</label
            >
            <InputText
              v-model="zipCode"
              id="zipCode"
              type="number"
              placeholder="Input your Zip Code"
              class="w-full"
              :invalid="!!zipCodeError"
              size="small"
            />
            <Message
              v-if="zipCodeError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ zipCodeError }}</Message
            >
          </div>
          <div class="col-span-2">
            <label
              for="address"
              class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
              >Address</label
            >
            <Textarea
              v-model="address"
              id="address"
              rows="4"
              placeholder="Input your Address"
              class="w-full resize-none"
              :invalid="!!addressError"
              size="small"
            />
            <Message
              v-if="addressError"
              severity="error"
              variant="simple"
              size="small"
              class="mt-0.5"
              >{{ addressError }}</Message
            >
          </div>
        </div>
        <Button type="submit" label="Continue" size="small" :loading="loadingSubmit" />
      </div>
    </form>

    <div class="px-6 py-8 flex flex-col card justify-center items-center gap-2" v-if="step === 2">
      <h1 class="font-bold text-center text-xl">Verify you Phone Number</h1>
      <div class="my-3">
        <h1 class="text-center">Enter code we've sent to your inbox</h1>
        <p class="text-center font-semibold text-sm">{{ user.phone_number }}</p>
      </div>
      <div>
        <InputOtp v-model="otpValue" size="large" :length="6" :invalid="errorOtp" />
        <Message
          v-if="errorOtp"
          severity="error"
          variant="simple"
          size="small"
          class="mt-0.5 text-center"
        >
          Please fill all code
        </Message>
      </div>
      <div class="mt-4">
        <p v-if="countdown > 0" class="text-xs text-primary-600 text-center mb-1">
          Resend OTP in {{ countdown }} seconds
        </p>
        <div class="flex items-center gap-2 text-sm">
          <p>Didn't get the code?</p>
          <p
            :class="[
              countdown > 0
                ? 'opacity-50'
                : 'text-blue-500 hover:text-blue-400 duration-150 cursor-pointer',
              'font-semibold',
            ]"
            @click="handleResendOtp"
          >
            Resend it.
          </p>
        </div>
      </div>
      <div class="flex flex-col gap-2 w-full mt-4">
        <Button
          label="Submit"
          size="small"
          class="w-full"
          @click="handleSubmitOtp"
          :loading="loadingSubmit"
        />
        <Button
          label="Change Phone Number"
          icon="pi pi-angle-left"
          variant="text"
          size="small"
          class="w-full"
          @click="step = 1"
        />
      </div>
    </div>
  </Dialog>
</template>

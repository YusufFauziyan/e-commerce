<script setup>
import { ref, computed, onMounted } from 'vue'

// form
import { useForm, useField } from 'vee-validate'
import * as yup from 'yup'
import {
  createAddress,
  deleteAddress,
  getAllAddress,
  updateAddress,
} from '@/services/addressService'
import { useConfirm, useToast } from 'primevue'

// components

// hooks
const toast = useToast()

// define
const props = defineProps({
  user: {
    type: Object,
    required: true,
  },
})

// ref
const search = ref('')
const addressList = ref([])
const isEditAddress = ref(false)
const isAddAddress = ref(false)
const selectedAddress = ref(null)
const confirm = useConfirm()

// validation
const schema = yup.object({
  titleAddress: yup.string().required('Title Address is required'),
  city: yup.string().required('City is required'),
  postalCode: yup.string().required('Postal Code is required'),
  streetAddress: yup.string().required('Street Address is required'),
})

// form
const { handleSubmit, resetForm } = useForm({
  validationSchema: schema,
})

// define form
const { value: titleAddress, errorMessage: titleAddressError } = useField('titleAddress')
const { value: city, errorMessage: cityError } = useField('city')
const { value: postalCode, errorMessage: postalCodeError } = useField('postalCode')
const { value: streetAddress, errorMessage: streetAddressError } = useField('streetAddress')

// onsubmit
const onSubmit = handleSubmit(async (values) => {
  console.log(values)

  const payload = {
    title_address: values.titleAddress,
    city: values.city,
    postal_code: Number(values.postalCode),
    street_address: values.streetAddress,
    default_address: false,
  }

  try {
    if (selectedAddress.value) {
      await updateAddress(selectedAddress.value.id, payload)
    } else {
      await createAddress(payload)
    }

    fetchAddress()
    handleReset()
    toast.add({
      severity: 'success',
      summary: 'Success',
      detail: 'Address saved',
      life: 3000,
    })
  } catch (error) {
    console.log(error)
  }
})

// handle set default address
const handleSetDefaultAddress = async (id) => {
  addressList.value = addressList.value.map((address) => ({
    ...address,
    default_address: address.id === id,
  }))

  try {
    await Promise.all(addressList.value.map(({ id, ...rest }) => updateAddress(id, rest)))
  } catch (error) {
    console.log(error)
  }
}

const handleReset = () => {
  isAddAddress.value = false
  isEditAddress.value = false
  selectedAddress.value = null

  resetForm({
    values: {
      titleAddress: '',
      city: '',
      postalCode: '',
      streetAddress: '',
    },
  })
}

const handleEditAddress = (address) => {
  isEditAddress.value = true
  selectedAddress.value = address

  resetForm({
    values: {
      titleAddress: address.title_address,
      city: address.city,
      postalCode: address.postal_code,
      streetAddress: address.street_address,
    },
  })
}

const handleDeleteAddress = (event, address) => {
  confirm.require({
    target: event.currentTarget,
    message: 'Are you sure to delete this address?',
    icon: 'pi pi-info-circle',
    rejectProps: {
      label: 'Cancel',
      severity: 'secondary',
      outlined: true,
    },
    acceptProps: {
      label: 'Delete',
      severity: 'danger',
    },
    accept: async () => {
      // Delete cart
      try {
        await deleteAddress(address.id)

        // Update
        addressList.value = addressList.value.filter((item) => item.id !== address.id)
        toast.add({
          severity: 'success',
          summary: 'Deleted',
          detail: 'Address deleted',
          life: 3000,
        })
      } catch (error) {
        console.error('Failed to delete cart:', error)
      }
    },
  })
}

// fetch address
const fetchAddress = async () => {
  try {
    const response = await getAllAddress()

    addressList.value = response
  } catch (error) {
    console.log(error)
  }
}

// computed untuk filter address berdasarkan search
const filteredAddressList = computed(() => {
  return addressList.value.filter((address) =>
    address.title_address.toLowerCase().includes(search.value.toLowerCase()),
  )
})

// call api
onMounted(fetchAddress)
</script>

<template>
  <form @submit.prevent="onSubmit">
    <div v-if="!isAddAddress && !isEditAddress" class="py-4 px-6 flex flex-col gap-4">
      <p class="text-xl font-bold">Address Setting</p>

      <div class="flex items-center gap-2">
        <div class="w-full">
          <IconField>
            <InputIcon>
              <i class="pi pi-search"></i>
            </InputIcon>
            <InputText v-model="search" placeholder="Search the address here" class="w-full" />
          </IconField>
        </div>

        <Button
          type="button"
          label="Add Address"
          class="whitespace-nowrap"
          style="padding: 0.5rem 3rem"
          @click="isAddAddress = true"
        />
      </div>

      <div class="flex flex-col gap-4 mt-4">
        <p class="font-bold">Address List</p>

        <div
          v-if="filteredAddressList.length > 0"
          v-for="(address, index) in filteredAddressList"
          :key="index"
          :class="[
            'border rounded overflow-hidden shadow p-4 flex gap-4 items-start justify-between',
            { 'border-primary': address.default_address },
          ]"
        >
          <div class="flex flex-col gap-4">
            <div>
              <Tag
                v-if="address.default_address"
                severity="info"
                value="Default Address"
                rounded
                style="font-size: 0.7rem"
              />
            </div>
            <div>
              <p class="font-bold">{{ address.title_address }}</p>
              <p class="mt-1 text-sm opacity-75">
                {{ address.street_address }}, {{ address.city }}, {{ address.postal_code }}
              </p>
            </div>
            <div class="flex items-center gap-4">
              <Button label="Edit address" size="small" @click="handleEditAddress(address)" />
              <Button
                v-if="!address.default_address"
                label="Delete address"
                size="small"
                severity="danger"
                variant="text"
                @click="handleDeleteAddress($event, address)"
              />
            </div>
          </div>
          <div class="flex items-center">
            <Button
              :icon="address.default_address ? 'pi pi-check' : 'pi pi-bookmark'"
              severity="secondary"
              variant="text"
              rounded
              aria-label="Bookmark"
              @click="handleSetDefaultAddress(address.id)"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- add/edit address -->
    <div v-if="isAddAddress || isEditAddress" class="py-4 px-6 flex flex-col gap-4">
      <div class="flex items-center gap-4">
        <Button variant="text" icon="pi pi-arrow-left" @click="handleReset" />
        <p class="text-xl font-bold">{{ isAddAddress ? 'Add' : 'Edit' }} Address</p>
      </div>

      <div class="grid grid-cols-2 gap-4 w-full">
        <div class="col-span-2">
          <label
            for="titleAddress"
            class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
            >Address Title</label
          >
          <InputText
            v-model="titleAddress"
            id="titleAddress"
            placeholder="Input Title Address"
            class="w-full"
            :invalid="!!titleAddressError"
            size="small"
          />
          <Message
            v-if="titleAddressError"
            severity="error"
            variant="simple"
            size="small"
            class="mt-0.5"
            >{{ titleAddressError }}</Message
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
            placeholder="Input Title Address"
            class="w-full"
            :invalid="!!cityError"
            size="small"
          />
          <Message v-if="cityError" severity="error" variant="simple" size="small" class="mt-0.5">{{
            cityError
          }}</Message>
        </div>
        <div class="">
          <label
            for="postalCode"
            class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
            >Zip Code</label
          >
          <InputText
            v-model="postalCode"
            id="postalCode"
            placeholder="Input Zip Code"
            class="w-full"
            type="number"
            :invalid="!!postalCodeError"
            size="small"
          />
          <Message
            v-if="postalCodeError"
            severity="error"
            variant="simple"
            size="small"
            class="mt-0.5"
            >{{ postalCodeError }}</Message
          >
        </div>
        <div class="col-span-2">
          <label
            for="address"
            class="block text-sm text-surface-900 dark:text-surface-0 font-bold mb-1.5"
            >Address</label
          >
          <Textarea
            v-model="streetAddress"
            id="address"
            rows="4"
            placeholder="Input your Address"
            class="w-full resize-none"
            :invalid="!!streetAddressError"
            size="small"
          />
          <Message
            v-if="streetAddressError"
            severity="error"
            variant="simple"
            size="small"
            class="mt-0.5"
            >{{ streetAddressError }}</Message
          >
        </div>
        <div class="col-span-2 w-full">
          <Button type="submit" label="Save Address" class="w-full" />
        </div>
      </div>
    </div>
  </form>

  <ConfirmPopup></ConfirmPopup>
</template>

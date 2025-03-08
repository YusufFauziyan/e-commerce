<script setup>
import { onMounted, computed, ref } from 'vue'

// form
import { useForm, useField } from 'vee-validate'
import * as yup from 'yup'

//
import { useAuthStore } from '@/stores/auth'
import { getUserById } from '@/services/userService'
import { getAllAddress } from '@/services/addressService'
import { formatRupiah } from '@/utils/format-number'
import { useToast } from 'primevue'
import { createOrder } from '@/services/orderService'
import { createPayment } from '@/services/paymentService'
import { deleteCart } from '@/services/cartService'

// define
const props = defineProps({
  checkout: {
    type: Array,
    required: true,
  },
})

// hook
const { user } = useAuthStore()
const toast = useToast()

// ref
const loadingSubmit = ref(false)
const dialogChangeAddress = ref(false)
const selectedAddress = ref()
const listAddress = ref([])

// form

const showToast = (severity, summary, detail) => {
  toast.add({ severity, summary, detail, life: 3000 })
}

// submit form
const onSubmit = async () => {
  loadingSubmit.value = true

  const orders = props.checkout.map((item) => ({
    product_id: item.product.id,
    quantity: item.quantity,
  }))

  try {
    if (!selectedAddress.value.addressId)
      return showToast('error', 'Address', 'Your default address not found!')

    const order = await createOrder({
      status: 'Pending',
      address_id: selectedAddress.value.addressId,
      orders,
    })

    const { transactionToken } = await createPayment({ order_id: order.id })

    if (!transactionToken)
      return showToast('error', 'Transaction Failed', 'Could not create transaction.')

    window.snap.pay(transactionToken, {
      onSuccess: async () => {
        showToast('success', 'Payment Success', 'Thank you for your payment!')

        //   remove selected product from cart
        await Promise.all(
          props.checkout.map(async (item) => {
            await deleteCart(item.id)
          }),
        )
      },
      onPending: async () => {
        showToast('warn', 'Payment Pending', 'Your payment is being processed.')

        //   remove selected product from cart
        await Promise.all(
          props.checkout.map(async (item) => {
            await deleteCart(item.id)
          }),
        )
      },
      onError: () => showToast('error', 'Payment Failed', 'Please try again.'),
      onClose: () => console.log('Payment popup closed.'),
    })
  } catch (error) {
    console.error(error)
    showToast('error', 'Transaction Failed', 'Could not create transaction.')
  } finally {
    loadingSubmit.value = false
  }
}

const totalPrice = computed(() => {
  return props.checkout.reduce((acc, curr) => acc + curr.product.final_price * curr.quantity, 0)
})

const fetchAddress = async () => {
  try {
    const response = await getAllAddress()

    listAddress.value = response.map((address) => ({
      addressId: address.id,
      code: address.id,
      name: address.title_address,
      city: address.city,
      zipCode: Number(address.postal_code),
      address: `${address.street_address}, ${address.city}, ${address.postal_code}`,
    }))

    const filterDefaultAddress = response.filter((address) => address.default_address)[0]

    selectedAddress.value = {
      addressId: filterDefaultAddress.id,
      code: filterDefaultAddress.id,
      name: filterDefaultAddress.title_address,
      city: filterDefaultAddress.city,
      zipCode: Number(filterDefaultAddress.postal_code),
      address: `${filterDefaultAddress.street_address}, ${filterDefaultAddress.city}, ${filterDefaultAddress.postal_code}`,
    }
  } catch (error) {
    console.log(error)
  }
}

onMounted(fetchAddress)
</script>

<template>
  <main class="h-full">
    <form @submit.prevent="onSubmit">
      <div class="container py-12">
        <p class="font-bold text-xl">Shooping Cart</p>

        <div class="mt-12 grid grid-cols-3 gap-6">
          <div class="col-span-2">
            <div class="rounded-lg flex items-center gap-4 px-6 py-4 border shadow justify-between">
              <div class="flex items-center gap-4">
                <i class="pi pi-map-marker" style="font-size: 0.7rem"></i>

                <p class="font-bold text-xs">{{ selectedAddress?.name }}</p>
              </div>

              <div>
                <Button
                  label="Change Address"
                  size="small"
                  variant="text"
                  @click="dialogChangeAddress = true"
                />
              </div>
            </div>

            <div class="grid grid-cols-2 gap-3 mt-6">
              <div>
                <label
                  for="name"
                  class="block text-sm text-surface-900 dark:text-surface-0 font-semibold mb-1.5"
                  >Your Name</label
                >
                <InputText
                  :value="user?.username"
                  id="name"
                  type="text"
                  placeholder="Your Name"
                  class="w-full"
                  size="small"
                  readonly
                />
              </div>

              <div>
                <label
                  for="name"
                  class="block text-sm text-surface-900 dark:text-surface-0 font-semibold mb-1.5"
                  >Phone Number</label
                >
                <InputText
                  :value="user?.phone_number"
                  id="phone"
                  type="text"
                  placeholder="Phone"
                  class="w-full"
                  size="small"
                  readonly
                />
              </div>

              <div>
                <label
                  for="city"
                  class="block text-sm text-surface-900 dark:text-surface-0 font-semibold mb-1.5"
                  >City</label
                >
                <InputText
                  :value="selectedAddress?.city"
                  id="city"
                  type="text"
                  placeholder="City"
                  class="w-full"
                  size="small"
                  readonly
                />
              </div>

              <div>
                <label
                  for="city"
                  class="block text-sm text-surface-900 dark:text-surface-0 font-semibold mb-1.5"
                  >Zip Code</label
                >
                <InputText
                  :value="selectedAddress?.zipCode"
                  id="zipCode"
                  type="number"
                  placeholder="Zip Code"
                  class="w-full"
                  size="small"
                  readonly
                />
              </div>

              <div class="col-span-2">
                <label
                  for="city"
                  class="block text-sm text-surface-900 dark:text-surface-0 font-semibold mb-1.5"
                  >Address</label
                >
                <Textarea
                  :value="selectedAddress?.address"
                  id="address"
                  rows="4"
                  placeholder="Input your Address"
                  class="w-full resize-none col-span-2"
                  size="small"
                  readonly
                />
              </div>
            </div>
          </div>

          <div>
            <Card>
              <template #title>
                <p class="text-base font-bold m-0">Your Order</p>
              </template>
              <template #subtitle>
                <Divider style="margin: 0" />
              </template>
              <template #content>
                <div class="flex flex-col gap-3 pt-2">
                  <div
                    class="flex gap-4 border-b pb-3"
                    v-for="(item, index) in checkout"
                    :key="index"
                  >
                    <div
                      class="rounded border overflow-hidden bg-primary-100 w-[100px] h-[100px] flex items-center justify-center"
                    >
                      <img
                        :src="item?.product?.images[0]?.url"
                        alt="Main Product"
                        class="object-cover"
                      />
                    </div>

                    <div class="flex-1 flex-col flex items-start gap-2">
                      <p class="font-extrabold text-ellipsis text-sm line-clamp-1">
                        {{ item.product.name }}
                      </p>
                      <div class="flex items-center gap-1 text-xs">
                        <p class="font-bold">
                          {{ formatRupiah(Number(item.product.final_price)) }}
                        </p>
                        <span class="opacity-55">x</span>
                        <p>
                          {{ item.quantity }}
                        </p>
                      </div>

                      <div class="text-xs text-right w-full mt-2">
                        <p>Total Price</p>
                        <p class="font-bold text-xs">
                          {{ formatRupiah(Number(item.product.final_price) * item.quantity) }}
                        </p>
                      </div>
                    </div>
                  </div>

                  <div class="flex flex-col gap-2 text-sm border-b py-3">
                    <div class="flex justify-between items-center gap-4">
                      <p class="font-medium">Total Price</p>
                      <p class="font-bold">
                        {{ formatRupiah(totalPrice) }}
                      </p>
                    </div>
                    <div class="flex justify-between items-center gap-4">
                      <p class="font-medium">Shipping</p>
                      <p class="font-bold">
                        {{ formatRupiah(0) }}
                      </p>
                    </div>
                    <div class="flex justify-between items-center gap-4">
                      <p class="font-medium">Voucher</p>
                      <p class="font-bold">- {{ formatRupiah(0) }}</p>
                    </div>
                  </div>

                  <div class="flex justify-between items-center gap-4 py-3">
                    <p class="font-medium">Total Payment</p>
                    <p class="font-extrabold">
                      {{ formatRupiah(totalPrice) }}
                    </p>
                  </div>
                </div>
              </template>
            </Card>
            <div class="flex flex-col gap-2 mt-4">
              <p class="text-xs text-primary/50 font-bold">* Make sure your Address is correct</p>
              <Button
                label="Pay Now"
                type="submit"
                class="w-full"
                variant="primary"
                size="small"
                icon="pi pi-wallet"
              />
            </div>
          </div>
        </div>
      </div>
    </form>
  </main>

  <Dialog
    v-model:visible="dialogChangeAddress"
    modal
    header="Edit Address"
    :style="{ width: '25rem' }"
  >
    <div class="mb-4">
      <Select
        v-model="selectedAddress"
        :options="listAddress"
        optionLabel="name"
        placeholder="Select address"
        class="w-full"
      />
    </div>

    <div class="flex justify-end gap-2">
      <Button
        type="button"
        label="Cancel"
        severity="secondary"
        @click="dialogChangeAddress = false"
      ></Button>
      <Button type="button" label="Save" @click="dialogChangeAddress = false"></Button>
    </div>
  </Dialog>
</template>

<style scoped>
img {
  mix-blend-mode: multiply;
}
</style>

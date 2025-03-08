<script setup>
import { ref, toRefs, onMounted, computed } from 'vue'
import { getAllOrder, getOrderById } from '@/services/orderService'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { formatRupiah } from '@/utils/format-number'

const props = defineProps(['id'])

// hooks
const { user } = useAuthStore()
const router = useRouter()

// ref
const { id } = toRefs(props)
const transaction = ref({})
const loading = ref(true)

// handle
const handleNavigateProduct = (id) => {
  router.push({
    name: 'ShopDetail',
    params: { id },
  })
}

// function
const getSeverity = (status) => {
  switch (status) {
    case 'cancelled':
      return 'danger'
    case 'paid':
    case 'settlement':
      return 'success'
    case 'shipped':
      return 'info'
    case 'pending':
      return 'warn'
    case 'delivered':
      return 'primary'
  }
}

const subtotal = computed(() => {
  return transaction.value?.orders?.reduce((acc, cart) => {
    return acc + Number(cart.product.final_price) * cart.quantity
  }, 0)
})

// fetch
const fetchTransaction = async () => {
  loading.value = true

  try {
    const res = await getOrderById(id.value)

    transaction.value = res
  } catch (error) {
    console.log(error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchTransaction()
})
</script>

<template>
  <main class="my-8">
    <div class="flex items-start justify-between">
      <div class="flex flex-col gap-2">
        <p class="font-bold text-lg">Transaction Detail</p>
        <p class="text-sm text-gray-500">Transaction ID: {{ id }}</p>
      </div>

      <Tag
        :value="transaction?.payment?.transaction_status"
        :severity="getSeverity(transaction?.payment?.transaction_status)"
      />
    </div>
    <div class="my-12 flex flex-col gap-6">
      <div class="grid grid-cols-3 gap-2">
        <div>
          <p class="font-bold">Shiiping Address (Buyer)</p>
          <p class="font-medium mt-2">{{ user?.username }}</p>
          <p class="text-sm text-gray-500">
            {{ transaction?.address?.street_address }}, {{ transaction?.address?.city }},
            {{ transaction?.address?.postal_code }}
          </p>
        </div>
      </div>

      <Divider />

      <div>
        <p class="font-bold text-lg mb-4">Order Item</p>

        <div class="flex flex-col gap-6">
          <div
            v-for="(order, index) in transaction.orders"
            :key="index"
            class="flex flex-col gap-4"
          >
            <div class="flex items-center gap-2">
              <Avatar
                :image="order.product.seller.avatar.url"
                :alt="order.product.seller.username"
                shape="circle"
                class="shadow"
              />
              <p class="text-sm font-medium">{{ order.product.seller.username }}</p>
            </div>

            <div class="grid grid-cols-3 gap-4">
              <div class="flex gap-4 col-span-2">
                <div
                  class="flex-1 rounded border overflow-hidden bg-primary-100 inline-block max-w-[100px] h-full"
                >
                  <img
                    :src="order.product.images[0].url"
                    :alt="order.product.name"
                    class="w-full h-full object-contain"
                  />
                </div>
                <div class="flex flex-col gap-2 justify-between">
                  <div class="space-y-2">
                    <div class="flex items-center gap-2">
                      <div
                        class="border px-2 py-1 rounded-xl w-fit"
                        v-for="(category, i) in order.product.categories"
                        :key="i"
                      >
                        <p class="text-xs text-primary font-medium">{{ category }}</p>
                      </div>
                    </div>
                    <div>
                      <p class="font-bold">
                        {{ order.product.name }}
                      </p>
                      <p class="line-clamp-2 max-w-80 text-xs mt-1">
                        {{ order.product.description }}
                      </p>
                    </div>
                  </div>
                  <p
                    class="font-medium text-xs text-blue-500 hover:underline cursor-pointer"
                    @click="handleNavigateProduct(order.product.id)"
                  >
                    Go to Product
                    <i class="pi pi-angle-right" style="font-size: 0.5rem" />
                  </p>
                </div>
              </div>

              <p class="font-bold text-sm">
                {{ order.quantity }} x {{ formatRupiah(Number(order.product.final_price || 0)) }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <Divider />

      <div>
        <p class="font-bold text-lg">Transaction</p>

        <div class="grid grid-cols-3 gap-4 mt-4">
          <div>
            <p class="font-medium">Subtotal</p>
            <p class="text-sm text-gray-500">{{ formatRupiah(subtotal || 0) }}</p>
          </div>
          <div>
            <p class="font-medium">Shipping Fee</p>
            <p class="text-sm text-gray-500">Rp 0</p>
          </div>
          <div>
            <p class="font-medium">Total</p>
            <p class="text-sm text-gray-500">{{ formatRupiah(subtotal || 0) }}</p>
          </div>
          <div>
            <p class="font-medium">Payment Method</p>
            <p class="text-sm text-gray-500 capitalize">
              {{ transaction?.payment?.payment_type.replace('_', ' ') }}
            </p>
          </div>
          <div v-if="transaction?.payment?.transaction_status === 'pending'">
            <p class="font-medium">Continue Payment</p>
            <a
              :href="transaction?.payment?.payment_link"
              target="_blank"
              class="text-blue-500 hover:underline text-sm"
              >Payment Here</a
            >
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<style scoped>
img {
  mix-blend-mode: multiply;
}

.p-dialog-header {
  display: none !important;
}
</style>

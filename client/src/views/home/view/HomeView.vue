<script setup>
import { ref, onMounted, watchEffect, watch, computed } from 'vue'

import Banner from '../Banner.vue'
import NewProduct from '../NewProduct.vue'
import TopSelling from '../TopSelling.vue'
import DressStyle from '../DressStyle.vue'
import HappyCustomer from '../HappyCustomer.vue'
import { getAllProducts } from '@/services/productService'
import { handleApiError } from '@/utils/api/apiErrorHandler'
import { useAuthStore } from '@/stores/auth'

import NewAddress from '../NewAddress.vue'

// store
const authStore = useAuthStore()

// ref
const newProducts = ref([])
const soldProducts = ref([])
const loading = ref(true)
const dialogAddress = ref(false)

// computed
const hasAddress = computed(() => {
  return authStore.user?.address && authStore.user?.zip_code && authStore.user?.phone_number
})

// fetch products
const fetchNewestProducts = async () => {
  loading.value = true
  try {
    const { products } = await getAllProducts({ page: 1, limit: 4 })
    newProducts.value = products
    loading.value = false
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  }
}

const fetchSoldestProducts = async () => {
  loading.value = true
  try {
    const { products } = await getAllProducts({ page: 1, limit: 4, orderBy: 'sold_quantity' })
    soldProducts.value = products
    loading.value = false
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  }
}

watch(
  () => authStore.user,
  (user) => {
    if (user && !hasAddress.value) {
      dialogAddress.value = true
    }
  },
  { immediate: true },
)

onMounted(() => {
  fetchNewestProducts()
  fetchSoldestProducts()
})

watchEffect(() => {})
</script>

<template>
  <main>
    <Banner />

    <NewProduct :products="newProducts" />
    <div class="border-b w-full" />
    <TopSelling :products="soldProducts" />
    <DressStyle />
    <HappyCustomer />

    <NewAddress v-if="authStore.user && !authStore.user?.verified_phone_number" />
  </main>
</template>

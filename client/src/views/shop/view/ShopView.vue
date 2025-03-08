<script setup>
import { ref, onMounted, watchEffect, watch, computed } from 'vue'

import Sidebar from '../Sidebar.vue'
import ListProduct from '../ListProduct.vue'
import { getAllProducts } from '@/services/productService'

// ref
const loadingProducts = ref(true)
const products = ref([])

const fetchProducts = async () => {
  loadingProducts.value = true
  try {
    const res = await getAllProducts({ page: 1, limit: 9, orderBy: 'sold_quantity' })
    products.value = res.products
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  } finally {
    loadingProducts.value = false
  }
}

onMounted(() => {
  fetchProducts()
})
</script>

<template>
  <main class="flex gap-8 my-4">
    <Sidebar />

    <ListProduct :products="products" />
  </main>
</template>

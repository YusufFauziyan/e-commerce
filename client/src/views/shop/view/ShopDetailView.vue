<script setup>
import { ref, toRefs, onMounted } from 'vue'

// services
import { getProductById } from '@/services/productService'
import { handleApiError } from '@/utils/api'

import DescriptionProduct from '../DescriptionProduct.vue'
import RatingProduct from '../RatingProduct.vue'

const props = defineProps(['id'])

//ref
const { id } = toRefs(props)
const product = ref(null)
const loadingProduct = ref(true)

const fetchProduct = async () => {
  loadingProduct.value = true
  try {
    const res = await getProductById(id.value)
    product.value = res
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  } finally {
    loadingProduct.value = false
  }
}

onMounted(() => {
  fetchProduct()
})
</script>

<template>
  <main>
    <DescriptionProduct :product="product" />

    <div class="my-12">
      <RatingProduct :product="product" />
    </div>
  </main>
</template>

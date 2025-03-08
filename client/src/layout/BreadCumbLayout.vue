<script setup>
import { ref, computed, watch, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { getProductById } from '@/services/productService' // Import API service
import { handleApiError } from '@/utils/api'

const route = useRoute()

// Refs
const productName = ref('')
const home = ref({
  label: 'Home',
  route: '/',
})

// Funciton for fetching product by ID
const fetchProductById = async (id) => {
  try {
    const res = await getProductById(id)
    productName.value = res.name
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  }
}

// Computed items for breadcrumb
const items = computed(() => {
  const pathSegments = route.path.split('/').filter((segment) => segment !== '')
  const breadcrumbItems = []

  let currentPath = ''
  pathSegments.forEach((segment, index) => {
    currentPath += `/${segment}`

    // Set label for each segment
    let label = segment
    if (segment.match(/^\d+$/) && productName.value) {
      label = productName.value // Replace with productName if ID
    } else {
      label = segment.charAt(0).toUpperCase() + segment.slice(1)
    }

    breadcrumbItems.push({
      label: label.length > 25 ? productName.value || label : label, // Set label
      route: index < pathSegments.length - 1 ? currentPath : null,
    })
  })

  return breadcrumbItems
})

// Check for product ID in URL
const checkForProductId = () => {
  if (!route.path.includes('shop')) return

  console.log('Checking for product ID in:', route.path) // Debug log
  const pathSegments = route.path.split('/').filter((segment) => segment !== '')
  const productId = pathSegments.find((segment) => segment.length > 25)

  if (productId) {
    fetchProductById(productId)
  }
}

// Watch route path
watch(() => route.path, checkForProductId, { immediate: true })
</script>

<template>
  <div class="container">
    <Breadcrumb :home="home" :model="items" class="text-xs" style="background-color: transparent">
      <template #item="{ item, props }">
        <router-link v-if="item.route" v-slot="{ href, navigate }" :to="item.route" custom>
          <a :href="href" v-bind="props.action" @click="navigate">
            <span class="font-semibold">{{ item.label }}</span>
          </a>
        </router-link>
        <a v-else :href="item.url" :target="item.target" v-bind="props.action">
          <span class="text-surface-700 dark:text-surface-0">{{ item.label }}</span>
        </a>
      </template>
    </Breadcrumb>

    <router-view></router-view>
  </div>
</template>

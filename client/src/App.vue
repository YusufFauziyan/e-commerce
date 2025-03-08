<script setup>
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'

const authStore = useAuthStore()
const cartStore = useCartStore()

// initialize session
authStore.initializeSession()
cartStore.initializeChart()
</script>

<template>
  <router-view />
</template>

<style scoped></style>

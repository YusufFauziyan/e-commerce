// src/stores/auth.ts
import { getTotalCart } from '@/services/cartService'
import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', {
  state: () => ({
    totalCart: null, // Data user, bisa diatur sesuai kebutuhan
  }),
  actions: {
    setTotalCart(totalCart) {
      this.totalCart = totalCart
    },

    // initialize session
    async initializeChart() {
      const token = localStorage.getItem('access_token')
      if (token) {
        try {
          // Panggil API untuk mendapatkan data cart
          const { total } = await getTotalCart()

          // Simpan data cart ke store
          this.setTotalCart(total)
        } catch (error) {
          console.error('Failed to fetch cart:', error)
        }
      }
    },
  },
})

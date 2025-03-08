import AppLayout from '@/layout/AppLayout.vue'
import BreadCumbLayoutVue from '@/layout/BreadCumbLayout.vue'
import { createRouter, createWebHistory } from 'vue-router'

// function required auth
function requireAuth(to, from, next) {
  const token = localStorage.getItem('access_token') // Get token from localStorage
  if (!token) {
    next({ name: 'Login' }) // Redirect to login page if token not found
  } else {
    next() // Continue to the next route
  }
}

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: AppLayout,
      children: [
        {
          path: '/',
          name: 'dashboard',
          component: () => import('@/views/home/view/HomeView.vue'),
        },
        {
          path: '/',
          component: BreadCumbLayoutVue,
          children: [
            {
              path: '/shop',
              name: 'Shop',
              component: () => import('@/views/shop/view/ShopView.vue'),
            },
            {
              path: '/shop/:id',
              name: 'ShopDetail',
              component: () => import('@/views/shop/view/ShopDetailView.vue'),
              props: true,
            },
            {
              path: '/cart',
              name: 'Cart',
              component: () => import('@/views/cart/view/CartView.vue'),
              beforeEnter: requireAuth,
            },
            {
              path: '/transaction',
              name: 'Transaction',
              component: () => import('@/views/transaction/view/TransactionView.vue'),
              beforeEnter: requireAuth,
            },
            {
              path: '/transaction/:id',
              name: 'TransactionDetail',
              component: () => import('@/views/transaction/view/TransactionDetailView.vue'),
              props: true,
            },
          ],
        },
      ],
    },
    {
      path: '/login',
      name: 'Login',
      component: () => import('@/views/login/view/LoginView.vue'),
    },
  ],
  scrollBehavior(to, from, savedPosition) {
    // Selalu scroll ke atas saat berpindah rute
    return { top: 0 }
  },
})

export default router

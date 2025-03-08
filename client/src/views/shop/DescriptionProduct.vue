<script setup>
import { useRouter } from 'vue-router'
import { ref, toRefs, watch } from 'vue'
import { formatRupiah } from '@/utils/format-number'
import { useToast } from 'primevue'
import { faker } from '@faker-js/faker'

// api
import { createOrder } from '@/services/orderService'
import { getAllAddress } from '@/services/addressService'
import { createPayment } from '@/services/paymentService'
import { getUserById } from '@/services/userService'
import { createCart, getAllCart, updateCart } from '@/services/cartService'

// store
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'

// components

const props = defineProps({
  product: {
    type: Object,
    required: true,
  },
})

// hook
const router = useRouter()
const toast = useToast()

// store
const authStore = useAuthStore()
const cartStore = useCartStore()

// ref
const { product } = toRefs(props)
const seller = ref(null)
const countProduct = ref(1)
const selectedImage = ref(0)
const loadingSubmit = ref(false)
const loadingAddToCart = ref(false)
const carts = ref()

const increment = () => {
  if (countProduct.value >= product.value.stock_quantity) return
  countProduct.value++
}

const decrement = () => {
  if (countProduct.value <= 1) return

  countProduct.value--
}

const showToast = (severity, summary, detail) => {
  toast.add({ severity, summary, detail, life: 3000 })
}

const handleBuyNow = async () => {
  if (!authStore.user) {
    return router.push({ name: 'Login', query: { returnTo: router.currentRoute.value.fullPath } })
  }

  loadingSubmit.value = true

  try {
    const findAddress = (await getAllAddress()).find((item) => item.default_address)
    if (!findAddress)
      return showToast('error', 'Default Address', 'Your default address not found!')

    const order = await createOrder({
      status: 'Pending',
      address_id: findAddress.id,
      orders: [{ product_id: product.value.id, quantity: countProduct.value }],
    })

    const { transactionToken } = await createPayment({ order_id: order.id })
    if (!transactionToken)
      return showToast('error', 'Transaction Failed', 'Could not create transaction.')

    window.snap.pay(transactionToken, {
      onSuccess: () => showToast('success', 'Payment Success', 'Thank you for your payment!'),
      onPending: () => showToast('warn', 'Payment Pending', 'Your payment is being processed.'),
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

const handleAddToCart = async () => {
  if (!authStore.user) {
    return router.push({ name: 'Login', query: { returnTo: router.currentRoute.value.fullPath } })
  }

  loadingAddToCart.value = true

  try {
    if (carts?.value?.items.some((item) => item.product_id === product.value.id)) {
      const cart = carts.value.items.find((item) => item.product_id === product.value.id)
      updateCart(cart.id, {
        quantity: cart.quantity + countProduct.value,
      })
      cart.quantity += countProduct.value
      showToast('success', 'Add to Cart', 'Product has been added to cart.')

      return
    }

    await createCart({
      product_id: product.value.id,
      quantity: countProduct.value,
    })

    cartStore.setTotalCart(cartStore.totalCart + 1)
    showToast('success', 'Add to Cart', 'Product has been added to cart.')
  } catch (error) {
    console.error(error)
    showToast('error', 'Add to Cart', 'Could not add product to cart.')
  } finally {
    loadingAddToCart.value = false
  }
}

watch(
  () => product.value,
  async (newVal) => {
    if (newVal.user_id) {
      // get seller data
      seller.value = await getUserById(newVal.user_id)
      carts.value = await getAllCart({
        limit: 1000,
      })
    }
  },
)
</script>

<template>
  <div class="flex gap-8 my-4">
    <div class="w-[60%] h-[50vh] sticky top-10 flex gap-4">
      <!-- Thumbnail Images (Left Side) -->
      <div :class="['flex flex-col gap-4', { 'justify-between': product?.images.length >= 5 }]">
        <div
          v-for="({ url }, index) in product?.images.slice(0, 5)"
          :key="index"
          :class="[
            'w-[150px] rounded-lg shadow-md overflow-hidden cursor-pointer bg-primary-100 flex items-center justify-center transition-transform duration-300 ease-in-out hover:scale-105',
            { 'border-2 border-primary-400': selectedImage === index },
          ]"
          @click="selectedImage = index"
        >
          <img :src="url" alt="Thumbnail" class="w-full h-full object-cover" />
        </div>
        <div
          v-if="product?.images.length >= 6"
          class="w-[150px] h-[150px] rounded-lg shadow-md overflow-hidden cursor-pointer border flex items-center justify-center"
        >
          <p class="font-medium text-xs">+{{ product?.images.length - 5 }} More</p>
        </div>
      </div>
      <!-- Main Image (Right Side) -->
      <div class="flex-1 rounded-xl shadow-xl overflow-hidden bg-primary-100 inline-block">
        <img
          :src="product?.images[selectedImage]?.url"
          alt="Main Product"
          class="w-full h-full object-contain"
        />
      </div>
    </div>
    <div class="flex-1 flex flex-col gap-4 justify-between">
      <!-- Product Info -->
      <div class="flex flex-col gap-2">
        <div class="flex flex-col gap-2">
          <div class="flex justify-between gap-4 items-center mb-2">
            <div class="flex items-center gap-2">
              <Avatar
                :image="faker.image.avatar()"
                :name="seller?.username"
                size="small"
                shape="circle"
              />
              <p>{{ seller?.username }}</p>
            </div>

            <p class="text-xs text-primary-400">
              Stock Left: <span>{{ product?.stock_quantity }}</span>
            </p>
          </div>
          <h1 class="text-2xl font-bold text-ellipsis">{{ product?.name }}</h1>
          <div class="flex items-center gap-2">
            <span class="flex gap-1">
              <i
                v-for="n in 5"
                :key="n"
                class="pi pi-star-fill text-yellow-400"
                style="font-size: 1rem"
              />
            </span>
            <p class="text-primary-400">5/5</p>
          </div>
          <div class="flex items-center gap-4 mt-4">
            <p class="font-bold text-2xl">
              {{ formatRupiah(Number(product?.price) - Number(product?.discount)) }}
            </p>
            <p class="font-medium line-through opacity-50" v-if="product?.discount">
              {{ formatRupiah(Number(product?.price)) }}
            </p>
            <Chip
              :label="`-${Math.round((Number(product?.discount) / Number(product?.price)) * 100)}%`"
              size="small"
              unstyled
              class="bg-red-100 text-red-500 px-4 py-2 rounded-full text-xs font-bold"
              v-if="product?.discount"
            />
          </div>
        </div>
        <div class="overflow-auto flex-1">
          <p class="text-sm text-primary/75 mt-4">{{ product?.description }}</p>
        </div>
      </div>

      <!-- Add to Cart -->
      <div class="flex flex-col gap-4">
        <div class="flex items-center gap-2">
          <div class="border shadow-lg ml-auto rounded-lg flex gap-4 items-center justify-between">
            <i
              class="pi pi-minus cursor-pointer px-3 py-3 text-primary/60 border-r"
              style="font-size: 0.78rem"
              @click="decrement"
            ></i>
            <span class="text-xs font-bold px-2">{{ countProduct }}</span>
            <i
              class="pi pi-plus cursor-pointer px-3 py-3 text-primary/60 border-l"
              style="font-size: 0.78rem"
              @click="increment"
            ></i>
          </div>
          <button
            class="bg-primary text-primary-contrast py-2 px-4 rounded-lg font-medium flex-1 hover:bg-primary-600 duration-200"
            @click="handleBuyNow"
            :loading="loadingSubmit"
          >
            <i class="pi pi-shopping-bag mr-2"></i>
            Buy Now
          </button>
          <Button
            icon="pi pi-shopping-cart"
            size="small"
            severity="secondary"
            @click="handleAddToCart"
            :loading="loadingAddToCart"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
img {
  mix-blend-mode: multiply;
}
</style>

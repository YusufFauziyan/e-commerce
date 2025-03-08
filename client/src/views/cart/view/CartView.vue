<script setup>
import { ref, onMounted, computed } from 'vue'
import { faker } from '@faker-js/faker'
import { handleApiError } from '@/utils/api'
import { deleteCart, getAllCart, updateCart } from '@/services/cartService'
import { getUserById } from '@/services/userService'
import { formatRupiah } from '@/utils/format-number'
import { useConfirm } from 'primevue/useconfirm'
import { useToast } from 'primevue/usetoast'
import { useCartStore } from '@/stores/cart'
import CheckoutView from '../CheckoutView.vue'

// hook
const toast = useToast()
const cartStore = useCartStore()

// ref
const carts = ref([])
const loadingCarts = ref(true)
const debounceTimeout = ref(null)
const selectedCart = ref(new Set())
const openDialogCheckout = ref(false)
const confirm = useConfirm()

const calculateTotalPrice = (finalPrice, qty) => {
  return formatRupiah(finalPrice * qty)
}

const toggleCartSelection = (cartId) => {
  if (selectedCart.value.has(cartId)) {
    selectedCart.value.delete(cartId)
  } else {
    selectedCart.value.add(cartId)
  }
}

// Menghitung total harga dari item terpilih
const subtotal = computed(() => {
  return carts.value.reduce((acc, cart) => {
    return selectedCart.value.has(cart.id) ? acc + cart.product.price * cart.quantity : acc
  }, 0)
})

// Menghitung total diskon dari item terpilih
const totalDiscount = computed(() => {
  return carts.value.reduce((acc, cart) => {
    return selectedCart.value.has(cart.id) ? acc + cart.product.discount * cart.quantity : acc
  }, 0)
})

// increment
const incrementQty = (cartId) => {
  const cart = carts.value.find((cart) => cart.id === cartId)

  if (!cart) return

  cart.quantity++

  // cancel the previous debounce
  if (debounceTimeout.value) {
    clearTimeout(debounceTimeout.value)
  }

  // set time out
  debounceTimeout.value = setTimeout(() => {
    updateCartQuantity(cartId, cart.quantity)
  }, 500)
}

// decrement
const decrementQty = (cartId) => {
  const cart = carts.value.find((cart) => cart.id === cartId)

  if (!cart || cart.quantity <= 1) return

  cart.quantity--

  // cancel the previous debounce
  if (debounceTimeout.value) {
    clearTimeout(debounceTimeout.value)
  }

  // set time out
  debounceTimeout.value = setTimeout(() => {
    updateCartQuantity(cartId, cart.quantity)
  }, 500)
}

// delete cart
const handleDeleteCart = (event, cartId) => {
  confirm.require({
    target: event.currentTarget,
    message: 'Do you want to delete this cart?',
    icon: 'pi pi-info-circle',
    rejectProps: {
      label: 'Cancel',
      severity: 'secondary',
      outlined: true,
    },
    acceptProps: {
      label: 'Delete',
      severity: 'danger',
    },
    accept: async () => {
      // Delete cart
      try {
        await deleteCart(cartId)

        // Update
        carts.value = carts.value.filter((cart) => cart.id !== cartId)
        selectedCart.value.delete(cartId)
        cartStore.setTotalCart(cartStore.totalCart--)
        toast.add({ severity: 'success', summary: 'Deleted', detail: 'Card deleted', life: 3000 })
      } catch (error) {
        toast.add({
          severity: 'error',
          summary: 'Failed',
          detail: 'Failed to delete cart',
          life: 3000,
        })
        console.error('Failed to delete cart:', error)
      }
    },
  })
}

// fetch
const updateCartQuantity = async (cartId, quantity) => {
  try {
    await updateCart(cartId, {
      quantity,
    }) // Panggil API untuk update quantity
    console.info(`Cart ${cartId} updated to quantity: ${quantity}`)
  } catch (error) {
    console.error('Failed to update cart quantity:', error)
  }
}

const fetchCarts = async () => {
  loadingCarts.value = true

  try {
    const res = await getAllCart({
      limit: 1000,
    })

    const cartValues = await Promise.all(
      res.items.map(async (item) => ({
        ...item,
        seller: await getUserById(item.product.user_id),
      })),
    )

    carts.value = cartValues
  } catch (error) {
    const { status, message } = handleApiError(error)
    console.error(`Error ${status}: ${message}`)
  } finally {
    loadingCarts.value = false
  }
}

onMounted(fetchCarts)
</script>

<template>
  <main class="my-8">
    <p class="font-bold text-lg">Your Cart</p>

    <div v-if="!loadingCarts && carts.length" class="flex items-start gap-8 mt-6">
      <div class="flex-1 flex flex-col gap-4 max-h-[75vh] overflow-y-auto">
        <div
          v-for="(cart, index) in carts"
          :key="cart.id"
          class="border p-4 rounded-xl flex flex-col gap-4"
        >
          <div class="flex items-center gap-4">
            <Checkbox
              binary
              @change="toggleCartSelection(cart.id)"
              :value="selectedCart.has(cart.id)"
            />
            <Avatar icon="pi pi-user" size="small" shape="circle" />
            <p class="font-medium capitalize">{{ cart?.seller?.username }}</p>
          </div>
          <div class="flex justify-between items-start gap-4 h-[100px]">
            <div class="flex items-start gap-4 h-full">
              <!-- <Checkbox binary /> -->
              <div class="w-4" />
              <div
                class="flex-1 rounded border overflow-hidden bg-primary-100 inline-block w-[100px] h-full"
              >
                <img
                  :src="cart?.product?.images[0]?.url"
                  alt="Main Product"
                  class="w-full h-full object-contain"
                />
              </div>
              <div class="flex flex-col h-full justify-between items-start">
                <div class="flex items-center gap-2">
                  <div
                    v-for="(category, i) in cart.product.categories"
                    :key="i"
                    class="border px-2 py-1 rounded-xl"
                  >
                    <p class="text-xs text-primary font-medium">{{ category }}</p>
                  </div>
                </div>
                <p class="font-bold line-clamp-1 ml-1">{{ cart.product.name }}</p>
                <p class="text-xs text-primary ml-1">
                  Total Price:
                  <span class="font-medium">{{
                    calculateTotalPrice(cart.product.final_price, cart.quantity)
                  }}</span>
                </p>
              </div>
            </div>

            <div class="flex flex-col gap-4 items-end">
              <p
                v-if="cart.product.discount"
                class="text-xs text-primary/75 font-medium line-through"
              >
                {{ formatRupiah(Number(cart.product.discount)) }}
              </p>
              <p class="font-bold text-xl">
                {{ formatRupiah(Number(cart.product.final_price)) }}
              </p>
              <div class="flex items-center gap-4">
                <Button
                  icon="pi pi-trash"
                  severity="danger"
                  variant="text"
                  rounded
                  aria-label="Delete Product"
                  size="small"
                  @click="(e) => handleDeleteCart(e, cart.id)"
                />
                <div class="border shadow ml-auto rounded flex gap-2 items-center justify-between">
                  <i
                    class="pi pi-minus cursor-pointer px-2 py-2 text-primary/60 border-r"
                    style="font-size: 0.5rem"
                    @click="decrementQty(cart.id)"
                  ></i>
                  <span class="text-xs font-bold px-2">{{ cart.quantity }}</span>
                  <i
                    class="pi pi-plus cursor-pointer px-2 py-2 text-primary/60 border-l"
                    style="font-size: 0.5rem"
                    @click="incrementQty(cart.id)"
                  ></i>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="border p-4 rounded-xl flex flex-col gap-4 min-w-[300px]">
        <p class="font-bold">Summary Order</p>
        <div>
          <div class="flex items-center justify-between gap-2">
            <p class="text-sm">Total Price:</p>
            <p class="text-sm">{{ formatRupiah(subtotal) }}</p>
          </div>
          <div class="flex items-center justify-between gap-2">
            <p class="text-sm">Total Discount:</p>
            <p class="text-sm line-through">{{ formatRupiah(totalDiscount) }}</p>
          </div>
          <div class="flex items-center justify-between gap-2">
            <p class="text-sm">Shipping:</p>
            <p class="text-sm">{{ formatRupiah(0) }}</p>
          </div>
          <Divider />
          <div class="flex items-center justify-between gap-2">
            <p class="text-sm">Total:</p>
            <p class="text-sm font-bold">{{ formatRupiah(subtotal - totalDiscount) }}</p>
          </div>
        </div>
        <div class="flex flex-col gap-2">
          <Button
            label="Checkout"
            icon="pi pi-shopping-cart"
            variant="primary"
            size="small"
            :disabled="selectedCart.size < 1"
            @click="openDialogCheckout = true"
          />
          <Button
            label="Add Voucher"
            icon="pi pi-ticket"
            variant="text"
            size="small"
            @click="console.info('Comming Soon')"
          />
        </div>
      </div>
    </div>

    <div
      v-else-if="!loadingCarts && !carts.length"
      class="flex flex-col gap-2 items-center justify-center place-self-center h-[75vh]"
    >
      <p class="text-primary">No items in your cart</p>
      <Button
        label="Go Shopping"
        size="small"
        as="router-link"
        severity="secondary"
        to="/shop"
        icon="pi pi-shopping-cart"
      />
    </div>
  </main>

  <Dialog
    v-model:visible="openDialogCheckout"
    :style="{
      width: '100vw',
      height: '100vh',
      top: 0,
      padding: 0,
      margin: 0,
      maxHeight: '97vh',
      borderRadius: '10px 10px 0',
    }"
    position="bottom"
    :modal="true"
    :draggable="false"
    :dismissable-mask="true"
  >
    <template #container>
      <CheckoutView :checkout="carts.filter((f) => selectedCart.has(f.id))" />
    </template>
    <!-- Tombol close -->
  </Dialog>

  <ConfirmPopup></ConfirmPopup>
</template>

<style scoped>
img {
  mix-blend-mode: multiply;
}

.p-dialog-header {
  display: none !important;
}
</style>

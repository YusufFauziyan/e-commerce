<script setup>
import { formatRupiah } from '@/utils/format-number'

defineProps({
  products: {
    type: Array,
    required: true,
  },
})
</script>

<template>
  <main class="flex-1">
    <div class="flex gap-4 justify-between w-full">
      <p class="font-bold text-lg">All Categories</p>
      <div class="flex items-center gap-2 text-xs">
        <p>Showing 1-10 of 100 Products</p>
        <p>Sort by:</p>
        <Button
          label="Most Popular"
          variant="text"
          size="small"
          icon="pi pi pi-angle-down"
          iconPos="right"
        />
      </div>
    </div>
    <div class="grid grid-cols-3 gap-4 my-8">
      <div v-for="(product, index) in products" :key="index">
        <router-link
          :to="`/shop/${product.id}`"
          class="flex flex-col items-start gap-2 cursor-pointer hover:scale-105 duration-300"
        >
          <div class="w-full bg-primary-100 rounded-2xl overflow-hidden shadow">
            <img
              :src="product.images[0].url"
              :alt="product.name"
              class="w-full object-contain h-[250px]"
              loading="lazy"
            />
          </div>
          <p class="font-bold line-clamp-1 capitalize">{{ product.name }}</p>
          <div class="flex gap-2 items-center">
            <div class="flex items-center gap-1">
              <i v-for="n in 5" :key="n" class="pi pi-star-fill h-4 text-yellow-400" />
            </div>
            <p class="text-xs font-medium">5/<span class="opacity-60">5</span></p>
          </div>
          <div class="flex items-center gap-2">
            <p class="text-xs font-bold">
              {{ formatRupiah(Number(product.price) - Number(product.discount)) }}
            </p>
            <p v-if="Number(product.discount)" class="text-xs font-bold line-through opacity-50">
              {{ formatRupiah(Number(product.price)) }}
            </p>
          </div>
        </router-link>
      </div>
    </div>

    <Divider />

    <div class="flex justify-between items-center gap-4 my-6">
      <Button label="Previous" icon="pi pi-arrow-left" size="small" variant="outlined" />

      <div id="pagination" class="flex gap-1 items-center">
        <Button label="1" size="small" disabled severity="secondary" />
      </div>

      <Button label="Next" icon="pi pi-arrow-right" size="small" variant="outlined" />
    </div>
  </main>
</template>

<style scoped>
#pagination button {
  width: 28px;
  height: 28px;
}

img {
  mix-blend-mode: multiply;
}
</style>

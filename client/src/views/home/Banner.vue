<script setup>
import { ref, watchEffect } from 'vue'

// brands 1
import nike from '@/assets/images/brands/nike.png'
import asics from '@/assets/images/brands/asics.png'
import adidas from '@/assets/images/brands/adidas.png'
import hoka from '@/assets/images/brands/hoka.png'
import newBalance from '@/assets/images/brands/new-balance.png'
import onitsukaTiger from '@/assets/images/brands/onitsuka-tiger.png'
import vans from '@/assets/images/brands/vans.png'
import OTwo from '@/assets/images/brands/o-two.png'

// brands 2
import apple from '@/assets/images/brands/apple.png'
import canon from '@/assets/images/brands/canon.png'
import fjall from '@/assets/images/brands/fjall-raven.png'
import hnm from '@/assets/images/brands/hnm.png'
import rog from '@/assets/images/brands/rog.png'
import samsung from '@/assets/images/brands/samsung.webp'
import sony from '@/assets/images/brands/sony.png'
import tnf from '@/assets/images/brands/tnf.png'

// stores
import nikeStore from '@/assets/images/store/nike-store.jpg'
import appleStore from '@/assets/images/store/apple-store.jpg'
import uniqloStore from '@/assets/images/store/uniqlo-store.webp'
import zaraStore from '@/assets/images/store/zara-store.webp'

const brands1 = [
  { name: 'Nike', src: nike },
  { name: 'Asics', src: asics },
  { name: 'Adidas', src: adidas },
  { name: 'Hoka', src: hoka },
  { name: 'New Balance', src: newBalance },
  { name: 'Onitsuka Tiger', src: onitsukaTiger },
  { name: 'Vans', src: vans },
  { name: 'o2', src: OTwo },
]

const brands2 = [
  { name: 'Apple', src: apple },
  { name: 'Canon', src: canon },
  { name: 'Fjall Raven', src: fjall },
  { name: 'H&M', src: hnm },
  { name: 'ROG', src: rog },
  { name: 'Samsung', src: samsung },
  { name: 'Sony', src: sony },
  { name: 'The North Face', src: tnf },
]

const storeImages = [
  { name: 'Nike', src: nikeStore },
  { name: 'Uniqlo', src: uniqloStore },
  { name: 'zara', src: zaraStore },
  { name: 'Apple', src: appleStore },
]

// Reactive state for image index
const currentImageIndex = ref(0)

// Function to change image every 10 seconds
watchEffect(() => {
  const interval = setInterval(() => {
    currentImageIndex.value = (currentImageIndex.value + 1) % storeImages.length
  }, 10000)

  return () => clearInterval(interval)
})
</script>

<template>
  <div class="">
    <!-- Added a single parent div -->
    <div class="min-h-[80vh] relative overflow-hidden">
      <transition name="fade" mode="out-in">
        <img
          :src="storeImages[currentImageIndex].src"
          :alt="storeImages[currentImageIndex].name"
          class="object-cover w-full h-full absolute top-0 left-0"
          :key="storeImages[currentImageIndex].name"
        />
      </transition>
      <!-- <img
        src="@/assets/images/store/nike-store.jpg"
        alt="style-product"
        class="object-cover w-full h-full absolute top-0 left-0"
      /> -->

      <div
        class="absolute flex justify-between gap-20 items-center h-full w-full z-10 hero-gradient"
      >
        <div class="container flex flex-col justify-evenly h-full">
          <div class="w-[60%] flex flex-col justify-center h-full gap-6 text-white pl-20">
            <h1 class="text-4xl font-bold text-shadow">FIND CLOTHES THAT MATCHES YOUR STYLE</h1>
            <p class="text-xs">
              Browse through our diverse range of meticulously crafted garments, designed to bring
              out your individuality and cater to your sense of style.
            </p>
            <button
              class="px-12 py-3 bg-white w-fit text-xs text-black rounded-full hover:bg-black hover:text-white duration-500 shadow-md border hover:border-white"
            >
              Shop Now
            </button>
            <div class="grid grid-cols-3 mt-4 gap-4">
              <div class="border-r-2">
                <p class="font-extrabold text-2xl">200+</p>
                <p class="text-xs opacity-60 mt-0.5">International Brands</p>
              </div>
              <div class="border-r-2">
                <p class="font-extrabold text-2xl">2,000_+</p>
                <p class="text-xs opacity-60 mt-0.5">High-Quality Products</p>
              </div>
              <div class="">
                <p class="font-extrabold text-2xl">30,000+</p>
                <p class="text-xs opacity-60 mt-0.5">Happy Customers</p>
              </div>
            </div>
          </div>

          <div class="w-full flex flex-nowrap gap-6 overflow-hidden mt-auto brands-scroll mb-12">
            <div
              class="flex flex-nowrap items-center justify-center md:justify-start animate-infinite-scroll"
            >
              <div
                v-for="brand in brands1"
                :key="brand.name"
                class="w-44 flex items-center flex-nowrap justify-center h-auto gap-4"
              >
                <img :src="brand.src" :alt="brand.name" class="w-16 h-16 object-contain" />
                <!-- <span class="font-semibold text-white/56 text-lg">{{ brand.name }}</span> -->
              </div>
            </div>
            <div
              class="flex flex-nowrap items-center justify-center md:justify-start animate-infinite-scroll"
            >
              <div
                v-for="brand in brands2"
                :key="brand.name"
                class="w-44 flex items-center flex-nowrap justify-center h-auto gap-4"
              >
                <img :src="brand.src" :alt="brand.name" class="w-16 h-16 object-contain" />
                <!-- <span class="font-semibold text-white/56 text-lg">{{ brand.name }}</span> -->
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!-- Closing the single parent div -->
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease-in-out;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}

.hero-gradient {
  background: linear-gradient(
    180deg,
    rgba(18, 18, 18, 1) 0%,
    rgba(18, 18, 18, 0.5) 50%,
    rgba(18, 18, 18, 1) 100%
  );
}

.brands-scroll {
  mask-image: linear-gradient(
    90deg,
    transparent 0,
    #fff 128px,
    #fff calc(100% - 128px),
    transparent
  );
}

.animate-infinite-scroll {
  animation: infinite-scroll 40s linear infinite;
}

@keyframes infinite-scroll {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(-100%);
  }
}
</style>

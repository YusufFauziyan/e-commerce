<script setup>
import { faker } from '@faker-js/faker'
</script>

<template>
  <div class="container my-20">
    <span class="text-xl font-semibold text-surface-950 dark:text-surface-0">Testimonial</span>
    <h1
      class="mt-2 text-3xl lg:text-6xl font-semibold text-surface-950 dark:text-surface-0 max-w-2xl leading-tight"
    >
      Real Stories Real Results Our Customers
    </h1>

    <div class="relative flex flex-col items-center justify-center mt-16">
      <div
        class="flex items-start gap-6 [mask-image:_linear-gradient(to_top,transparent_5%,white_40%)]"
      >
        <div class="w-[25%] flex-col gap-6 lg:flex hidden">
          <div
            v-for="(_, index) in Array(3)"
            :key="index"
            class="p-6 border border-surface-200 dark:border-surface-700 rounded-3xl"
          >
            <p class="text-surface-500 line-clamp-4">
              {{ faker.lorem.paragraph() }}
            </p>
            <div class="my-3 flex gap-0.5">
              <i
                v-for="n in 5"
                :key="n"
                class="pi pi-star-fill text-yellow-400"
                style="font-size: 0.7rem"
              />
            </div>
            <div class="flex items-center gap-4">
              <div
                class="rounded-full w-8 h-8 border border-surface-200 dark:border-surface-700 overflow-hidden"
              >
                <img :src="faker.image.avatar()" class="object-cover" />
              </div>
              <div class="flex flex-col gap-1 flex-1">
                <span class="text-lg font-semibold text-surface-950 dark:text-surface-0">{{
                  faker.person.firstName()
                }}</span
                ><span class="text-surface-500 dark:text-white/64">{{
                  faker.person.jobTitle()
                }}</span>
              </div>
            </div>
          </div>
        </div>
        <div class="w-full lg:w-[50%] flex flex-col gap-6">
          <div class="p-6 border border-surface-200 dark:border-surface-700 rounded-3xl">
            <p class="text-surface-500 line-clamp-4">
              {{ faker.lorem.paragraph() }}
            </p>
            <div class="my-3 flex gap-0.5">
              <i
                v-for="n in 5"
                :key="n"
                class="pi pi-star-fill text-yellow-400"
                style="font-size: 0.7rem"
              />
            </div>
            <div class="flex items-center gap-4">
              <div
                class="rounded-full w-8 h-8 border border-surface-200 dark:border-surface-700 overflow-hidden"
              >
                <img :src="faker.image.avatar()" class="object-cover" />
              </div>
              <div class="flex flex-col gap-1 flex-1">
                <span class="text-lg font-semibold text-surface-950 dark:text-surface-0">{{
                  faker.person.firstName()
                }}</span
                ><span class="text-surface-500 dark:text-white/64">{{
                  faker.person.jobTitle()
                }}</span>
              </div>
            </div>
          </div>
          <div class="flex items-start gap-6" v-for="(_, index) in Array(2)" :key="index">
            <div class="w-full md:w-1/2 flex flex-col gap-6">
              <div class="p-6 border border-surface-200 dark:border-surface-700 rounded-3xl">
                <p class="text-surface-500 line-clamp-4">
                  {{ faker.lorem.paragraph() }}
                </p>
                <div class="my-3 flex gap-0.5">
                  <i
                    v-for="n in 5"
                    :key="n"
                    class="pi pi-star-fill text-yellow-400"
                    style="font-size: 0.7rem"
                  />
                </div>
                <div class="flex items-center gap-4">
                  <div
                    class="rounded-full w-8 h-8 border border-surface-200 dark:border-surface-700 overflow-hidden"
                  >
                    <img :src="faker.image.avatar()" class="object-cover" />
                  </div>
                  <div class="flex flex-col gap-1 flex-1">
                    <span class="text-lg font-semibold text-surface-950 dark:text-surface-0">{{
                      faker.person.firstName()
                    }}</span
                    ><span class="text-surface-500 dark:text-white/64">{{
                      faker.person.jobTitle()
                    }}</span>
                  </div>
                </div>
              </div>
            </div>
            <div class="w-full md:w-1/2 flex flex-col gap-6">
              <div class="p-6 border border-surface-200 dark:border-surface-700 rounded-3xl">
                <p class="text-surface-500 line-clamp-4">
                  {{ faker.lorem.paragraph() }}
                </p>
                <div class="my-3 flex gap-0.5">
                  <i
                    v-for="n in 5"
                    :key="n"
                    class="pi pi-star-fill text-yellow-400"
                    style="font-size: 0.7rem"
                  />
                </div>
                <div class="flex items-center gap-4">
                  <div
                    class="rounded-full w-8 h-8 border border-surface-200 dark:border-surface-700 overflow-hidden"
                  >
                    <img :src="faker.image.avatar()" class="object-cover" />
                  </div>
                  <div class="flex flex-col gap-1 flex-1">
                    <span class="text-lg font-semibold text-surface-950 dark:text-surface-0">{{
                      faker.person.firstName()
                    }}</span
                    ><span class="text-surface-500 dark:text-white/64">{{
                      faker.person.jobTitle()
                    }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="w-[25%] hidden lg:flex flex-col gap-6">
          <div
            v-for="(_, index) in Array(3)"
            :key="index"
            class="p-6 border border-surface-200 dark:border-surface-700 rounded-3xl"
          >
            <p class="text-surface-500 line-clamp-4">
              {{ faker.lorem.paragraph() }}
            </p>
            <div class="my-3 flex gap-0.5">
              <i
                v-for="n in 5"
                :key="n"
                class="pi pi-star-fill text-yellow-400"
                style="font-size: 0.7rem"
              />
            </div>
            <div class="flex items-center gap-4">
              <div
                class="rounded-full w-8 h-8 border border-surface-200 dark:border-surface-700 overflow-hidden"
              >
                <img :src="faker.image.avatar()" class="object-cover" />
              </div>
              <div class="flex flex-col gap-1 flex-1">
                <span class="text-lg font-semibold text-surface-950 dark:text-surface-0">{{
                  faker.person.firstName()
                }}</span
                ><span class="text-surface-500 dark:text-white/64"
                  >{{ faker.person.jobTitle() }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.p-avatar img {
  width: 100%;
  height: 100%;
}
</style>

<script setup>
import { ref, toRefs, onMounted } from 'vue'
import NoReview from '@/components/NoReview.vue'

defineProps({
  product: {
    type: Object,
    required: true,
  },
})
</script>

<template>
  <div class="min-h-[20vh]">
    <div class="flex justify-between gap-4 items-center">
      <p class="">All Reviews <span class="text-primary-400 text-sm ml-1">(0)</span></p>

      <div class="flex items-center gap-2">
        <Button icon="pi pi-sliders-v" size="small" rounded />
      </div>
    </div>

    <NoReview />
  </div>
</template>

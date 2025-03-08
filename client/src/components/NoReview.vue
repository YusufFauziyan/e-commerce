<script setup>
import { ref } from 'vue'
import { useToast } from 'primevue/usetoast'

const toast = useToast()

const handleWriteReview = () => {
  toast.add({ severity: 'info', summary: 'Review', detail: 'Write your review here!', life: 3000 })
}
</script>

<template>
  <div
    class="no-reviews bg-gradient-to-r from-primary-200 to-primary-contrast text-primary-contrast"
  >
    <div
      class="w-12 h-12 p-4 rounded-full bg-primary-contrast flex justify-center items-center bg-gradient-to-tr from-primary-300 to-primary-contrast"
    >
      <i class="pi pi-comments text-4xl text-primary"></i>
    </div>
    <p class="text-lg font-semibold text-gray-700">No reviews yet</p>
    <p class="text-sm text-primary/60 mb-4">Be the first to share your thoughts!</p>
    <Button
      label="Write a Review"
      icon="pi pi-pencil"
      class="p-button-rounded p-button-outlined"
      @click="handleWriteReview"
    />
    <Toast />
  </div>
</template>

<style scoped>
.no-reviews {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 30px;
  border-radius: 12px;

  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  margin: 2rem 0;
}
</style>

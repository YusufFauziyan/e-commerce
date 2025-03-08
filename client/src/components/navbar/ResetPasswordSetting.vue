<script setup>
import { ref } from 'vue'

// form
import { useForm, useField } from 'vee-validate'
import * as yup from 'yup'

// validation
const schema = yup.object({
  password: yup
    .string()
    .min(6, 'Password must be at least 6 characters')
    .required('Password is required'),
  confirmPassword: yup.string().oneOf([yup.ref('password'), null], 'Passwords must match'),
})

// form
const { handleSubmit, resetForm } = useForm({
  validationSchema: schema,
  initialValues: {
    password: '',
    confirmPassword: '',
  },
})

// define form
const { value: password, errorMessage: passwordError } = useField('password')
const { value: confirmPassword, errorMessage: confirmPasswordError } = useField('confirmPassword')

// onsubmit
const onSubmit = handleSubmit(async (values) => {
  console.log(values)
})
</script>

<template>
  <form @submit.prevent="onSubmit" class="h-full">
    <main class="py-4 px-6 flex flex-col gap-4 h-full">
      <p class="text-xl font-bold">Create New Password</p>

      <div class="flex items-center justify-center h-full">
        <p class="font-bold text-xl">Comming Soon!</p>
      </div>

      <!-- <div class="flex items-center h-full justify-center flex-col">
        <div class="w-[400px]">
          <div>
            <label for="password1" class="block text-surface-900 dark:text-surface-0 font-bold mb-1"
              >New Password</label
            >
            <Password
              v-model="password"
              id="password1"
              placeholder="New Password"
              :toggleMask="true"
              fluid
              :feedback="false"
              :invalid="!!passwordError"
              class="w-full"
            ></Password>
            <Message v-if="passwordError" severity="error" variant="simple" size="small">{{
              passwordError
            }}</Message>
          </div>

          <div class="mt-2">
            <label
              for="confirmPassword1"
              class="block text-surface-900 dark:text-surface-0 font-bold mb-1"
              >Confirm Password</label
            >
            <Password
              v-model="confirmPassword"
              id="confirmPassword1"
              placeholder="Confirm Password"
              :toggleMask="true"
              fluid
              :feedback="false"
              :invalid="!!confirmPasswordError"
            ></Password>
            <Message v-if="confirmPasswordError" severity="error" variant="simple" size="small">{{
              confirmPasswordError
            }}</Message>
          </div>

          <div class="mt-6">
            <Button type="submit" label="Reset Password" class="w-full" />
          </div>
        </div>
      </div> -->
    </main>
  </form>
</template>

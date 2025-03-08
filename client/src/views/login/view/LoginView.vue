<script setup>
import { watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { useForm, useField } from 'vee-validate'
import * as yup from 'yup'
import { login, loginWithGoogle } from '@/services/authService'
import { CallbackTypes } from 'vue3-google-login'
import { useRouter } from 'vue-router'

// store
import { useAuthStore } from '@/stores/auth'

// validation schema
const schema = yup.object({
  email: yup.string().email('Email must be valid').required('Email is required'),
  password: yup
    .string()
    .min(6, 'Password must be at least 6 characters')
    .required('Password is required'),
})

// store
const authStore = useAuthStore()

// router
const router = useRouter()
const route = useRoute()

const { handleSubmit } = useForm({
  validationSchema: schema,
})

// Definisi field
const { value: email, errorMessage: emailError } = useField('email')
const { value: password, errorMessage: passwordError } = useField('password')

// Submit handler
const onSubmit = handleSubmit(async (values) => {
  console.log('Form Submitted:', values)
  try {
    const res = await login(values.email, values.password)

    authStore.setUser(res)

    const returnTo = route.query.returnTo || '/'
    router.push(returnTo)
  } catch (error) {
    console.error('Login failed:', error)
  }
})

// login google
const callbackGoogle = async (response) => {
  const { credential } = response

  try {
    const res = await loginWithGoogle(credential)

    authStore.setUser(res)

    const returnTo = route.query.returnTo || '/'
    router.push(returnTo)
  } catch (error) {
    console.error('Login with Google failed:', error)
  }
}

watch(
  () => authStore.user,
  (user) => {
    if (user) {
      const returnTo = route.query.returnTo || '/'
      router.push(returnTo)
    }
  },
  { immediate: true },
)
</script>

<template>
  <main class="grid grid-cols-2 h-[100vh] overflow-hidden">
    <div class="p-12">
      <nav class="h-full">
        <RouterLink class="text-xl font-bold" to="/">LOGO</RouterLink>

        <div class="flex justify-center flex-col h-full px-[15%]">
          <h4 class="text-4xl font-bold">Sign In</h4>
          <p class="text-sm mt-1 text-gray-500/75">Fill the fields below to continue.</p>

          <form @submit.prevent="onSubmit">
            <div class="mt-6 flex flex-col gap-4">
              <div>
                <label
                  for="email1"
                  class="block text-surface-900 dark:text-surface-0 font-bold mb-1"
                  >Email</label
                >
                <InputText
                  v-model="email"
                  id="email1"
                  type="text"
                  placeholder="Email address"
                  class="w-full bg-red-300"
                  :invalid="!!emailError"
                />
                <Message v-if="emailError" severity="error" variant="simple" size="small">{{
                  emailError
                }}</Message>
              </div>

              <div>
                <label
                  for="password1"
                  class="block text-surface-900 dark:text-surface-0 font-bold mb-1"
                  >Password</label
                >
                <Password
                  v-model="password"
                  id="password1"
                  placeholder="Password"
                  :toggleMask="true"
                  fluid
                  :feedback="false"
                  :invalid="!!passwordError"
                ></Password>
                <Message v-if="passwordError" severity="error" variant="simple" size="small">{{
                  passwordError
                }}</Message>
              </div>

              <button
                type="submit"
                class="bg-black text-white font-bold py-2 rounded-lg mt-4 focus:outline-none hover:bg-white hover:text-black duration-200 border dark:bg-white dark:text-black dark:border-white dark:hover:bg-black dark:hover:text-white"
              >
                Sign In
              </button>
            </div>
          </form>

          <div class="my-8 flex items-center justify-center gap-2">
            <hr class="w-full border-t border-gray-300" />
            <p class="text-sm text-gray-500">Or</p>
            <hr class="w-full border-t border-gray-300" />
          </div>

          <GoogleLogin :callback="callbackGoogle" />
        </div>
      </nav>
    </div>
    <div class="p-20 relative bg-primary-100">
      <p class="text-xl font-bold opacity-50 capitalize">
        "The advance of technology is based on making it fit in so that you don't really even notice
        it, so it's part of everyday life."
      </p>
      <p class="mt-12 font-bold opacity-80">Bill Gates</p>
      <p class="opacity-50 text-xs font-medium">Co-founder of Microsoft.</p>
      <div class="absolute top-1/3 w-full rounded-xl overflow-hidden shadow-md">
        <img
          src="@/assets/images/login-hero-light.png"
          alt="login-hero"
          class="w-full h-full object-cover"
        />
      </div>
    </div>
  </main>
</template>

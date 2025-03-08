<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter } from 'vue-router'

// store pinia
import { useThemeStore } from '@/stores/theme'
import { useAuthStore } from '@/stores/auth'
import { useCartStore } from '@/stores/cart'

// components
import ProfileSetting from '@/components/navbar/ProfileSetting.vue'
import AddressSetting from '@/components/navbar/AddressSetting.vue'
import ResetPasswordSetting from '@/components/navbar/ResetPasswordSetting.vue'

//hook
const { darkTheme, setToogleDarkTheme } = useThemeStore()
const { clearUser, ...auth } = useAuthStore()
const cartCount = useCartStore()
const router = useRouter()

// ref
const isDarkTheme = ref(darkTheme)
const openInfoBanner = ref(JSON.parse(localStorage.getItem('openInfoBanner') || 'true'))
const menu = ref()
const openDialogSetting = ref(false)
const currentSetting = ref(0)

const user = ref(null)

watch(
  () => auth.user,
  (newUser) => {
    user.value = newUser
  },
  { immediate: true },
)

const toggleMenu = (event) => {
  menu.value.toggle(event)
}

const toggleDarkMode = () => {
  if (!document.startViewTransition) {
    executeDarkModeToggle()

    return
  }

  document.startViewTransition(() => executeDarkModeToggle())
}

const executeDarkModeToggle = () => {
  document.documentElement.classList.toggle('app-dark')
  isDarkTheme.value = !isDarkTheme.value
  setToogleDarkTheme()
}

const handleRemoveUser = () => {
  clearUser()
  user.value = null
}

const handleCloseInfoBanner = () => {
  localStorage.setItem('openInfoBanner', JSON.stringify(false))
  openInfoBanner.value = false
}

const toogleAvatar = ref([
  {
    label: 'Payment',
    items: [
      {
        label: 'Transaction',
        icon: 'pi pi-money-bill',
        command: () => {
          router.push('/transaction')
        },
      },
    ],
  },
  {
    label: 'Profile',
    items: [
      {
        label: 'Settings',
        icon: 'pi pi-cog',
        command: () => {
          openDialogSetting.value = true
        },
      },
      {
        label: 'Logout',
        icon: 'pi pi-sign-out',
        command: handleRemoveUser,
      },
    ],
  },
])

const LIST_SETTING = ref([
  {
    label: 'Profile',
    icon: 'pi pi-user-edit',
  },
  {
    label: 'Address',
    icon: 'pi pi-map-marker',
  },
  {
    label: 'Reset Password',
    icon: 'pi pi-key',
  },
])

onMounted(() => {
  if (darkTheme) {
    document.documentElement.classList.add('app-dark')
  }
})
</script>

<template>
  <div>
    <div class="bg-primary py-2" v-if="openInfoBanner">
      <div class="flex justify-between container items-center">
        <div />
        <div class="flex items-center gap-2">
          <p class="text-xs text-primary-contrast">Sign up and get 20% off to your first order.</p>
          <a href="#" class="underline text-xs text-primary-contrast">Sign Up Now</a>
        </div>
        <div class="cursor-pointer hover:opacity-50 duration-150" @click="handleCloseInfoBanner">
          <i class="pi pi-times text-primary-contrast" style="font-size: 0.7rem"></i>
        </div>
      </div>
    </div>

    <div class="py-[1.5rem] flex items-center container">
      <div class="w-[150px]">
        <p class="font-bold">LOGO</p>
      </div>
      <div class="flex items-center justify-between gap-12 w-full">
        <div class="flex flex-nowrap items-center gap-6 font-light">
          <router-link to="/shop" class="text-xs whitespace-nowrap link">Shop</router-link>
          <router-link to="#" class="text-xs whitespace-nowrap link">On Sale</router-link>
          <router-link to="#" class="text-xs whitespace-nowrap link">New Arrivals</router-link>
          <router-link to="#" class="text-xs whitespace-nowrap link">Brands</router-link>
        </div>
        <div class="w-full rounded-full flex items-center py-2 px-4 shadow border gap-2">
          <i class="pi pi-search font-bold" style="font-size: 0.75rem"></i>

          <input
            type="text"
            class="bg-transparent text-xs w-full focus:outline-none"
            placeholder="Search for products..."
          />
        </div>

        <Button type="button" variant="text" rounded size="small" @click="toggleDarkMode">
          <i :class="['pi', { 'pi-moon': !isDarkTheme, 'pi-sun': isDarkTheme }]"></i>
        </Button>
        <div v-if="!user">
          <Button
            label="Login"
            size="small"
            raised
            rounded
            style="padding-left: 1.5rem; padding-right: 1.5rem"
            as="router-link"
            to="/login"
          />
        </div>
        <div v-if="user" class="flex items-end gap-6">
          <router-link to="/cart">
            <OverlayBadge
              :value="cartCount.totalCart"
              severity="danger"
              size="small"
              class="cursor-pointer hover:opacity-80 duration-150"
            >
              <i class="pi pi-shopping-cart" style="font-size: 1rem"></i>
            </OverlayBadge>
          </router-link>

          <Avatar
            :image="user?.avatar?.url"
            class="bg-primary-contrast text-primary cursor-pointer hover:opacity-80 duration-150 shadow"
            shape="circle"
            @click="toggleMenu"
            aria-haspopup="true"
            aria-controls="overlay_menu"
          />

          <Menu ref="menu" id="overlay_menu" :model="toogleAvatar" :popup="true">
            <!-- <template #submenulabel="{ item }">
              <span class="text-primary font-bold">{{ item.label }}</span>
            </template> -->
          </Menu>
        </div>
      </div>
    </div>
  </div>

  <Dialog
    v-model:visible="openDialogSetting"
    modal
    header="Header"
    :style="{ width: '60vw' }"
    :breakpoints="{ '1199px': '75vw', '575px': '90vw' }"
  >
    <template #container>
      <div class="flex">
        <div class="border-r-2 w-[170px]">
          <div class="p-4 border-b-2 h-[65px] flex items-center">
            <p class="font-bold text-xl">Settings</p>
          </div>
          <div class="my-4 flex flex-col">
            <div
              v-for="(item, index) in LIST_SETTING"
              :key="index"
              :class="[
                'px-4 py-2 flex gap-2 cursor-pointer items-center duration-150 relative',
                currentSetting === index
                  ? 'bg-primary-100 dark:text-primary-contrast '
                  : 'hover:bg-primary-100 dark:hover:text-primary-contrast',
              ]"
              @click="currentSetting = index"
            >
              <div
                v-if="currentSetting === index"
                class="h-full bg-primary dark:bg-primary-contrast absolute right-0 w-0.5"
              />
              <i :class="[item.icon, 'opacity-60']" style="font-size: 0.9rem"></i>
              <p class="font-semibold">{{ item.label }}</p>
            </div>
          </div>
        </div>
        <div class="flex-1">
          <div class="p-4 border-b-2 h-[65px] flex items-center justify-end flex-1">
            <Button
              icon="pi pi-times"
              size="small"
              variant="text"
              rounded
              @click="openDialogSetting = false"
            />
          </div>

          <div class="overflow-auto h-[55vh]" v-if="currentSetting === 0">
            <ProfileSetting :user="user" />
          </div>
          <div class="overflow-auto h-[55vh]" v-if="currentSetting === 1">
            <AddressSetting :user="user" />
          </div>
          <div class="overflow-auto h-[55vh]" v-if="currentSetting === 2">
            <ResetPasswordSetting />
          </div>
        </div>
      </div>
    </template>
  </Dialog>
</template>

<style scoped>
.link {
  position: relative;
  text-decoration: none; /* Menghilangkan underline default */
  color: inherit; /* Menggunakan warna teks default */
}

.link::after {
  content: '';
  position: absolute;
  left: 0;
  bottom: -2px; /* Posisi underline */
  width: 0; /* Mulai dengan lebar 0 */
  height: 2px; /* Ketebalan underline */
  background-color: currentColor; /* Warna underline sama dengan teks */
  transition: width 0.3s ease; /* Animasi lebar underline */
}

.link:hover::after {
  width: 70%; /* Lebar underline menjadi 100% saat hover */
}

.dialog-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.dialog-body {
  flex: 1;
  overflow-y: auto;
}
</style>

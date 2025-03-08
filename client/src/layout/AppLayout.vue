<script setup>
import { computed, ref, watch } from 'vue'
import AppFooter from './AppFooter.vue'
import AppNavbar from './AppNavbar.vue'
</script>

<template>
  <div class="layout-wrapper">
    <app-navbar></app-navbar>
    <!-- <app-sidebar></app-sidebar> -->
    <div class="layout-main-container">
      <div class="layout-main">
        <router-view></router-view>
      </div>
      <app-footer></app-footer>
    </div>
    <div class="layout-mask animate-fadein"></div>
  </div>
  <Toast />
</template>

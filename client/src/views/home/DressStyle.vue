<script setup></script>

<template>
  <div class="bg-primary-100 px-12 py-20 rounded-lg container">
    <h1 class="mt-2 text-3xl lg:text-4xl font-semibold text-surface-950 leading-tight text-center">
      BROWSE BY DRESS STYLE
    </h1>

    <div class="grid grid-cols-3 mt-12 gap-4">
      <div class="bg-white rounded-xl relative flex h-[290px] overflow-hidden shadow-md">
        <p class="p-4 font-bold text-2xl text-black">Casual</p>
        <img src="@/assets/images/casual.png" alt="casual" class="w-full h-full object-cover" />
      </div>
      <div class="bg-white rounded-xl relative flex h-[290px] overflow-hidden shadow-md col-span-2">
        <p class="p-4 font-bold text-2xl text-black">Formal</p>
        <img src="@/assets/images/formal.png" alt="formal" class="w-full h-full object-cover" />
      </div>
      <div class="bg-white rounded-xl relative flex h-[290px] overflow-hidden shadow-md col-span-2">
        <p class="p-4 font-bold text-2xl text-black">Party</p>
        <img src="@/assets/images/party.png" alt="party" class="w-full h-full object-cover" />
      </div>
      <div class="bg-white rounded-xl relative flex h-[290px] overflow-hidden shadow-md">
        <p class="p-4 font-bold text-2xl text-black">Gym</p>
        <img src="@/assets/images/gym.png" alt="gym" class="w-full h-full object-cover" />
      </div>
    </div>
  </div>
</template>

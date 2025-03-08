<script setup>
import { ref, onMounted } from 'vue'
import { CustomerService } from '../CustomerService'
import { getAllOrder } from '@/services/orderService'
import { fDateTime } from '@/utils/format-time'
import { formatRupiah } from '@/utils/format-number'
import { FilterMatchMode } from '@primevue/core'

const transactions = ref([])
const loading = ref(true)

const filters = ref({
  global: { value: null, matchMode: FilterMatchMode.CONTAINS },
})

const getSeverity = (status) => {
  switch (status) {
    case 'cancelled':
      return 'danger'
    case 'paid':
    case 'settlement':
      return 'success'
    case 'shipped':
      return 'info'
    case 'pending':
      return 'warn'
    case 'delivered':
      return 'primary'
  }
}

const fetchTransactions = async () => {
  loading.value = true
  try {
    const res = await getAllOrder({
      limit: 500,
    })

    transactions.value = res.items.map((item) => {
      const totalAmount = item.orders.reduce(
        (acc, order) => acc + order.product.final_price * order.quantity,
        0,
      )

      return {
        id: item.id,
        products: item.orders.map((order) => ({
          id: order.product.id,
          quantity: order.quantity,
          name: order.product.name,
          price: order.product.final_price,
          formattedPrice: formatRupiah(Number(order.product.final_price)),
        })),
        amount: totalAmount,
        formattedAmount: formatRupiah(totalAmount),
        date: new Date(item.order_date),
        formattedDate: fDateTime(item.order_date),
        status: item?.payment?.transaction_status ?? 'Pending',
        addressTitle: item.address.title_address,
        address: `${item.address.street_address}, ${item.address.city}, ${item.postal_code}`,
      }
    })
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

fetchTransactions()
</script>

<template>
  <main class="my-8">
    <div class="flex flex-col gap-2">
      <p class="font-bold text-lg">Your Transactions</p>
      <p class="text-sm text-gray-500">List of all your transactions</p>
    </div>

    <div class="card my-12">
      <DataTable
        :value="transactions"
        paginator
        showGridlines
        :rows="10"
        dataKey="id"
        filterDisplay="menu"
        :loading="loading"
        :filters="filters"
        :globalFilterFields="['address', 'status', 'formattedAmount']"
      >
        <template #header>
          <div class="flex justify-end">
            <IconField>
              <InputIcon>
                <i class="pi pi-search" />
              </InputIcon>
              <InputText v-model="filters.global.value" placeholder="Keyword Search" />
            </IconField>
          </div>
        </template>
        <template #empty> No transactions found. </template>
        <template #loading> Loading transactions data. Please wait. </template>

        <!-- Filter by Products -->
        <Column field="products" header="Products" style="min-width: 18rem">
          <template #body="{ data }">
            <div
              class="flex flex-col gap-2 mt-2"
              v-for="(product, index) in data.products"
              :key="index"
            >
              <p class="font-bold text-sm">
                {{ product.name }}
              </p>
              <div class="flex justify-between">
                <p class="text-xs text-gray-500">{{ product.quantity }} items</p>
                <p class="text-xs font-medium">{{ product.formattedPrice }} / item</p>
              </div>
            </div>
          </template>
        </Column>

        <!-- Filter by Amount -->
        <Column header="Amount" field="formattedAmount" filterField="amount" dataType="numeric">
          <template #body="{ data }">
            {{ data.formattedAmount }}
          </template>
        </Column>

        <!-- Filter by Date -->
        <Column
          header="Date"
          field="formattedDate"
          filterField="date"
          dataType="date"
          style="min-width: 12rem"
        >
          <template #body="{ data }">
            {{ data.formattedDate }}
          </template>
        </Column>

        <!-- Filter by Status -->
        <Column header="Status" field="status" :filterMenuStyle="{ width: '14rem' }">
          <template #body="{ data }">
            <Tag
              icon="pi pi-circle-fill mr-1 text-xs"
              :value="data.status"
              :severity="getSeverity(data.status)"
              rounded
              class="capitalize"
            />
          </template>
        </Column>

        <!-- Filter by Address -->
        <Column
          header="Delivery Address"
          field="address"
          filterField="address"
          style="min-width: 20rem"
        >
          <template #body="{ data }">
            <div class="flex flex-col gap-1">
              <p class="font-bold">{{ data.addressTitle }}</p>
              <p class="text-sm text-gray-500">{{ data.address }}</p>
            </div>
          </template>
        </Column>

        <!-- Detail Button -->
        <Column header="" style="min-width: 8rem">
          <template #body="{ data }">
            <div class="flex items-center gap-2">
              <Button variant="text" size="small" iconPos="right" asChild v-slot="slotProps">
                <RouterLink :to="`/transaction/${data.id}`" :class="slotProps.class"
                  >Detail <i class="pi pi-angle-right"
                /></RouterLink>
              </Button>
            </div>
          </template>
        </Column>
      </DataTable>
    </div>
  </main>
</template>

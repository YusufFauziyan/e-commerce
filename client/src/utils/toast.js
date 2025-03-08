import { useToast } from 'primevue'

const ShowToast = (severity, summary, detail) => {
  const toast = useToast()

  toast.add({ severity, summary, detail, life: 3000 })
}

export default ShowToast

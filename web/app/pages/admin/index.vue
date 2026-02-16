<template>
  <v-app>
    <v-app-bar color="primary" density="compact">
      <v-app-bar-title class="font-weight-bold">Painel Admin</v-app-bar-title>
      <template #append>
        <span class="text-body-2 mr-4 text-medium-emphasis">{{ user?.email }}</span>
        <v-btn variant="outlined" size="small" @click="logout" prepend-icon="mdi-logout">
          Sair
        </v-btn>
      </template>
    </v-app-bar>

    <v-main class="bg-grey-lighten-5">
      <v-container class="py-8">
        <div class="d-flex align-center justify-space-between mb-6">
          <div>
            <h1 class="text-h4 font-weight-bold mb-1">Gerenciar Vagas</h1>
            <p class="text-body-1 text-medium-emphasis">
              Crie, edite e remova as oportunidades da plataforma.
            </p>
          </div>
        </div>

        <!-- Tabela de Vagas -->
        <JobsTable
          :items="jobs"
          :totalItems="totalItems"
          v-model:page="page"
          v-model:itemsPerPage="itemsPerPage"
          v-model:search="search"
          :loading="loading"
          @update:options="handleTableOptions"
          @create="openCreateDialog"
          @edit="openEditDialog"
          @delete="openDeleteDialog"
        />

        <!-- Modal de Formulário (Criar/Editar) -->
        <JobFormDialog
          v-model="showFormDialog"
          :job="selectedJob"
          :loading="saving"
          @save="handleSave"
        />

        <!-- Modal de Confirmação (Excluir) -->
        <ConfirmDialog
          v-model="showConfirmDialog"
          title="Excluir Vaga"
          :message="`Tem certeza que deseja excluir a vaga '${jobToDelete?.title}'? Esta ação não pode ser desfeita.`"
          :loading="deleting"
          @confirm="handleDelete"
        />

        <!-- Feedback Snackbar -->
        <v-snackbar
          v-model="snackbar.show"
          :color="snackbar.color"
          location="top right"
          variant="tonal"
        >
          {{ snackbar.message }}
        </v-snackbar>
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
const { user, logout, fetchUser, apiFetch } = useAuth()

// State
const jobs = ref<any[]>([])
const loading = ref(false)
const saving = ref(false)
const deleting = ref(false)

// Pagination State
const page = ref(1)
const itemsPerPage = ref(10)
const totalItems = ref(0)
const search = ref('')

// Dialogs State
const showFormDialog = ref(false)
const showConfirmDialog = ref(false)
const selectedJob = ref<any>(null)
const jobToDelete = ref<any>(null)

// Snackbar State
const snackbar = reactive({
  show: false,
  message: '',
  color: 'success',
})

const showFeedback = (message: string, color = 'success') => {
  snackbar.message = message
  snackbar.color = color
  snackbar.show = true
}

// Fetch Data
const loadJobs = async () => {
  loading.value = true
  try {
    const params: any = {
      page: page.value,
      per_page: itemsPerPage.value,
    }
    
    if (search.value) {
      params.q = search.value
    }

    const response = await apiFetch<any>('/jobs', { params })
    
    // Handle paginated response
    if (response && response.data) {
      jobs.value = response.data
      totalItems.value = response.meta?.count || 0
    } else {
      // Fallback for non-paginated or empty
      jobs.value = Array.isArray(response) ? response : []
      totalItems.value = jobs.value.length
    }
  } catch (e) {
    console.error('Erro ao carregar vagas:', e)
    showFeedback('Erro ao carregar vagas.', 'error')
    jobs.value = []
    totalItems.value = 0
  } finally {
    loading.value = false
  }
}

// Watchers for server-side search/pagination
watch([page, itemsPerPage], () => {
  loadJobs()
})

// Debounced search watcher
let debounceTimer: any = null
watch(search, () => {
  if (debounceTimer) clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    page.value = 1 // Reset to first page on search
    loadJobs()
  }, 500)
})

const handleTableOptions = ({ page: p, itemsPerPage: ipp }: any) => {
  page.value = p
  itemsPerPage.value = ipp
}

// Actions
const openCreateDialog = () => {
  selectedJob.value = null
  showFormDialog.value = true
}

const openEditDialog = (job: any) => {
  selectedJob.value = { ...job } // Clone to avoid mutation
  showFormDialog.value = true
}

const openDeleteDialog = (job: any) => {
  jobToDelete.value = job
  showConfirmDialog.value = true
}

const handleSave = async (jobData: any) => {
  saving.value = true
  try {
    if (selectedJob.value?.id) {
      // Update
      await apiFetch(`/jobs/${selectedJob.value.id}`, {
        method: 'PUT',
        body: jobData,
      })
      showFeedback('Vaga atualizada com sucesso!')
    } else {
      // Create
      await apiFetch('/jobs', {
        method: 'POST',
        body: jobData,
      })
      showFeedback('Vaga criada com sucesso!')
    }
    showFormDialog.value = false
    await loadJobs() // Refresh list
  } catch (e: any) {
    console.error('Erro ao salvar:', e)
    showFeedback(e?.data?.error || 'Erro ao salvar vaga.', 'error')
  } finally {
    saving.value = false
  }
}

const handleDelete = async () => {
  if (!jobToDelete.value) return

  deleting.value = true
  try {
    await apiFetch(`/jobs/${jobToDelete.value.id}`, {
      method: 'DELETE',
    })
    showFeedback('Vaga excluída com sucesso!')
    showConfirmDialog.value = false
    await loadJobs() // Refresh list
  } catch (e) {
    console.error('Erro ao excluir:', e)
    showFeedback('Erro ao excluir vaga.', 'error')
  } finally {
    deleting.value = false
  }
}

// Initial Load
onMounted(async () => {
  await fetchUser() // Ensure auth state
  loadJobs()
})
</script>

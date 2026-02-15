<template>
  <v-app>
    <v-app-bar color="primary" density="compact" flat>
      <v-container class="d-flex align-center py-0">
        <v-app-bar-title class="font-weight-bold text-white">
          Vagas
        </v-app-bar-title>
        <v-spacer />
        <v-btn v-if="!isLoggedIn" to="/login" variant="text" size="small" prepend-icon="mdi-login">
          Entrar
        </v-btn>
        <v-btn v-else to="/admin" variant="text" size="small" prepend-icon="mdi-view-dashboard">
          Painel
        </v-btn>
      </v-container>
    </v-app-bar>

    <v-main class="bg-grey-lighten-5">
      <v-container class="py-10" max-width="900">
        <!-- Header e Busca -->
        <div class="mb-8 text-center">
          <h1 class="text-h4 font-weight-bold text-primary mb-2">
            Encontre sua próxima oportunidade
          </h1>
          <p class="text-body-1 text-medium-emphasis mb-6">
            Confira as vagas abertas e candidate-se hoje mesmo.
          </p>

          <v-text-field
            v-model="search"
            label="Buscar vagas pelo título..."
            placeholder="Ex: Desenvolvedor Ruby, Front-end Vue..."
            variant="outlined"
            bg-color="surface"
            prepend-inner-icon="mdi-magnify"
            rounded="lg"
            hide-details
            density="comfortable"
            class="mx-auto"
            style="max-width: 600px;"
            clearable
            @click:clear="search = ''"
          >
            <template #append-inner>
              <v-progress-circular
                v-if="loading && search"
                indeterminate
                size="20"
                width="2"
                color="primary"
              />
            </template>
          </v-text-field>
        </div>

        <!-- Feedback de Loading Inicial -->
        <div v-if="initialLoading">
          <v-row>
            <v-col v-for="n in 4" :key="n" cols="12" md="6">
              <v-skeleton-loader type="card" class="rounded-lg" elevation="0" border />
            </v-col>
          </v-row>
        </div>

        <!-- Lista de Vagas -->
        <div v-else>
          <v-slide-y-transition group>
            <v-row v-if="jobs?.length > 0">
              <v-col v-for="job in jobs" :key="job.id" cols="12" md="6">
                <v-card
                  variant="flat"
                  border
                  rounded="lg"
                  class="h-100 transition-swing"
                  hover
                  @click="openJob(job)"
                >
                  <div class="pa-5">
                    <div class="d-flex justify-space-between align-start mb-2">
                      <h3 class="text-h6 font-weight-bold text-truncate pr-2">
                        {{ job.title }}
                      </h3>
                      <v-icon icon="mdi-open-in-new" size="small" color="grey-lighten-1" />
                    </div>

                    <div class="d-flex flex-wrap gap-2 mb-4">
                      <v-chip
                        v-if="job.location"
                        size="x-small"
                        variant="tonal"
                        color="primary"
                        label
                      >
                        {{ job.location }}
                      </v-chip>
                      <v-chip
                        v-if="job.employment_type"
                        size="x-small"
                        variant="tonal"
                        color="secondary"
                        label
                      >
                        {{ job.employment_type.toUpperCase() }}
                      </v-chip>
                    </div>

                    <p class="text-body-2 text-medium-emphasis line-clamp-3 mb-0">
                      {{ job.description }}
                    </p>
                  </div>
                  
                  <v-divider />
                  
                  <div class="px-5 py-3 d-flex align-center justify-space-between bg-grey-lighten-5">
                     <span class="text-caption text-medium-emphasis">
                       Atualizado há {{ timeAgo(job.updated_at) }}
                     </span>
                     <span class="text-caption font-weight-bold text-primary">
                       Ver detalhes ->
                     </span>
                  </div>
                </v-card>
              </v-col>
            </v-row>
          </v-slide-y-transition>

          <!-- Empty State -->
          <v-alert
            v-if="!loading && jobs?.length === 0"
            icon="mdi-briefcase-search-outline"
            title="Nenhuma vaga encontrada"
            text="Tente ajustar sua busca ou volte mais tarde para conferir novas oportunidades."
            type="info"
            variant="tonal"
            class="mt-8 border-dashed"
            rounded="lg"
          />
        </div>
      </v-container>
    </v-main>

    <!-- Modal de Detalhes -->
    <JobDetailDialog v-model="showDialog" :job="selectedJob" />
  </v-app>
</template>

<script setup lang="ts">
const { isLoggedIn, apiFetch } = useAuth()

const jobs = ref<any[]>([])
const search = ref('')
const initialLoading = ref(true)
const loading = ref(false)
let debounceTimer: any = null

// Modal state
const showDialog = ref(false)
const selectedJob = ref(null)

const fetchJobs = async () => {
  loading.value = true
  try {
    const params = search.value ? { q: search.value } : {}
    const result = await apiFetch<any[]>('/jobs', { params })
    jobs.value = Array.isArray(result) ? result : []
  } catch (e) {
    jobs.value = []
    console.error('Erro ao buscar vagas:', e)
  } finally {
    loading.value = false
    initialLoading.value = false
  }
}

watch(search, () => {
  loading.value = true 
  if (debounceTimer) clearTimeout(debounceTimer)
  
  debounceTimer = setTimeout(() => {
    fetchJobs()
  }, 500)
})

// Initial Load
onMounted(() => {
  fetchJobs()
})

const openJob = (job: any) => {
  selectedJob.value = job
  showDialog.value = true
}

const timeAgo = (dateString: string) => {
  const days = Math.floor((new Date().getTime() - new Date(dateString).getTime()) / (1000 * 3600 * 24))
  return days === 0 ? 'hoje' : `${days} dias`
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.gap-2 {
  gap: 8px;
}
</style>

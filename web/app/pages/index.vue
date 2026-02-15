<template>
  <v-app>
    <v-app-bar color="primary" density="compact">
      <v-app-bar-title class="font-weight-bold">Vagas</v-app-bar-title>
      <template #append>
        <v-btn v-if="!isLoggedIn" to="/login" variant="outlined" size="small">
          Entrar
        </v-btn>
        <v-btn v-else to="/admin" variant="outlined" size="small">
          Painel
        </v-btn>
      </template>
    </v-app-bar>

    <v-main>
      <v-container class="py-8">
        <h1 class="text-h4 font-weight-bold mb-6">Vagas Abertas</h1>

        <v-progress-linear v-if="loading" indeterminate color="primary" class="mb-4" />

        <v-row v-else>
          <v-col v-for="job in jobs" :key="job.id" cols="12" md="6">
            <v-card variant="outlined" rounded="lg" class="h-100">
              <v-card-title class="text-h6">{{ job.title }}</v-card-title>
              <v-card-subtitle>
                <v-chip v-if="job.location" size="small" class="mr-2" prepend-icon="mdi-map-marker">
                  {{ job.location }}
                </v-chip>
                <v-chip v-if="job.employment_type" size="small" prepend-icon="mdi-briefcase">
                  {{ job.employment_type.toUpperCase() }}
                </v-chip>
              </v-card-subtitle>
              <v-card-text class="text-body-2 text-medium-emphasis">
                {{ job.description }}
              </v-card-text>
            </v-card>
          </v-col>
        </v-row>

        <v-alert v-if="!loading && jobs.length === 0" type="info" variant="tonal" class="mt-4">
          Nenhuma vaga publicada no momento.
        </v-alert>
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
const { isLoggedIn, apiFetch } = useAuth()
const jobs = ref<any[]>([])
const loading = ref(true)

onMounted(async () => {
  try {
    jobs.value = await apiFetch<any[]>('/jobs')
  } catch (e) {
    console.error('Erro ao carregar vagas:', e)
  } finally {
    loading.value = false
  }
})
</script>

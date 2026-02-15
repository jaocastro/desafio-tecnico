<template>
  <v-dialog
    v-model="internalModel"
    max-width="600"
    scrollable
  >
    <v-card class="rounded-lg" elevation="4">
      <v-toolbar color="surface" density="compact" class="border-b">
        <v-toolbar-title class="text-subtitle-1 font-weight-bold pl-4">
          Detalhes da Vaga
        </v-toolbar-title>
        <v-spacer />
        <v-btn icon="mdi-close" variant="text" size="small" @click="internalModel = false" />
      </v-toolbar>

      <v-card-text class="pa-6">
        <div class="mb-4">
          <h2 class="text-h5 font-weight-bold text-primary mb-1">
            {{ job?.title }}
          </h2>
          <div class="d-flex align-center flex-wrap gap-2 mt-2">
            <v-chip
              v-if="job?.location"
              size="small"
              variant="tonal"
              color="primary"
              prepend-icon="mdi-map-marker"
              class="mr-2"
            >
              {{ job.location }}
            </v-chip>
            <v-chip
              v-if="job?.employment_type"
              size="small"
              variant="tonal"
              color="secondary"
              prepend-icon="mdi-briefcase"
            >
              {{ job.employment_type.toUpperCase() }}
            </v-chip>
            <v-chip
              size="small"
              variant="text"
              class="text-caption text-medium-emphasis pl-0"
              prepend-icon="mdi-clock-outline"
            >
              Publicada em {{ formatDate(job?.updated_at) }}
            </v-chip>
          </div>
        </div>

        <v-divider class="mb-4" />

        <div class="text-body-1 text-high-emphasis" style="line-height: 1.6; white-space: pre-wrap;">
          {{ job?.description }}
        </div>
      </v-card-text>

      <v-card-actions class="pa-4 pt-0 border-t bg-grey-lighten-4">
        <v-spacer />
        <v-btn
          variant="text"
          color="grey-darken-1"
          @click="internalModel = false"
        >
          Fechar
        </v-btn>
        <v-btn
          color="primary"
          variant="flat"
          prepend-icon="mdi-send"
          @click="applyToJob"
        >
          Candidatar-se
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: boolean
  job: any
}>()

const emit = defineEmits(['update:modelValue'])

const internalModel = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const formatDate = (dateString: string) => {
  if (!dateString) return ''
  return new Date(dateString).toLocaleDateString('pt-BR', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
  })
}

const applyToJob = () => {
  alert('Funcionalidade de candidatura em breve!')
  internalModel.value = false
}
</script>

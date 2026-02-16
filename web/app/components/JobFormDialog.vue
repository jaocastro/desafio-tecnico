<template>
  <v-dialog
    v-model="internalModel"
    max-width="600"
    persistent
  >
    <v-card rounded="lg">
      <v-toolbar color="surface" density="compact" class="border-b pl-4 pr-2">
        <v-toolbar-title class="text-h6 font-weight-bold">
          {{ isEditing ? 'Editar Vaga' : 'Nova Vaga' }}
        </v-toolbar-title>
        <v-spacer />
        <v-btn icon="mdi-close" variant="text" size="small" @click="close" />
      </v-toolbar>

      <v-card-text class="pa-6">
        <v-form ref="form" v-model="valid" @submit.prevent="save">
          <v-text-field
            v-model="formData.title"
            label="Título da Vaga"
            placeholder="Ex: Desenvolvedor Senior"
            variant="outlined"
            density="comfortable"
            :rules="[rules.required, rules.minLength(3)]"
            class="mb-4"
          />

          <v-row>
            <v-col cols="12" sm="6">
              <v-select
                v-model="formData.employment_type"
                label="Tipo de Contrato"
                :items="employementOptions"
                variant="outlined"
                density="comfortable"
                :rules="[rules.required]"
              />
            </v-col>
            <v-col cols="12" sm="6">
              <v-text-field
                v-model="formData.location"
                label="Localização"
                placeholder="Ex: Remoto, São Paulo..."
                variant="outlined"
                density="comfortable"
              />
            </v-col>
          </v-row>

          <v-textarea
            v-model="formData.description"
            label="Descrição Completa"
            placeholder="Descreva as responsabilidades e requisitos..."
            variant="outlined"
            rows="6"
            :rules="[rules.required, rules.minLength(30)]"
            class="mb-4"
          />

          <v-select
            v-model="formData.status"
            label="Status"
            :items="statusOptions"
            variant="outlined"
            density="comfortable"
            hint="Vagas 'draft' não aparecem na listagem pública"
            persistent-hint
            :rules="[rules.required]"
          />
        </v-form>
      </v-card-text>

      <v-divider />

      <v-card-actions class="pa-4 bg-grey-lighten-5">
        <v-spacer />
        <v-btn
          variant="text"
          color="grey-darken-1"
          @click="close"
        >
          Cancelar
        </v-btn>
        <v-btn
          color="primary"
          variant="flat"
          @click="save"
          :loading="loading"
          :disabled="!valid"
        >
          Salvar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: boolean
  job: any | null
  loading?: boolean
}>()

const emit = defineEmits(['update:modelValue', 'save'])

const form = ref<any>(null)
const valid = ref(false)
const internalModel = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const isEditing = computed(() => !!props.job)

const formData = ref({
  title: '',
  description: '',
  location: '',
  employment_type: 'full_time',
  status: 'draft',
})

const employementOptions = [
  { title: 'Tempo Integral', value: 'full_time' },
  { title: 'Meio Período', value: 'part_time' },
  { title: 'Contrato', value: 'contract' },
  { title: 'Freelance', value: 'freelance' },
]

const statusOptions = [
  { title: 'Rascunho', value: 'draft' },
  { title: 'Publicado', value: 'published' },
  { title: 'Arquivado', value: 'archived' },
]

const rules = {
  required: (v: any) => !!v || 'Campo obrigatório',
  minLength: (min: number) => (v: string) => (v && v.length >= min) || `Mínimo de ${min} caracteres`,
}

// Watch job change to update form data
watch(() => props.job, (newJob) => {
  if (newJob) {
    formData.value = { ...newJob }
  } else {
    // Reset form for create mode
    formData.value = {
      title: '',
      description: '',
      location: '',
      employment_type: 'full_time',
      status: 'draft',
    }
  }
}, { immediate: true })

const close = () => {
  internalModel.value = false
}

const save = async () => {
  if (!form.value) return
  const { valid } = await form.value.validate()
  if (valid) {
    emit('save', { ...formData.value })
  }
}
</script>

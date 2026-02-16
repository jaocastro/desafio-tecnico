<template>
  <v-dialog
    v-model="internalModel"
    max-width="400"
  >
    <v-card rounded="lg">
      <v-card-title class="text-h6 font-weight-bold pt-4 px-6">
        {{ title }}
      </v-card-title>

      <v-card-text class="text-body-1 px-6 pb-2">
        {{ message }}
      </v-card-text>

      <v-card-actions class="px-6 pb-4">
        <v-spacer />
        <v-btn
          variant="text"
          color="grey-darken-1"
          @click="internalModel = false"
        >
          Cancelar
        </v-btn>
        <v-btn
          color="error"
          variant="flat"
          @click="confirm"
          :loading="loading"
        >
          Confirmar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script setup lang="ts">
const props = defineProps<{
  modelValue: boolean
  title?: string
  message?: string
  loading?: boolean
}>()

const emit = defineEmits(['update:modelValue', 'confirm'])

const internalModel = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val),
})

const confirm = () => {
  emit('confirm')
}
</script>

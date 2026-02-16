<template>
  <v-card variant="outlined" rounded="lg" class="border">
    <!-- Toolbar com Busca e Botão Novo -->
    <div class="d-flex align-center flex-wrap pa-4 gap-4 border-b">
      <v-text-field
        v-model="internalSearch"
        prepend-inner-icon="mdi-magnify"
        label="Buscar na tabela..."
        variant="outlined"
        density="compact"
        hide-details
        style="max-width: 300px; min-width: 200px;"
        bg-color="surface"
        @update:model-value="$emit('update:search', $event)"
      />
      <v-spacer />
      <v-btn
        color="primary"
        variant="elevated"
        prepend-icon="mdi-plus"
        @click="$emit('create')"
      >
        Nova Vaga
      </v-btn>
    </div>

    <v-data-table-server
      v-model:items-per-page="internalItemsPerPage"
      v-model:page="internalPage"
      :headers="headers"
      :items="items"
      :items-length="totalItems"
      :loading="loading"
      :search="internalSearch"
      hover
      density="comfortable"
      class="rounded-0"
      @update:options="$emit('update:options', $event)"
    >
      <!-- Slot: Status -->
      <template #item.status="{ item }">
        <v-chip
          :color="getStatusColor(item.status)"
          size="small"
          variant="tonal"
          class="font-weight-medium"
        >
          {{ item.status.toUpperCase() }}
        </v-chip>
      </template>

      <!-- Slot: Tipo -->
      <template #item.employment_type="{ item }">
        <span class="text-caption text-medium-emphasis text-uppercase">
          {{ item.employment_type?.replace('_', ' ') }}
        </span>
      </template>

      <!-- Slot: Data -->
      <template #item.updated_at="{ item }">
        <span class="text-body-2">
          {{ formatDate(item.updated_at) }}
        </span>
      </template>

      <!-- Slot: Ações -->
      <template #item.actions="{ item }">
        <div class="d-flex justify-end gap-2">
          <v-btn
            size="small"
            color="primary"
            variant="text"
            prepend-icon="mdi-pencil"
            @click.stop="$emit('edit', item)"
          >
            Editar
          </v-btn>
          <v-btn
            size="small"
            color="error"
            variant="text"
            prepend-icon="mdi-delete"
            @click.stop="$emit('delete', item)"
          >
            Excluir
          </v-btn>
        </div>
      </template>

      <!-- Slot: Loading -->
      <template #loading>
        <v-skeleton-loader type="table-row@6" />
      </template>
    </v-data-table-server>
  </v-card>
</template>

<script setup lang="ts">
const props = defineProps<{
  items: any[]
  totalItems: number
  loading: boolean
  page: number
  itemsPerPage: number
  search: string
}>()

const emit = defineEmits([
  'create', 'edit', 'delete',
  'update:page', 'update:itemsPerPage', 'update:search', 'update:options'
])

const internalPage = computed({
  get: () => props.page,
  set: (val) => emit('update:page', val),
})

const internalItemsPerPage = computed({
  get: () => props.itemsPerPage,
  set: (val) => emit('update:itemsPerPage', val),
})

const internalSearch = computed({
  get: () => props.search,
  set: (val) => emit('update:search', val),
})

const headers = [
  { title: 'ID', key: 'id', width: '80px' },
  { title: 'Título', key: 'title' },
  { title: 'Status', key: 'status', width: '120px' },
  { title: 'Tipo', key: 'employment_type' },
  { title: 'Atualizado em', key: 'updated_at', width: '150px' },
  { title: 'Ações', key: 'actions', sortable: false, align: 'end', width: '200px' },
]

const getStatusColor = (status: string) => {
  switch (status) {
    case 'published': return 'success'
    case 'draft': return 'warning'
    case 'archived': return 'grey'
    default: return 'primary'
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString('pt-BR')
}
</script>

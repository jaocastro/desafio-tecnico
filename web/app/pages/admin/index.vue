<template>
  <v-app>
    <v-app-bar color="primary" density="compact">
      <v-app-bar-title class="font-weight-bold">Painel Admin</v-app-bar-title>
      <template #append>
        <span class="text-body-2 mr-4">{{ user?.email }}</span>
        <v-btn variant="outlined" size="small" @click="logout">
          Sair
        </v-btn>
      </template>
    </v-app-bar>

    <v-main>
      <v-container class="py-8">
        <h1 class="text-h4 font-weight-bold mb-2">Vagas</h1>
        <p class="text-body-1 text-medium-emphasis mb-6">
          Gerencie todas as vagas da plataforma.
        </p>

        <v-alert type="success" variant="tonal">
          Login realizado com sucesso! A listagem completa de vagas será implementada aqui.
        </v-alert>
      </v-container>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
const { user, logout, fetchUser } = useAuth()

onMounted(() => fetchUser())
</script>

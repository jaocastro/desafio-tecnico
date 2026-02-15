<template>
  <v-app>
    <v-main class="d-flex align-center justify-center" style="min-height: 100vh; background: #f5f5f5;">
      <v-card width="420" class="pa-6" elevation="2" rounded="lg">
        <v-card-title class="text-h5 font-weight-bold text-center mb-2">
          Entrar
        </v-card-title>

        <v-card-subtitle class="text-center mb-6">
          Acesse o painel administrativo
        </v-card-subtitle>

        <v-alert
          v-if="error"
          type="error"
          variant="tonal"
          class="mb-4"
          closable
          @click:close="error = ''"
        >
          {{ error }}
        </v-alert>

        <v-form @submit.prevent="handleLogin" :disabled="loading">
          <v-text-field
            v-model="email"
            label="Email"
            type="email"
            variant="outlined"
            prepend-inner-icon="mdi-email-outline"
            :rules="[rules.required, rules.email]"
            class="mb-2"
          />

          <v-text-field
            v-model="password"
            label="Senha"
            :type="showPassword ? 'text' : 'password'"
            variant="outlined"
            prepend-inner-icon="mdi-lock-outline"
            :append-inner-icon="showPassword ? 'mdi-eye-off' : 'mdi-eye'"
            @click:append-inner="showPassword = !showPassword"
            :rules="[rules.required]"
            class="mb-4"
          />

          <v-btn
            type="submit"
            color="primary"
            size="large"
            block
            :loading="loading"
          >
            Entrar
          </v-btn>
        </v-form>
      </v-card>
    </v-main>
  </v-app>
</template>

<script setup lang="ts">
const { login } = useAuth()

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const loading = ref(false)
const error = ref('')

const rules = {
  required: (v: string) => !!v || 'Campo obrigatório',
  email: (v: string) => /.+@.+\..+/.test(v) || 'Email inválido',
}

const handleLogin = async () => {
  if (!email.value || !password.value) return

  loading.value = true
  error.value = ''

  try {
    await login(email.value, password.value)
  } catch (err: any) {
    error.value = err?.data?.error || 'Erro ao fazer login. Verifique suas credenciais.'
  } finally {
    loading.value = false
  }
}
</script>

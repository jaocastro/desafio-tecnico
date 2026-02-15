interface User {
  id: number
  email: string
}

interface LoginResponse {
  token: string
  user: User
}

export const useAuth = () => {
  const token = useCookie('auth_token', {
    maxAge: 60 * 60 * 24,
    path: '/',
    sameSite: 'lax',
  })
  const user = useState<User | null>('auth_user', () => null)
  const config = useRuntimeConfig()

  const isLoggedIn = computed(() => !!token.value)

  const apiFetch = <T>(path: string, options: any = {}) => {
    return $fetch<T>(`${config.public.apiBase}${path}`, {
      ...options,
      headers: {
        ...options.headers,
        ...(token.value ? { Authorization: `Bearer ${token.value}` } : {}),
      },
    })
  }

  const login = async (email: string, password: string) => {
    const data = await apiFetch<LoginResponse>('/auth/login', {
      method: 'POST',
      body: { email, password },
    })

    token.value = data.token
    user.value = data.user
    await navigateTo('/admin')
  }

  const logout = () => {
    token.value = null
    user.value = null
    navigateTo('/login')
  }

  const fetchUser = async () => {
    if (!token.value) return
    if (user.value) return
    try {
      const data = await apiFetch<{ user: User }>('/auth/me')
      user.value = data.user
    } catch (err: any) {
      if (err?.response?.status === 401) {
        token.value = null
        user.value = null
      }
    }
  }

  return { token, user, isLoggedIn, login, logout, fetchUser, apiFetch }
}

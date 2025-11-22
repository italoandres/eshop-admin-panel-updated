import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    allowedHosts: [
      'spas-sorry-leave-character.trycloudflare.com',
      '.trycloudflare.com'
    ]
  }
})
import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

// https://vitejs.dev/config/
export default defineConfig({
    plugins: [vue()],
    build: {
        outDir: '../../dist/frontend-build',
    },
    publicDir: './public',
    appType: 'spa',
    root: '.',
    server: {
        port: 6060,
        host: '0.0.0.0',
        proxy: {
            '/api': {
                target: 'http://localhost:4000/',
                secure: false,
                changeOrigin: true,
            },
        },
    },
    resolve: {
        extensions: ['.js', '.vue', '.ts'],
    },
});

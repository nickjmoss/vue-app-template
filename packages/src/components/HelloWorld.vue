<script setup lang="ts">
import { onMounted, ref } from 'vue';

const testMsg = ref('');

onMounted(async () => {
    const data = await fetch('/api/ping');
    const text = await data.text();
    testMsg.value = text;
});

defineProps<{ msg: string }>();

const count = ref(0);
</script>

<template>
    <h1>{{ msg }}</h1>

    <div class="card">
        <button type="button" @click="count++">count is {{ count }}</button>
        <p>
            Edit
            <code>components/HelloWorld.vue</code>
            to test HMR
        </p>
        <p>Response from server ping: {{ testMsg }}</p>
    </div>

    <p>
        Check out
        <a
            href="https://vuejs.org/guide/quick-start.html#local"
            target="_blank"
        >
            create-vue
        </a>
        , the official Vue + Vite starter
    </p>
    <p>
        Install
        <a href="https://github.com/vuejs/language-tools" target="_blank">
            Volar
        </a>
        in your IDE for a better DX
    </p>
    <p class="read-the-docs">Click on the Vite and Vue logos to learn more</p>
</template>

<style scoped>
.read-the-docs {
    color: #888;
}
</style>

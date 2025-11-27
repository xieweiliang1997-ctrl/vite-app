<script setup>
import { onMounted, ref } from 'vue';
import axios from 'axios';

const message = ref('');
const error = ref('');

onMounted(() => {
  axios
    .get('/api/hello')
    .then(response => {
      message.value = typeof response.data === 'string' ? response.data : JSON.stringify(response.data);
    })
    .catch(err => {
      error.value = '接口调用失败，请检查后台服务';
      console.error('There was an error!', err);
    });
});
</script>

<template>
  <main class="container">
    <h1>/hello 接口调试</h1>
    <p v-if="message" class="success">响应：{{ message }}</p>
    <p v-else-if="!error" class="pending">等待接口响应...</p>
    <p v-if="error" class="error">{{ error }}</p>
  </main>
</template>

<style scoped>
.container {
  padding: 2rem;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

.success {
  color: #2f9e44;
}

.pending {
  color: #5f3dc4;
}

.error {
  color: #c92a2a;
}
</style>

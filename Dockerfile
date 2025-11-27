# 多阶段构建：先构建 React 项目，再用 Nginx 部署（减小镜像体积）
FROM node:22-alpine AS build-stage
WORKDIR /app
COPY package*.json ./
# 国内源加速 npm 安装
RUN npm install --registry=https://registry.npm.taobao.org
COPY . .
# 构建生产环境产物
RUN npm run build

# 部署阶段：使用 Nginx 静态服务器
FROM nginx:alpine AS production-stage
# 复制构建产物到 Nginx 静态目录
COPY --from=build-stage /app/dist /usr/share/nginx/html
# 复制自定义 Nginx 配置（可选，解决 React 路由刷新 404 问题）
COPY nginx.conf /etc/nginx/conf.d/default.conf
# 暴露 80 端口
EXPOSE 80
# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
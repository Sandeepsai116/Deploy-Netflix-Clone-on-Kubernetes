# Stage 1: Build the application
FROM node:16.17.0-alpine as builder
WORKDIR /app
COPY ./package.json ./
COPY ./yarn.lock ./
RUN yarn install
COPY . ./
# Directly inserting the API key into the build
ENV VITE_APP_TMDB_V3_API_KEY="5eeb5d11cd5f05d020cf4cb159c571e5"
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build

# Stage 2: Serve the application with NGINX
FROM nginx:stable-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/dist ./
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]

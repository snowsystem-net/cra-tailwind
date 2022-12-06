FROM node:14.19-buster AS builder
WORKDIR /app

RUN apt-get update

COPY app/package*.json /app/
COPY app/tsconfig.json /app/
RUN npm install

COPY app/src /app/src/
COPY app/public /app/public/
RUN npm run build

FROM nginx:1.18-alpine
COPY docker/prod/nginx/default.conf /etc/nginx/conf.d/
COPY --from=builder /app/build /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]

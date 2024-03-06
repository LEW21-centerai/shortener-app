FROM node:21.6.2-alpine
RUN corepack enable

WORKDIR /root

COPY . .
RUN yarn
RUN yarn parcel build

FROM nginx:1.25.4-alpine

COPY --from=0 /root/dist /usr/share/nginx/html
COPY docker-entrypoint-config.sh /docker-entrypoint.d/config.sh

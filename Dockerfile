FROM node:10 AS builder
WORKDIR /app
COPY package.json yarn.lock ./
RUN npm install

FROM builder AS static_build
COPY . .

RUN npm run build

FROM nginx:1.15.2-alpine
RUN apk add --no-cache nginx-mod-http-perl=1.12.2-r4

COPY --from=static_build /app/dist /var/www
COPY --from=static_build /app/config/nginx/nginx.conf /etc/nginx/nginx.conf


# ENV NGINX_REPLACE_ENV "staging"
# ENV NGINX_REPLACE_BASE_URL "https://dashboard-api-staging.oengine.io/api/v1/dashboard"
# ENV NGINX_REPLACE_JWT_PUB "-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq7FyJpm7By6zeUzYpYos8HjGhdVN7x9tlqt8a0Xn8+g0tXKrrOm9SIelqpETAoICDQ4DADVWZScMRN/StH9HJmp61drVfecBaeeSaoxa/tHpYXIbMShjshy7h0QQeD8100ADcDCXm88FPoy3yRpXZ95/2sZpDPBsBXMnxkvCjQuW1/EaOSE1V2dl9Y4AJd/BriTgTvV1WHQgGp39nbhrtGSYrTlVgK2Sc0vr+qHzqgGKUxkpXwx0AdR+vbI/n0ESDTbX2lvcgVEuRXRcFAZy+407p20KNZ9mWWlsDDuyeLgfi7bCQl0bR8p/NQs8kUZXGoaC4jERBrLt+vxKyGaWJQIDAQAB-----END PUBLIC KEY-----"
# ENV NGINX_REPLACE_BASIC_TOKEN "REFTSEJPQVJEOnhHbiQ3R1hSanlqNTl4Y29MVyVO"
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
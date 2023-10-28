FROM node:18.18.2-alpine3.18

ARG NODE_ENV
ENV NODE_ENV=$NODE_ENV

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN yarn global add pnpm && pnpm i --frozen-lockfile
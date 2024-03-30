FROM node:20.10.0-bullseye
RUN apt-get update && apt-get install libjemalloc2 && ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so
ARG NODE_ENV=production
ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so
RUN corepack enable
WORKDIR /media-proxy
COPY --link ["pnpm-lock.yaml", "package.json","tsconfig.json","server.js","LICENSE", "./"]
COPY --link ["src", "./src"]
COPY --link ["built", "./built"]
COPY --link ["assets", "./assets"]
RUN --mount=type=cache,target=/root/.local/share/pnpm/store,sharing=locked pnpm i --frozen-lockfile --aggregate-output
RUN pnpm install
ENV PORT=12766
EXPOSE 12766
COPY --link ["config.js", "./"]
CMD ["npm","start"]


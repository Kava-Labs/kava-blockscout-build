ARG BLOCKSCOUT_VERSION=5.1.4

FROM elixir:1.14 as backend-builder
ARG BLOCKSCOUT_VERSION

WORKDIR /src

RUN apt-get update \
  && apt-get install -y git

RUN git clone --depth 1 --branch v${BLOCKSCOUT_VERSION}-beta https://github.com/blockscout/blockscout.git \
  && cd blockscout \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get --only prod \
  && MIX_ENV=prod mix compile

FROM node:18 as frontend-builder

WORKDIR /src
COPY --from=backend-builder /src/blockscout/ /src/blockscout/

RUN cd blockscout/apps/block_scout_web/assets \
  && npm install \
  && NODE_ENV=prod npm run deploy \
  && cd ../../explorer \
  && npm install

FROM backend-builder as release-builder

WORKDIR /src

COPY --from=frontend-builder /src/blockscout/apps/block_scout_web/priv/static/ /src/blockscout/apps/block_scout_web/priv/static

RUN cd blockscout \
  && MIX_ENV=prod mix phx.digest \
  && MIX_ENV=prod mix release

FROM debian:11 as runner
ARG BLOCKSCOUT_VERSION

RUN apt-get update \
  && apt-get install -y locales ca-certificates \
  && rm -rf /var/lib/apt/lists/* \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen \
  && update-ca-certificates

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

WORKDIR /app

COPY --from=release-builder /src/blockscout/_build/prod/rel/blockscout/ /app/
COPY --from=frontend-builder /src/blockscout/apps/explorer/node_modules /app/node_modules
COPY --from=backend-builder /src/blockscout/config/config_helper.exs /app/config/config_helper.exs
COPY --from=backend-builder /src/blockscout/config/config_helper.exs /app/releases/${BLOCKSCOUT_VERSION}/config_helper.exs

CMD ["sh", "-c", "/app/bin/blockscout eval 'Elixir.Explorer.ReleaseTasks.create_and_migrate()' && /app/bin/blockscout start"]

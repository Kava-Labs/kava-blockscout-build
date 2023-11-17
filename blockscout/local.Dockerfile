# Raw version representing v5.3.1-beta
ARG BLOCKSCOUT_VERSION=5.3.1

#
# The backend-builder uses the official exlixir docker image that contains
# Elixir, Erlang, compatiable OTP version, and mix.
#
FROM elixir:1.14-otp-25 as backend-builder
ARG BLOCKSCOUT_VERSION

WORKDIR /src

# All elixir dependencies are already installed
# We only need git to clone and apply patches
RUN apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

# COPY patches first, since we want to apply after clone, but before compiling
# This does force a re-clone if there are patch changes, but also reduces our layers.
#
COPY ./patches /src/patches

# The order of the below steps must be kept the same
#
# Clone the  blockscout repository
RUN git clone --depth 1 --branch v${BLOCKSCOUT_VERSION}-beta https://github.com/blockscout/blockscout.git
WORKDIR blockscout
# apply patches
RUN git apply /src/patches/*.patch
RUN mix local.hex --force
RUN mix local.rebar --force
# install prod dependencies
RUN mix deps.get
# compile minimal production optimized version of application
RUN mix compile
# The order of the above steps must be kept the same
#

WORKDIR /src

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs \
    build-essential && \
    node --version && \
    npm --version
# Build the user interface (block_scout_web/assets) and then install the solc npm package (explorer)
RUN cd blockscout/apps/block_scout_web/assets \
  && npm install \
  && NODE_ENV=prod npm run deploy \
  && cd ../../explorer \
  && npm install

WORKDIR /src/blockscout

#
CMD tail -f /dev/null

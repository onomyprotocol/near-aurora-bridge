# from ubuntu:18.04
FROM nearprotocol/nearup

# ---------- install utils ----------

RUN apt update
RUN apt install -y curl git wget

# ---------- install npm and nodejs ----------

ARG NODE_VERSION=14.18.0
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN node --version
RUN npm --version

# ---------- install near and aurora cli ----------

RUN npm install -g near-cli

RUN npm install -g aurora-is-near/aurora-cli

ADD https://github.com/aurora-is-near/aurora-engine/releases/download/latest/mainnet-release.wasm /assets/mainnet-release.wasm

COPY scripts /scripts
RUN chmod +x /scripts/run.sh

ENTRYPOINT /scripts/run.sh
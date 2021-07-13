FROM ubuntu:latest

RUN apt-get update -y -q && apt-get upgrade -yq
# common (DEBIAN_FRONTEND is a fix for tzdata)
RUN DEBIAN_FRONTEND="noninteractive" apt-get install --no-install-recommends -yq software-properties-common \
                                                curl \
                                                build-essential \
                                                ca-certificates \
                                                tar \
                                                git

# ------------------ clone repository ------------------

ARG GRAVITY_DIR=/go/src/github.com/onomyprotocol/cosmos-gravity-bridge/
# clone the repo
COPY . $GRAVITY_DIR

# ------------------ gravity module ------------------

# install golang
RUN curl https://dl.google.com/go/go1.16.4.linux-amd64.tar.gz --output go.tar.gz
RUN tar -C /usr/local -xzf go.tar.gz
ENV PATH="/usr/local/go/bin:$PATH"
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin

# build gravity artifact
WORKDIR $GRAVITY_DIR/module
RUN make
# copy binary to bin
RUN cp $GOPATH/bin/gravity /usr/bin/gravity

# ------------------ orchestrator ------------------

# install rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
# check cargo works
RUN cargo version

# build orchestrator artifact
WORKDIR $GRAVITY_DIR/orchestrator
RUN rustup target add x86_64-unknown-linux-musl
RUN apt-get install --no-install-recommends -yq musl-tools
RUN cargo build --target=x86_64-unknown-linux-musl --release  --all
# copy binary to bin
RUN ls target/x86_64-unknown-linux-musl
RUN ls target/x86_64-unknown-linux-musl/release
RUN cp target/x86_64-unknown-linux-musl/release/gbt /usr/bin/gbt

# ------------------ contract-deployer ------------------

RUN apt-get install --no-install-recommends -yq python3 \
                                                make \
                                                g++

RUN curl -sL https://deb.nodesource.com/setup_15.x  | bash -
RUN apt-get -y install nodejs

# build contract-deployer
WORKDIR $GRAVITY_DIR/solidity
RUN npm ci
RUN chmod -R +x scripts
RUN npm run typechain

# go to root home
WORKDIR /root/home

# ------------------ ethereum go (geth) ------------------
RUN add-apt-repository -y ppa:ethereum/ethereum
RUN apt-get install --no-install-recommends -yq ethereum

# ------------------ soft to run the scripts ------------------
RUN apt-get install --no-install-recommends -yq jq \
                                                moreutils

RUN cp -r $GRAVITY_DIR/deploy/single-node-runner/scripts scripts
RUN cp -r $GRAVITY_DIR/deploy/single-node-runner/assets assets

RUN /bin/bash scripts/init.sh
CMD /bin/bash scripts/run.sh
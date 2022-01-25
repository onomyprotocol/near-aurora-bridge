FROM fedora:34
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin
RUN dnf install -y git make gcc gcc-c++ which iproute iputils procps-ng vim-minimal tmux net-tools htop tar jq npm openssl-devel perl rust cargo golang
# only required for deployment script
RUN npm install -g ts-node && npm install -g typescript
# the actual source code for this repo, this **only** includes checked in files!
# this is a bit of a pain but it does speed things up a lot
ADD nab.tar.gz /
# build steps for all codebases in this repo, must be below the add statement
RUN pushd /nab/orchestrator/ && PATH=$PATH:$HOME/.cargo/bin cargo build --all --release
RUN pushd /nab/orchestrator/test_runner && cargo build --release --bin test-runner
RUN pushd /nab/module/ && PATH=$PATH:/usr/local/go/bin GOPROXY=https://proxy.golang.org make && PATH=$PATH:/usr/local/go/bin make install
RUN pushd /nab/solidity/ && npm ci

RUN mkdir -p /nab-target/orchestrator/target
RUN cp -r /nab/orchestrator/target /nab-target/orchestrator/target
RUN mkdir -p /nab-target/solidity/node_modules
RUN cp -r /nab/solidity/node_modules /nab-target/solidity/node_modules

RUN rm -r /nab
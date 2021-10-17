FROM registry.gitlab.com/rust_musl_docker/image:stable-latest 
RUN apt purge -y --auto-remove cmake
RUN apt-get update && apt-get install -y build-essential libtool autoconf unzip wget software-properties-common lsb-release python3-pip
RUN apt-get clean all
RUN pip3 install --upgrade cmake
# RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
# RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ $(lsb_release -cs) main"
# RUN apt update
# RUN apt install -y cmake

ENV RUSTUP_HOME=/rust
ENV CARGO_HOME=/cargo
ENV PATH=/cargo/bin:/rust/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal
RUN rustup target add x86_64-unknown-linux-musl
COPY entrypoint.sh /entrypoint.sh
RUN find / -perm /6000 -type f -exec chmod a-s {} \; || true
ENTRYPOINT ["/entrypoint.sh"]

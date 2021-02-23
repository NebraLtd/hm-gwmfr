#Gateway Mfr Docker File
#(C) Nebra LTD 2021
#Licensed under the MIT.
FROM arm64v8/ubuntu:20.04 AS buildstep

WORKDIR /opt/gateway_mfr

RUN apt-get update && apt-get -y install \
  automake \
  libtool \
  autoconf \
  git \
  ca-certificates \
  pkg-config \
  build-essential \
  wget \
  --no-install-recommends

RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.3.4.9-1~ubuntu~focal_arm64.deb

RUN dpkg -i esl-erlang_22.3.4.9-1~ubuntu~focal_arm64.deb ; exit 0

RUN apt-get install -f -y

RUN git clone https://github.com/helium/gateway_mfr.git

RUN cd gateway_mfr

RUN make release

FROM arm64v8/ubuntu:20.04

WORKDIR /opt/gateway_mfr



COPY --from=buildstep /opt/gateway_mfr .



#ENTRYPOINT ["sh", ""]

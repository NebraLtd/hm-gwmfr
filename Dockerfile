#Gateway Mfr Docker File
#(C) Nebra LTD 2021
#Licensed under the MIT.
FROM arm64v8/ubuntu:20.04 AS buildstep

WORKDIR /opt/gateway_mfr

RUN apt-get update && apt-get -y install \
  automake=1:1.16.1-4 \
  libtool=2.4.6-9 \
  autoconf=2.69-11 \
  git=1:2.20.1-2+deb10u3 \
  ca-certificates=20200601~deb10u2 \
  pkg-config=0.29-6 \
  build-essential=12.6 \
  wget=1.20.1-1.1 \
  --no-install-recommends

RUN wget https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_22.1.6-1~raspbian~buster_armhf.deb

RUN dpkg -i esl-erlang_22.1.6-1~raspbian~buster_armhf.deb

RUN apt-get install -f

RUN git clone https://github.com/helium/gateway_mfr.git

RUN cd gateway_mfr

RUN make release

FROM arm64v8/ubuntu:20.04

WORKDIR /opt/gateway_mfr



COPY --from=buildstep /opt/gateway_mfr .



#ENTRYPOINT ["sh", ""]

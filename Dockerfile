FROM arm32v6/alpine:3.12.4 as buildstep

# hadolint ignore=DL3018
RUN apk add --no-cache --update \
    git tar build-base linux-headers autoconf automake libtool pkgconfig \
    dbus-dev bzip2 bison flex gmp-dev cmake lz4 libsodium-dev openssl-dev \
    sed wget rust cargo erlang erlang-dev

ENV CC=gcc CXX=g++ CFLAGS="-U__sun__" \
    ERLANG_ROCKSDB_OPTS="-DWITH_BUNDLE_SNAPPY=ON -DWITH_BUNDLE_LZ4=ON" \
    ERL_COMPILER_OPTIONS="[deterministic]"


WORKDIR /opt/gateway_mfr
RUN git clone https://github.com/helium/gateway_mfr.git


WORKDIR /opt/gateway_mfr/gateway_mfr

RUN make release


FROM arm32v6/alpine:3.12.4

# hadolint ignore=DL3018
RUN apk add --no-cache --update erlang libsodium python3

WORKDIR /opt/gateway_mfr

COPY --from=buildstep /opt/gateway_mfr/gateway_mfr/_build/prod/rel/gateway_mfr .

COPY nebraScript.sh .
COPY eccProg.py .
RUN chmod +x nebraScript.sh

#ENTRYPOINT ["/opt/gateway_mfr/bin/gateway_mfr", "foreground"]
ENTRYPOINT ["sh" , "/opt/gateway_mfr/nebraScript.sh"]

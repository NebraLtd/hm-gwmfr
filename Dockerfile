ARG SYSTEM_TIMEZONE=Europe/London

####################################################################################################
################################## Stage: builder ##################################################

FROM balenalib/raspberry-pi-debian:buster-build as builder

# Copy build ARG
ARG SYSTEM_TIMEZONE

# Install dependencies
RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        erlang-nox=1:21.2.6+dfsg-1 \
        erlang-dev=1:21.2.6+dfsg-1 \
        git=1:2.20.1-2+deb10u3 \
        --no-install-recommends

# Change working directory and clone gateway_mfr repo
WORKDIR /opt/gateway_mfr
RUN git clone https://github.com/helium/gateway_mfr.git

# Change working directory
WORKDIR /opt/gateway_mfr/gateway_mfr

# Make gateway_mfr
RUN DEBUG=1 make release

# No need to cleanup the builder

####################################################################################################
################################### Stage: runner ##################################################

FROM balenalib/raspberry-pi-debian:buster-run

# Copy build ARG
ARG SYSTEM_TIMEZONE

# Install dependencies and clean up
RUN \
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="$SYSTEM_TIMEZONE" \
        apt-get -y install \
        erlang-nox=1:21.2.6+dfsg-1 \
        python3-minimal=3.7.3-1 \
        --no-install-recommends && \
        apt-get autoremove -y &&\
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

# Change working directory
WORKDIR /opt/gateway_mfr

# Copy gateway_mfr from builder
COPY --from=builder /opt/gateway_mfr/gateway_mfr/_build/prod/rel/gateway_mfr .

# Copy scripts
COPY nebraScript.sh .
COPY eccProg.py .

# Run nebraScript.sh start script
ENTRYPOINT ["/opt/gateway_mfr/nebraScript.sh"]

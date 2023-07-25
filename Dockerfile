# runtime stage
FROM ubuntu:20.04

RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends --yes install ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt
#COPY --from=builder /src/build/x86_64-linux-gnu/release/bin /usr/local/bin/
COPY  zephyr-cli-linux-v0.2.2 /tmp/src/
RUN chmod 0777 /tmp/src/*
RUN cp -rf /tmp/src/* /usr/local/bin/
RUN ls /usr/local/bin/

# Create zephyr user
RUN adduser --system --group --disabled-password zephyr && \
	mkdir -p /wallet /home/zephyr/.bitzephyr && \
	chown -R zephyr:zephyr /home/zephyr/.bitzephyr && \
	chown -R zephyr:zephyr /wallet

# Contains the blockchain
VOLUME /home/zephyr/.bitzephyr

# Generate your wallet via accessing the container and run:
# cd /wallet
# zephyr-wallet-cli
VOLUME /wallet

EXPOSE 18080
EXPOSE 18081

# switch to user zephyr
USER zephyr

ENTRYPOINT ["zephyrd"]
#CMD ["--p2p-bind-ip=0.0.0.0", "--p2p-bind-port=18080", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=18081", "--non-interactive", "--confirm-external-bind"]
CMD ["--config-file=/etc/zephyr/zephyr.conf","--non-interactive", "--confirm-external-bind"]


#!/bin/bash
docker stop zephyr
docker rm zephyr
docker run -d \
	-v zephyr_volume:/data/ \
	-v `pwd`/zephyr.conf:/etc/zephyr/zephyr.conf \
	-p 18080:18080 \
	-p 18081:18081 \
        --name zephyr \
	iotapi322/zephyr:v0.2.2


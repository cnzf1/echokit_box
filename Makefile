.PHONY: all
all: build write

.PHONY: debug
debug: build_debug write

.PHONY: bin
bin: build_bin write_bin

.PHONY: build
build:
	@export SSID="904_8888" && \
	export PASSWORD="wifipwd1115" && \
	export SERVER_URL="ws://192.168.112.168:8765" && \
	cargo b -r

.PHONY: build_debug
build_debug:
	@export SSID="904_8888" && \
	export PASSWORD="wifipwd1115" && \
	export SERVER_URL="ws://192.168.112.168:8765" && \
	RUST_BACKTRACE=1 cargo b -r

.PHONY: write
write:
	espflash flash --monitor --flash-size 16mb --partition-table partitions.csv target/xtensa-esp32s3-espidf/release/echokit

.PHONY: build_bin
build_bin:
	espflash save-image --chip esp32s3 --merge --flash-size 16mb --partition-table partitions.csv target/xtensa-esp32s3-espidf/release/echokit echokit.bin

.PHONY: write_bin
write_bin:
	espflash write-bin 0x00000 ./echokit.bin && espflash monitor

# 唤醒词模型
.PHONY: model
model:
	cd $(HOME)/esp/esp-sr && \
	python model/movemodel.py -d1 test_apps/esp-sr/sdkconfig.ci.wn9_hilexin -d2 . -d3 ./build && \
	espflash write-bin --baud 115200 0x710000 build/srmodels/srmodels.bin

# 清理
.PHONY: clean
clean:
	cargo clean

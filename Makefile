.PHONY: all
all: build write

.PHONY: debug
debug: build_debug write

.PHONY: bin
bin: build_bin write_bin

.PHONY: build
build:
	export SSID="904_8888" && \
	export PASSWORD="wifipwd1115" && \
	export SERVER_URL="ws://192.168.112.168:8765" && \
	cargo b -r

.PHONY: build_debug
build_debug:
	export SSID="904_8888" && \
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

.PHONY: clean
clean:
	cargo clean

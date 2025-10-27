.PHONY: boot

boot:
	moon build --target wasm
	cp target/wasm/release/build/main/main.wasm boot/moonyacc.wasm

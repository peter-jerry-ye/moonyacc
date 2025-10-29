.PHONY: boot benchmark

boot:
	moon build --target wasm
	cp target/wasm/release/build/main/main.wasm boot/moonyacc.wasm

benchmark:
	@echo "# iwasm (built without JIT, classic interp)"
	@time iwasm --interp --stack-size=1048576 --module-path=boot --dir=src/tests boot/moonyacc.wasm --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position src/tests/ocaml_jsoncst_test/ocaml.mly -o src/tests/ocaml_jsoncst_test/ocaml.mbt
	@echo "# wasmtime (cranelift)"
	@time wasmtime --dir src/tests --preload spectest=boot/spectest.wasm boot/moonyacc.wasm --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position src/tests/ocaml_jsoncst_test/ocaml.mly -o src/tests/ocaml_jsoncst_test/ocaml.mbt
	@echo "# wasmer (cranelift)"
	@time wasmer --dir /Users/yezihang/Documents/cakes/imoon/moonyacc boot/moonyacc.wasm -- --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position /Users/yezihang/Documents/cakes/imoon/moonyacc/src/tests/ocaml_jsoncst_test/ocaml.mly -o /Users/yezihang/Documents/cakes/imoon/moonyacc/src/tests/ocaml_jsoncst_test/ocaml.mbt
	@echo "# wasmedge (with jit)"
	@time wasmedge --enable-jit --dir src/tests boot/moonyacc.wasm --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position src/tests/ocaml_jsoncst_test/ocaml.mly -o src/tests/ocaml_jsoncst_test/ocaml.mbt
	@echo "# node (with js)"
	@time node boot/moonyacc.cjs --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position src/tests/ocaml_jsoncst_test/ocaml.mly -o src/tests/ocaml_jsoncst_test/ocaml.mbt
	@echo "# node (with wasm)"
	@time node main.mjs --compress-table --mode json-cst --input-mode pull --force-token-no-payload --force-int-position src/tests/ocaml_jsoncst_test/ocaml.mly -o src/tests/ocaml_jsoncst_test/ocaml.mbt
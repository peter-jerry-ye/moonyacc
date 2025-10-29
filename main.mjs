import { readFile } from "node:fs/promises";
import { WASI } from "node:wasi";
import { argv, env } from "node:process";

const wasi = new WASI({
    version: "preview1",
    args: argv,
    env,
    preopens: {
        "src/tests": "src/tests"
    }
})

const spectest = await WebAssembly.compile(
    await readFile(new URL("./boot/spectest.wasm", import.meta.url)),
)
const spectestInstance = await WebAssembly.instantiate(
    spectest,
    wasi.getImportObject()
)

const wasm = await WebAssembly.compile(
    await readFile(new URL("./boot/moonyacc.wasm", import.meta.url)),
)

const instance = await WebAssembly.instantiate(
    wasm,
    {
        ...wasi.getImportObject(),
        spectest: spectestInstance.exports
    }
)

wasi.start(instance);
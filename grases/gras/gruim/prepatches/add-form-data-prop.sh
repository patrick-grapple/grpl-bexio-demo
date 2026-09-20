#!/bin/sh
set -eu

node - <<'NODE'
const fs = require("fs");
const path = require("path");

function walk(dir, out) {
  out = out || [];
  if (!fs.existsSync(dir)) return out;
  fs.readdirSync(dir, { withFileTypes: true }).forEach(function(e) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) walk(p, out);
    else if (e.name.endsWith(".svelte")) out.push(p);
  });
  return out;
}

let count = 0;

walk("src/modules").forEach(function(file) {
  let src = fs.readFileSync(file, "utf8");
  if (src.indexOf("export let formData") !== -1) return;

  const isTsMode = src.indexOf('<script lang="ts">') !== -1;
  const formDataProp = isTsMode
    ? "export let formData: any = {}"
    : "export let formData = {}";

  let patched = src;

  const onSuccessProp = isTsMode
    ? "export let onSuccess: () => void = () => {}"
    : "export let onSuccess = () => {}";

  if (src.indexOf("<UpdateOneView") !== -1) {
    // Add formData + onSuccess props after copy (last generated prop)
    patched = patched.replace(
      /(export let copy(?::\s*\S+)? = null)\n/,
      "$1\n  " + formDataProp + "\n  " + onSuccessProp + "\n"
    );
    // Pass {formData} and wire on:update to onSuccess
    patched = patched.replace(
      /(\{copy\} *\n)(\s*\/>)/,
      "$1    {formData}\n    on:update={onSuccess}\n$2"
    );
  } else if (src.indexOf("<CreateView") !== -1) {
    // Add formData prop after filter (last generated prop)
    patched = patched.replace(
      /(export let filter(?::\s*\S+)? = \{\})\n/,
      "$1\n  " + formDataProp + "\n"
    );
    patched = patched.replace(
      /(on:success=\{onSuccess\} *\n)(\s*\/>)/,
      "$1    {formData}\n$2"
    );
  }

  if (patched !== src) {
    fs.writeFileSync(file, patched);
    console.log("patched: " + file);
    count++;
  }
});

console.log("done, patched " + count + " file(s)");
NODE

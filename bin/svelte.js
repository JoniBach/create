#!/usr/bin/env node

const { exec } = require('child_process');

await exec('sh ./bin/svelte/generate-app.sh', (err, stdout, stderr) => {
  if (err) {
    console.error(err);
    return;
  }
  console.log(stdout);
});
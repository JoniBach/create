const { exec } = require('child_process');
const path = require('path');

const abc = path.join(__dirname, '/bin/svelte/generate-svelte.sh');
const dir = path.dirname(abc);

const init = (projectName) => {
    exec(`sh ${dir}/generate-svelte.sh`, (err, stdout, stderr) => {
        if (err) {
          console.error(err);
          return;
        }
        console.log(stdout);
      });
}

module.exports = { init };
const { exec } = require('child_process');

const init = () => {
    exec('sh ./bin/svelte/generate-app.sh', (err, stdout, stderr) => {
        if (err) {
          console.error(err);
          return;
        }
        console.log(stdout);
      });
}

module.exports = { init };

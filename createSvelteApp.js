const { execSync } = require('child_process');
const path = require('path');

const runScript = async (script_name) => {  

  const abc = path.join(__dirname, `bin/svelte/${script_name}.sh`);
  const dir = path.dirname(abc);
  execSync(`sh ${dir}/${script_name}.sh`, (err, stdout, stderr) => {
    if (err) {
      console.error(err);
      return;
    }
    console.log(stdout);
  });

}



const init = async() => {
await runScript('generate-svelte')
await runScript('generate-routes')
await runScript('generate-user-page')
await runScript('generate-firebase')
// await runScript('generate-complete')
}


module.exports = { init };
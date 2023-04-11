const currentNodeVersion = process.versions.node;
const semver = currentNodeVersion.split('.');
const major = semver[0];

const { init } = require('./createSvelteApp');

init();
#!/bin/bash

# Create a svelte project
npm init @svelte-add/kit@latest . -- --with typescript+eslint+prettier
npm install
# npm run dev -- --open
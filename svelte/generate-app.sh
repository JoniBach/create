#!/bin/bash

# Create a svelte project
sh generate-svelte.sh

# Create the firebase project
sh generate-firebase.sh

# Create the routes
sh generate-routes.sh

# Create the user login flow
sh generate-user-page.sh

# Complete the project
sh generate-complete.sh
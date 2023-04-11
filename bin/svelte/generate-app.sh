#!/bin/bash

# Create a svelte project
echo "Creating a svelte project"
sh ./bin/svelte/generate-svelte.sh

# Create the firebase project
echo "Creating the firebase project"
sh ./bin/svelte/generate-firebase.sh

# Create the routes
echo "Creating the routes"
sh ./bin/svelte/generate-routes.sh

# Create the user login flow
echo "Creating the user login flow"
sh ./bin/svelte/generate-user-page.sh

# Complete the project
echo "Completing the project"
sh ./bin/svelte/generate-complete.sh
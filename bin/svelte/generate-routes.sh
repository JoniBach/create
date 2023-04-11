#!/bin/bash

# Prompt the user to enter the routes and store them in the ROUTES array
echo "Enter the routes (starting with a slash) separated by spaces:"
DIM='\033[2m'
echo "${DIM}eg /articles /articles/[slug] /admin/articles"
RESET='\033[0m'
echo "${RESET}"
read -a ROUTES

# Print the routes to verify that they were stored correctly
echo "ROUTES:"
printf '%s\n' "${ROUTES[@]}"

# ROUTES=("/admin/articles" "/admin/users" "/author" "/author/articles" "/author/write" "/author/edit/[slug]" "/author/review/[slug]" "/articles" "/articles/[slug]" )

for route in "${ROUTES[@]}"
do
  # Create route directory with page file inside
  route_dir=src/routes${route/\//\/}
  mkdir -p "$route_dir"

       # +page.ts
    echo "
import { error } from '@sveltejs/kit';

/** @type {import('./').PageLoad} */
export function load({ params }) {
  if (params.slug === 'hello-world') {
    return {
      title: 'Hello world!',
      content: 'Welcome to our blog. Lorem ipsum dolor sit amet...'
    };
  }
  if (params.slug === 'goodbye-world') {
    return {
      title: 'Goodbye world!',
      content: 'This is my last blog. Lorem ipsum dolor sit amet...'
    };
  }

  throw error(404, 'Not found');
}
    " > "$route_dir/+page.ts"

  # +page.server.ts
    echo "
/** @type {import('./\$types').Actions} */
export const actions = {
  default: async (event) => {
    // TODO log the user in
  }
};
    " > "$route_dir/+page.server.ts"

  if [[ "$route" == *"[slug]"* ]]; then
# +page.svelte
    echo "
<script>
	/** @type {import('./\$types').PageData} */
	export let data;

	console.log(data); // [{ slug: 'profile', title: 'Profile' }, ...]
</script>

<div>
	<h1>{data.title}</h1>
	<p>{data.content}</p>
</div>
    " > "$route_dir/+page.svelte"
# +layout.svelte
    echo "
<script>
	/** @type {import('./\$types').LayoutData} */
	export let data;
</script>

<div class="submenu">
	{#each data.sections as section}
		<a href="{section.slug}">{section.title}</a>
	{/each}
</div>

<slot />
    " > "$route_dir/+layout.svelte"

    # +layout.ts
  echo "
/** @type {import('./\$types').LayoutLoad} */
export function load() {
    return {
        sections: [
            { slug: 'hello-world', title: 'Hello World', content: 'This is my first post' },
            { slug: 'goodbye-world', title: 'Goodbye World', content: 'This is my last post' },
        ]
    };
}
  " > "$route_dir/+layout.ts"

 

  else
    echo "<script context=\"module\">
  export async function preload(page) {
    // Add your preload code here
  }
</script>

<h1>${route}</h1>" > "$route_dir/+page.svelte"
  fi
done

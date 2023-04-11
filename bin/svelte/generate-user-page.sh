#!/bin/bash

# Create a components directory
mkdir -p "./src/components/"

# Create a user directory
mkdir -p "./src/routes/user/"

# Create a stores directory
mkdir -p "./src/stores/"

# create a signin directory
mkdir -p "./src/routes/user/signin/"

# create a signup directory
mkdir -p "./src/routes/user/signup/"

# Create a user layout
echo "
<script>
	import { onMount } from 'svelte';
	import { authHandlers, authStore } from '../../stores/authStore';

	let email;
	authStore.subscribe((curr) => {
		console.log('CURR', curr);
		email = curr?.currentUser?.email;
	});

	onMount(() => {
		const unsubscribe = authHandlers.onAuthStateChanged();
		return unsubscribe;
	});
</script>

<main>
	{#if \$authStore.currentUser}
		{email} <button on:click={() => authHandlers.signout()}>Logout</button>
	{:else}
		<div>Loading....</div>
	{/if}
	<slot />
</main>
    " > "./src/routes/user/+layout.svelte"


# Create an auth form component
echo "
<script lang='ts'>
	import { authHandlers } from '../stores/authStore';
	export let type: string;

	const handleSubmit = async (event: any) => {
		const data = new FormData(event.target);
		const email = data.get('email');
		const password = data.get('email');

		if (type === 'signin') {
			await authHandlers.signin(email, password);
		} else if (type === 'signup') {
			await authHandlers.signup(email, password);
		}
	};
</script>

<form method='POST' on:submit|preventDefault={handleSubmit}>
	<label>
		Email
		<input name='email' type='email' />
	</label>
	<label>
		Password
		<input name='password' type='password' />
	</label>
	<button>{type}</button>
</form>
    " > "./src/components/Auth.svelte"


# Create an auth store
echo "
import { createUserWithEmailAndPassword, sendPasswordResetEmail, signInWithEmailAndPassword, signOut, updateEmail, updatePassword } from 'firebase/auth';
import { writable } from 'svelte/store';
import { auth } from '../lib/firebase/firebase.client';

export const authStore = writable({
    isLoading: true,
    currentUser: null
})

export const authHandlers = {
    getUser: async () => auth.currentUser,
    signin: async (email, password) => {
        const cred = await signInWithEmailAndPassword(auth, email, password)
        return cred.user.toJSON()
    },
    signup: async (email, password) => {
        await createUserWithEmailAndPassword(auth, email, password)
    },
    signout: async () => {
        await signOut(auth)
    },
    resetPassword: async (email) => {
        console.log('WE ARE HERE', email)
        if (!email) {
            console.log('inHERE')
            return
        }
        await sendPasswordResetEmail(auth, email)
    },
    updateEmail: async (email) => {
        authStore.update(curr => {
            return {
                ...curr, currentUser: {
                    ...curr.currentUser, email: email
                }
            }
        })
        await updateEmail(auth.currentUser, email)
    },
    updatePassword: async (password) => {
        await updatePassword(auth.currentUser, password)
    },
    onAuthStateChanged: () => {
        auth.onAuthStateChanged((user) => {
			authStore.update((curr) => {
				return { ...curr, isLoading: false, currentUser: user };
			});
			authHandlers.getUser().then((user) => console.log(user));
		});
    }
}
    " > "./src/stores/authStore.ts"

# Create signin page
echo "
<script>
	import Auth from '../../../components/Auth.svelte';
</script>

<Auth type='signin' />
    " > "./src/routes/user/signin/+page.svelte"

# Create signup page
echo "
<script>
	import Auth from '../../../components/Auth.svelte';
</script>

<Auth type='signup' />
    " > "./src/routes/user/signup/+page.svelte"

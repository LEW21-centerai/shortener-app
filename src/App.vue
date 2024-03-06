<script setup lang="ts">
import { ref } from 'vue'

interface Config {
	'api_server': string
}

const config = (async () => {
	if (process.env.NODE_ENV === 'development') {
		return {
			'api_server': 'http://localhost:8000/'
		}
	}

	const res = await fetch('./config.json')
	if (!res.ok) {
		throw Error()
	}
	return await res.json() as Config
})()

const target = ref("")
const link = ref("")
const error = ref("")
const copied = ref(false)

interface LinkData {
	link: string
	target: string
}

interface ErrorData {
	target: string[]
}

async function shorten(e: Event) {
	const res = await fetch((await config).api_server + 'links/', {
		method: 'POST',
		headers: {
			'content-type': 'application/json'
		},
		body: JSON.stringify({
			target: target.value
		})
	})
	if (!res.ok) {
		if (res.status == 400) {
			const data = await res.json() as ErrorData
			error.value = data.target.join(" ")
		} else {
			error.value = res.statusText
		}
		setTimeout(() => error.value = '', 1000)
		return
	}
	const data = await res.json() as LinkData
	link.value = data.link
}

async function copy(e: Event) {
	await navigator.clipboard.writeText(link.value)
	copied.value = true
	setTimeout(() => copied.value = false, 1000)
}
</script>

<template>
	<img src="./logo.svg">
	<form class="shorten" @submit.stop.prevent="shorten">
		<h1>Short link</h1>
		<label>
			<span>Link to shortcut</span>
			<input v-model="target" type="url" autofocus required>
		</label>
		<button type="submit">{{error || "Shorten it"}}</button>
		<button class="result" @click="copy" title="Copy" v-if="link">{{copied ? "Copied to clipboard." : link}}</button>
	</form>
</template>

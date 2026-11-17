[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/local-deep-researc-1?utm_medium=integration&utm_source=button&utm_campaign=local-deep-research)

# Deploy and Host Local Deep Research on Railway

Local Deep Research is an open-source AI research assistant. You ask a question, and it plans searches, reads the sources it finds on the web, arXiv, PubMed, Wikipedia and your own documents, and writes a cited report. It works with cloud LLMs (OpenAI, Anthropic, Google, OpenRouter) and with self-hosted models served by Ollama or llama.cpp.

## About Hosting Local Deep Research

This template deploys Local Deep Research 2.0.1 with a private SearXNG metasearch instance, so web search works without any search API key. The web app listens on Railway's `PORT` behind HTTPS and keeps everything (the user list, each user's SQLCipher-encrypted database, research reports, caches and logs) on a volume at `/data`. On first boot it creates one account from `ADMIN_USERNAME` and a generated `ADMIN_PASSWORD`, and open sign-up stays off. SearXNG has no public domain and is reached only over Railway's private network. After logging in, choose your LLM provider and paste its API key under Settings.

## Common Use Cases

* Literature reviews and background research with cited sources from arXiv, PubMed and the web
* A private research assistant that searches your own uploaded documents alongside the web
* Scheduled news briefings and follow-up research on topics you track

## Dependencies for Local Deep Research Hosting

* An LLM: an API key for a cloud provider (OpenAI, Anthropic, Google, OpenRouter and others) or the URL of your own Ollama or OpenAI-compatible server
* SearXNG (included in this template, private network only)

### Deployment Dependencies

* Local Deep Research: https://github.com/LearningCircuit/local-deep-research
* Docker image: https://hub.docker.com/r/localdeepresearch/local-deep-research
* SearXNG: https://docs.searxng.org/
* Template source: https://github.com/aalfath/local-deep-research-railway-template

### Implementation Details

* Log in with `ADMIN_USERNAME` (default `admin`) and the `ADMIN_PASSWORD` shown in the service's Variables tab. The password is also the key of your encrypted database and can't be recovered, so keep it safe. Change it in the app, not in the variable: the variables are used only once, to create the first account.
* No LLM is preset, because a variable would lock the setting in the UI. Open Settings, pick a provider (for example OpenAI or OpenRouter) and paste its API key, or point it at your own Ollama server.
* To let other people create accounts, set `LDR_APP_ALLOW_REGISTRATIONS=true` on the app service.
* The SearXNG search URL is fixed to the private service (`LDR_SEARCH_ENGINE_WEB_SEARXNG_DEFAULT_PARAMS_INSTANCE_URL`). Other search engines (arXiv, PubMed, Wikipedia, Brave, Tavily and more) can be turned on in Settings.
* Ollama isn't included: CPU-only Railway services are too slow for local models. Use a cloud provider or a GPU host of your own.

## Why Deploy Local Deep Research on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Local Deep Research on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->

---

## About this repository

This repository is the source of the Railway template. Each service builds from its own folder:

| Folder | Service | Image |
| --- | --- | --- |
| `ldr/` | Local Deep Research (public, volume at `/data`, health check `/api/v1/health`) | `localdeepresearch/local-deep-research:2.0.1` pinned by digest |
| `searxng/` | SearXNG (private network only, port 8080) | `ghcr.io/searxng/searxng:2026.11.15-2d500cb6b` pinned by digest |

Variables:

| Service | Variable | Default | Purpose |
| --- | --- | --- | --- |
| ldr | `ADMIN_USERNAME` | `admin` | First account, created once on first boot |
| ldr | `ADMIN_PASSWORD` | generated | Password of the first account (8+ characters, a lowercase letter and a digit) |
| ldr | `LDR_SEARCH_ENGINE_WEB_SEARXNG_DEFAULT_PARAMS_INSTANCE_URL` | `http://${{searxng.RAILWAY_PRIVATE_DOMAIN}}:8080` | Private SearXNG URL |
| ldr | `PORT` | `5000` | Port the app listens on |
| searxng | `SEARXNG_SECRET` | generated | SearXNG secret key |
| searxng | `PORT` | `8080` | Port SearXNG listens on |

The start script also sets `TRUST_PROXY_HEADERS=true` (TLS ends at Railway's proxy) and `LDR_APP_ALLOW_REGISTRATIONS=false`. Any of them can be overridden with a service variable.

### Updates

When this repository's `main` branch changes (for example a new Local Deep Research version), Railway shows an "update available" notice in projects deployed from the template. You choose when to apply it. Read `CHANGELOG.md` first. Your `/data` volume is kept across updates.

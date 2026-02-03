# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a fork of Open WebUI (v0.7.2), a self-hosted AI platform for running LLMs. It's deployed at chat.utilities.dearemployee.de. Documentation: https://docs.openwebui.com/

## Tech Stack

- **Frontend:** SvelteKit 2.5 + Svelte 5, Tailwind CSS 4, TypeScript, TipTap editor
- **Backend:** FastAPI + Python 3.11, SQLAlchemy 2.0, Alembic migrations
- **Database:** SQLite (default) or PostgreSQL
- **Real-time:** Socket.IO for WebSocket communication
- **Build:** Vite (frontend), Hatch/pip (backend)

## Common Commands

### Frontend Development
```bash
npm install                    # Install dependencies
npm run dev                    # Dev server on localhost:5173
npm run build                  # Production build
npm run check                  # Svelte/TypeScript type checking
npm run lint                   # Run all linters (frontend + types + backend)
npm run lint:frontend          # ESLint only
npm run format                 # Prettier formatting
npm run test:frontend          # Vitest unit tests
npm run cy:open                # Cypress E2E tests
```

### Backend Development
```bash
cd backend
pip install -r requirements.txt           # Install dependencies
pip install -e ".[all]"                    # Install with all optional deps (for tests)
./dev.sh                                   # Dev server with reload on localhost:8080
python -m pytest open_webui/test/          # Run all tests
python -m pytest open_webui/test/apps/webui/routers/test_auths.py  # Single test file
python -m pytest -k "test_get_session"     # Run specific test by name
black .                                    # Format Python code
```

### Docker
```bash
make install         # docker-compose up -d
make startAndBuild   # docker-compose up -d --build
make stop            # docker-compose stop
make update          # Pull updates and rebuild
```

## Architecture

### Directory Structure
```
src/                          # Frontend (SvelteKit)
├── lib/
│   ├── apis/                # TypeScript API clients (one per resource)
│   ├── components/          # Svelte components
│   ├── stores/              # Svelte stores (state management)
│   └── i18n/                # Internationalization (23+ languages)
├── routes/                  # SvelteKit page routes
│   ├── (app)/               # Main app routes (grouped)
│   └── auth/                # Authentication routes

backend/open_webui/
├── main.py                  # FastAPI app entry point
├── config.py                # Configuration system
├── env.py                   # Environment variables
├── routers/                 # API endpoints (20+ files)
│   ├── chats.py             # /api/v1/chats
│   ├── users.py             # /api/v1/users
│   ├── auths.py             # /api/v1/auths
│   ├── files.py             # /api/v1/files
│   ├── retrieval.py         # /api/v1/retrieval (RAG)
│   ├── ollama.py            # /ollama (model management)
│   └── openai.py            # /openai (OpenAI API compatibility)
├── models/                  # SQLAlchemy ORM models (18 files)
├── internal/
│   ├── db.py                # Database setup
│   └── migrations/          # Alembic migrations
├── socket/                  # WebSocket/Socket.IO handlers
├── retrieval/               # RAG system (vector DBs, document loaders)
└── storage/                 # File storage backends (S3, Azure, GCS)
```

### Frontend-Backend Communication
1. **REST API:** TypeScript modules in `src/lib/apis/` call FastAPI endpoints at `/api/v1/`
2. **WebSocket:** Socket.IO for real-time chat, collaborative editing, model status
3. **SSE:** Streaming responses for LLM chat completions

### Database
- Models in `backend/open_webui/models/` (Users, Chats, Messages, Files, etc.)
- Migrations in `backend/open_webui/internal/migrations/`
- Supports SQLite, PostgreSQL, MySQL

### RAG/Knowledge System
- Document upload → loader extracts text → embeddings created → stored in vector DB
- Query uses `#` command to inject matched content into LLM context
- Vector DBs: ChromaDB (default), Qdrant, Weaviate, Milvus, Pinecone, etc.

## Key Environment Variables

```bash
OLLAMA_BASE_URL              # Local LLM endpoint
OPENAI_API_BASE_URL          # OpenAI-compatible API
DATABASE_URL                 # DB connection string (PostgreSQL for production)
REDIS_URL                    # Redis for sessions/scaling
WEBUI_SECRET_KEY             # Session encryption
```

## Testing

Backend tests require Docker (PostgreSQL container):
```bash
pip install -e ".[all]"                              # Install test dependencies
python -m pytest backend/open_webui/test/            # Run all backend tests
```

Frontend tests:
```bash
npm run test:frontend                                # Vitest unit tests
npm run cy:open                                      # Cypress E2E (interactive)
```

## Code Style

- **Frontend:** Prettier (tabs, 100 char width) + ESLint
- **Backend:** Black formatter + Pylint
- Run `npm run format` and `npm run format:backend` before committing

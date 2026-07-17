---
description: Create comprehensive Python Flask + Vercel backend project plans for new greenfield API applications
---

# Python Flask + Vercel Backend Project Plan

You are tasked with creating detailed implementation plans for **new Python Flask backend projects deployed on Vercel**. This skill is optimized for greenfield API projects starting from a fresh Flask template or boilerplate.

## Key Assumptions

- **Fresh Start**: Working with a new Flask project (from Vercel template or `vc init flask`)
- **Modern Stack**: Python 3.11+, Flask 3+, Pydantic 2+, SQLAlchemy 2+
- **Deployment**: Optimized for Vercel's serverless platform and free tier maximization
- **Quality First**: Emphasis on type safety, validation, testing, and security

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a requirements file or brief was provided, read it FULLY
   - Begin the research process immediately
   
2. **If no parameters provided**, respond with:
```
I'll help you plan your Python Flask + Vercel backend API. Let me understand what you're building.

Please provide:
1. **Project Overview**: What type of API? (e.g., REST API, webhook handler, BFF, microservice)
2. **Key Endpoints**: What are the main resources and operations?
3. **Data Requirements**: What data entities and relationships do you need?
4. **Authentication**: What auth approach? (JWT, API keys, OAuth, none)
5. **External Integrations**: Any third-party APIs or services?

I'll analyze your project needs and create a comprehensive plan optimized for Vercel deployment.
```

Then wait for the user's input.

## Process Steps

### Step 1: Project & Context Analysis

1. **Analyze the existing project** (if any):
   - Read `pyproject.toml` or `requirements.txt` for dependencies
   - Check for existing Flask app structure (`app.py`, `app/`)
   - Review `vercel.json` if present
   - Identify any pre-configured features (database, auth, etc.)
   - Check the entrypoint configuration

2. **Spawn initial research tasks** (in parallel):
   - Use **codebase-locator** to map the project structure
   - Use **codebase-analyzer** to understand existing patterns
   - Use **python-vercel-backend-architect** to validate architecture decisions

3. **Present project analysis**:
   ```
   I've analyzed your project. Here's what we're starting with:
   
   **Current Setup:**
   - Python version: [X]
   - Key dependencies: [list key packages]
   - Pre-configured features: [what's already set up]
   - Directory structure: [brief overview]
   - Vercel entrypoint: [entrypoint file]
   
   **Project Strengths:**
   - [What's good about this starting point]
   
   **Recommended Additions:**
   - [What we should add for your use case]
   ```

### Step 2: Architecture & Technology Decisions

Use the **python-vercel-backend-architect** agent to help make key decisions:

1. **Application Architecture**:
   - Application factory vs single file
   - Blueprint organization strategy
   - Service layer design
   - Configuration management approach

2. **Database Strategy**:
   - Database choice (Vercel Postgres, Supabase, PlanetScale, Turso, SQLite)
   - ORM choice (SQLAlchemy, SQLModel)
   - Migration strategy (Flask-Migrate/Alembic)
   - Connection pooling for serverless

3. **API Design**:
   - REST API versioning strategy (`/api/v1/`)
   - Input validation approach (Pydantic)
   - Response serialization patterns
   - Error response format
   - Pagination strategy (offset vs cursor)

4. **Authentication & Authorization**:
   - JWT tokens vs API keys vs OAuth
   - Token refresh strategy
   - Role-based access control (RBAC)
   - Password hashing (bcrypt, argon2)

5. **Security**:
   - CORS configuration
   - Rate limiting (flask-limiter)
   - Input sanitization
   - SQL injection prevention
   - Secrets management

6. **Performance**:
   - Cold start optimization
   - Dependency minimization
   - Database connection pooling
   - Response caching strategy
   - Bundle size optimization (< 50MB target)

7. **Testing**:
   - pytest configuration
   - Test fixtures with app factory
   - API endpoint testing
   - Service layer testing
   - Coverage targets

### Step 3: Deep Requirements Interview

**CRITICAL:** Before writing any plan, conduct thorough interview using `AskQuestion` tool.

**Interview Categories for Backend API Projects:**

1. **API Design & Endpoints**
   - What are ALL the resources/entities?
   - What CRUD operations are needed per resource?
   - Are there any non-CRUD endpoints (search, aggregate, batch)?
   - API versioning needed?
   - WebSocket/real-time requirements?

2. **Data Model**
   - What are the main entities and their fields?
   - What relationships exist (one-to-many, many-to-many)?
   - Any complex queries or aggregations needed?
   - Soft delete vs hard delete?
   - Audit trail requirements?

3. **Authentication & Security**
   - Who are the API consumers (frontend app, mobile, other services)?
   - User registration and login flow?
   - Role-based permissions needed?
   - API rate limiting requirements?
   - CORS origins (which frontends)?

4. **External Integrations**
   - Payment processing (Stripe, etc.)?
   - Email service (Resend, SendGrid)?
   - File storage (S3, Vercel Blob)?
   - Third-party APIs to consume?
   - Webhook handling needed?

5. **Performance & Scaling**
   - Expected request volume?
   - Acceptable response times?
   - Caching requirements?
   - Background job needs (or keep everything synchronous)?
   - Data volume expectations?

6. **Deployment & Operations**
   - Environment variables needed?
   - Database hosting preference?
   - Monitoring and logging needs?
   - CI/CD pipeline requirements?
   - Budget constraints (stay on free tier)?

7. **Future Scalability**
   - Expected growth pattern?
   - Features planned for future phases?
   - Migration path if outgrowing Vercel serverless?
   - Microservice split planned?

**Interview Best Practices:**
- Use `AskQuestion` with 3-4 focused questions per round
- Provide options with clear tradeoffs
- For technical decisions, explain implications simply
- Continue until zero ambiguity remains
- Document all decisions with rationale

**Completion Criteria:**
- All entities and relationships defined
- All API endpoints mapped
- Authentication strategy clear
- Database choice finalized
- Performance targets set
- User explicitly approves moving to plan writing

### Step 4: Vercel Optimization Analysis

Before finalizing the plan, ensure these Vercel optimizations are included:

1. **Free Tier Maximization**:
   - Minimize function execution time
   - Use efficient database queries
   - Cache responses where possible
   - Keep bundle size small (< 50MB ideal)
   - Use Vercel CDN for static assets via `public/`

2. **Cold Start Optimization**:
   - Lazy imports for heavy modules
   - Minimal top-level initialization
   - Lightweight dependency selection
   - Avoid unnecessary large packages

3. **Serverless Considerations**:
   - Connection pooling for databases
   - Stateless request handling
   - Proper timeout configuration
   - No local file system for persistent storage
   - No background workers (everything request-driven)

4. **Deployment Configuration**:
   - Correct entrypoint (`app.py` exporting `app`)
   - `pyproject.toml` with proper scripts section
   - Environment variables strategy
   - `public/` directory for static assets

### Step 5: Plan Structure Development

Create a phased plan optimized for iterative development:

1. **Phase Structure for Backend API Projects**:
   ```
   Phase 1: Foundation & Project Setup
   - Flask app factory, configuration
   - Extensions (db, migrate, cors, limiter)
   - Error handling, health checks
   - Vercel entrypoint configuration
   
   Phase 2: Data Layer
   - Database setup and configuration
   - SQLAlchemy models
   - Pydantic schemas
   - Database migrations
   
   Phase 3: Core API Endpoints
   - Blueprint registration
   - CRUD routes for main entities
   - Input validation
   - Response serialization
   
   Phase 4: Authentication & Security
   - Auth implementation (JWT/API keys)
   - Auth decorators and middleware
   - CORS configuration
   - Rate limiting
   
   Phase 5: Testing, Polish & Deployment
   - Pytest configuration and fixtures
   - API endpoint tests
   - Service layer tests
   - Vercel deployment verification
   ```

2. **Get feedback on phasing** before writing details

### Step 6: Detailed Plan Writing

1. **Ensure directory exists**: Run `mkdir -p thoughts/shared/plans`
2. **Write the plan** to `thoughts/shared/plans/YYYY-MM-DD-flask-project-name.md`

**Use this template structure:**

````markdown
# [Project Name] Python Flask + Vercel Implementation Plan

## Project Overview

**Type**: [e.g., REST API, Webhook Handler, BFF, Microservice]
**API Consumers**: [who calls this API - frontend, mobile, services]
**Key Goals**: [main objectives]

## Technology Stack

### Core
- **Framework**: Flask 3+ (Application Factory pattern)
- **Language**: Python 3.11+ with full type hints
- **Validation**: Pydantic 2+
- **ORM**: SQLAlchemy 2+ with Flask-SQLAlchemy
- **Deployment**: Vercel (Serverless)

### Additional Tools
- **Database**: [Vercel Postgres, Supabase, etc.]
- **Migrations**: Flask-Migrate (Alembic)
- **Auth**: [PyJWT, etc.]
- **CORS**: Flask-CORS
- **Rate Limiting**: Flask-Limiter
- **Testing**: pytest + pytest-cov
- **Linting**: Ruff + mypy

## Architecture Decisions

### Application Architecture
- **Pattern**: Application Factory with Blueprints
- **Service Layer**: Business logic separated from routes
- **Validation**: Pydantic schemas for all request/response
- **Rationale**: [why these choices]

### Database Strategy
- **Database**: [choice with rationale]
- **Connection Pooling**: [configuration for serverless]
- **Migrations**: [approach]

### API Design
- **Versioning**: /api/v1/ prefix
- **Pagination**: [offset or cursor-based]
- **Error Format**: {"error": "message", "details": {...}}

### Performance Targets
- **Cold Start**: < 2s
- **API Response (simple CRUD)**: < 200ms
- **API Response (complex query)**: < 500ms
- **Bundle Size**: < 50MB

## Data Model

### Entity Relationship Diagram
```
[Entity relationships described]
```

### Entities
| Entity | Fields | Relationships |
|--------|--------|---------------|
| User | id, email, name, password_hash, created_at | has_many: items |
| Item | id, user_id, title, description, created_at | belongs_to: user |

## API Endpoints

### Authentication
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | /api/v1/auth/register | Register new user | No |
| POST | /api/v1/auth/login | Login, get JWT | No |
| POST | /api/v1/auth/refresh | Refresh token | Yes |

### Users
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /api/v1/users | List users (paginated) | Yes |
| GET | /api/v1/users/:id | Get user by ID | Yes |
| PATCH | /api/v1/users/:id | Update user | Yes (owner) |
| DELETE | /api/v1/users/:id | Delete user | Yes (owner) |

### [Domain Resources]
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /api/v1/items | List items | Yes |
| POST | /api/v1/items | Create item | Yes |
| GET | /api/v1/items/:id | Get item | Yes |
| PATCH | /api/v1/items/:id | Update item | Yes (owner) |
| DELETE | /api/v1/items/:id | Delete item | Yes (owner) |

### Utility
| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| GET | /health | Health check | No |
| GET | /health/ready | Readiness check | No |

## What We're NOT Doing

[Explicitly list out-of-scope items]

## Phase 1: Foundation & Project Setup

### Overview
Set up Flask application factory, extensions, configuration, error handling, and Vercel entrypoint.

### Changes Required:

#### 1. Project Configuration
**File**: `pyproject.toml`
**Changes**:
```toml
[project]
name = "project-name"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "flask>=3.0",
    "flask-sqlalchemy>=3.1",
    "flask-migrate>=4.0",
    "flask-cors>=4.0",
    "flask-limiter>=3.5",
    "pydantic[email]>=2.5",
    "sqlalchemy>=2.0",
    "psycopg2-binary>=2.9",
    "pyjwt>=2.8",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-cov>=4.1",
    "ruff>=0.3",
    "mypy>=1.8",
]

[project.scripts]
app = "app:app"

[tool.ruff]
target-version = "py311"
line-length = 100
```

#### 2. Application Factory
**File**: `app/__init__.py`
**Changes**: [Create app factory with extension init and blueprint registration]

#### 3. Configuration
**File**: `app/config.py`
**Changes**: [Dev, Prod, Test configurations with env vars]

#### 4. Extensions
**File**: `app/extensions.py`
**Changes**: [Initialize db, migrate, cors, limiter]

#### 5. Error Handlers
**File**: `app/errors.py`
**Changes**: [APIError class, global error handlers]

#### 6. Health Check
**File**: `app/api/health.py`
**Changes**: [/health and /health/ready endpoints]

#### 7. Vercel Entrypoint
**File**: `app.py`
**Changes**: [Import create_app and expose app instance]

### Success Criteria:

#### Automated Verification:
- [ ] `ruff check .` passes
- [ ] `mypy app/` passes
- [ ] `pytest` passes
- [ ] App starts without errors: `flask run`
- [ ] Health check returns 200: `curl /health`

#### Manual Verification:
- [ ] Application factory creates app correctly
- [ ] Configuration loads from environment
- [ ] Error handlers return JSON responses
- [ ] CORS headers present in responses

---

## Phase 2: Data Layer

### Overview
Set up database models, Pydantic schemas, and migrations.

[Similar detailed structure with models, schemas, migrations...]

---

## Phase 3: Core API Endpoints

### Overview
Implement CRUD API endpoints with validation and serialization.

[Detailed blueprint setup, routes, services...]

---

## Phase 4: Authentication & Security

### Overview
Implement authentication, authorization, and security measures.

[JWT implementation, auth decorators, CORS, rate limiting...]

---

## Phase 5: Testing, Polish & Deployment

### Overview
Add comprehensive tests, finalize configuration, deploy to Vercel.

### Testing Setup:

#### 1. Pytest Configuration
**File**: `tests/conftest.py`
**Changes**: [App fixture, client fixture, db fixture, auth fixtures]

#### 2. API Tests
**Files**: `tests/test_*.py`
**Changes**: [Tests for all endpoints]

#### 3. Service Tests
**Files**: `tests/test_services/test_*.py`
**Changes**: [Tests for business logic]

### Deployment:

#### 1. Vercel Configuration
**File**: `vercel.json` (if needed)
**Changes**: [Any custom configuration]

#### 2. Environment Variables
**Vercel Dashboard**:
```
DATABASE_URL=postgres://...
SECRET_KEY=...
FLASK_ENV=production
```

#### 3. Deployment Verification
**After deployment, verify**:
- [ ] Health check: `curl https://your-app.vercel.app/health`
- [ ] API endpoints accessible
- [ ] Auth flow works
- [ ] Database connected
- [ ] CORS configured correctly
- [ ] Rate limiting active

### Success Criteria:

#### Automated Verification:
- [ ] `ruff check .` passes
- [ ] `mypy app/` passes (or type check)
- [ ] `pytest --cov` passes with >60% coverage
- [ ] Build deploys to Vercel successfully

#### Manual Verification:
- [ ] All API endpoints return correct responses
- [ ] Auth flow works end-to-end
- [ ] Error responses are consistent JSON
- [ ] Rate limiting works
- [ ] CORS allows frontend origin

---

## Testing Strategy

### Unit Tests
- [ ] Service layer function tests
- [ ] Pydantic schema validation tests
- [ ] Utility function tests

### Integration Tests
- [ ] API endpoint tests (all CRUD operations)
- [ ] Auth flow tests (register, login, protected routes)
- [ ] Error handling tests (validation, not found, unauthorized)

### Manual Testing Checklist
1. **API Testing** (via curl/Postman/httpie):
   - [ ] All CRUD endpoints work
   - [ ] Auth flow works
   - [ ] Validation errors return 422
   - [ ] Not found returns 404
   - [ ] Unauthorized returns 401

2. **Integration Testing**:
   - [ ] Frontend can call API (CORS)
   - [ ] Database operations persist
   - [ ] Token refresh works

---

## Performance Budget

| Metric | Target | Critical |
|--------|--------|----------|
| Cold Start | < 2s | < 5s |
| Simple CRUD Response | < 200ms | < 500ms |
| Complex Query Response | < 500ms | < 1s |
| Bundle Size | < 50MB | < 100MB |
| Test Coverage | > 60% | > 40% |

---

## Vercel Free Tier Optimization

### Strategy to Stay Free:
1. **Minimize Execution Time**:
   - Efficient database queries
   - Proper indexing
   - Connection pooling
   - Avoid unnecessary computation

2. **Optimize Bundle Size**:
   - Minimal dependencies
   - Use binary packages where available
   - No heavy ML/data science libs unless needed

3. **Cache Where Possible**:
   - Cache-Control headers on read endpoints
   - In-memory caching for hot data
   - Database query result caching

4. **Monitor Usage**:
   - Check Vercel dashboard regularly
   - Set up usage alerts
   - Optimize if approaching limits

---

## Security Checklist

- [ ] Passwords hashed with bcrypt/argon2
- [ ] JWT tokens properly signed and expired
- [ ] CORS restricted to known origins
- [ ] Rate limiting on auth endpoints (stricter)
- [ ] Rate limiting on all endpoints (general)
- [ ] Input validated with Pydantic (no raw user input)
- [ ] SQL injection prevented (ORM, no raw queries with user input)
- [ ] Secrets in environment variables
- [ ] Error messages don't leak internals
- [ ] HTTPS enforced (Vercel handles)

---

## Post-Deployment Monitoring

### Tools Setup
- [ ] Health check monitoring (UptimeRobot, etc.)
- [ ] Error tracking (Sentry)
- [ ] Vercel Analytics dashboard
- [ ] Database monitoring

### Metrics to Track
- API response times
- Error rates (4xx, 5xx)
- Database query performance
- Vercel function execution times
- Cold start frequency

---

## References

- Flask Documentation: https://flask.palletsprojects.com/
- Vercel Flask Docs: https://vercel.com/docs/frameworks/backend/flask
- Pydantic Documentation: https://docs.pydantic.dev/
- SQLAlchemy Documentation: https://docs.sqlalchemy.org/
- Original requirements: `[path to requirements doc]`
````

### Step 7: Review & Iteration

1. **Present the draft plan**:
   ```
   I've created your Python Flask + Vercel implementation plan at:
   `thoughts/shared/plans/YYYY-MM-DD-flask-project-name.md`
   
   The plan includes:
   - Complete technology stack with rationale
   - 5 phases from foundation to deployment
   - Data model and API endpoint definitions
   - Vercel optimization strategies
   - Performance targets and budgets
   - Security and testing checklists
   
   Please review and let me know:
   - Are the technology choices appropriate?
   - Is the API design complete?
   - Are the data models correct?
   - Performance targets realistic?
   ```

2. **Iterate based on feedback** until satisfied

## Important Guidelines

1. **Python 3.11+ First**:
   - Full type hints everywhere
   - Modern syntax (match statements, union types with `|`)
   - f-strings for formatting
   - `from __future__ import annotations` for forward refs

2. **Application Factory**:
   - Never use global app object
   - Always `create_app()` function
   - Extensions initialized in factory
   - Blueprints registered in factory

3. **Pydantic for Everything**:
   - All request bodies validated
   - All responses serialized
   - Configuration management
   - Type-safe data handling

4. **Service Layer**:
   - Routes are thin (validate, call service, respond)
   - Business logic in service classes/functions
   - Services are independently testable
   - No Flask-specific code in services (when possible)

5. **Vercel Optimized**:
   - Bundle size < 50MB (ideal)
   - Minimal dependencies
   - Connection pooling configured
   - Correct entrypoint for Vercel

6. **Security First**:
   - Auth on all non-public endpoints
   - CORS configured properly
   - Rate limiting enabled
   - Input always validated
   - Secrets in env vars

7. **Testable**:
   - App factory enables testing
   - Fixtures for app, client, db
   - Service layer testable in isolation
   - >60% coverage target

## Quality Standards Checklist

Before finalizing any plan, ensure it includes:

### Architecture
- [ ] Application factory pattern defined
- [ ] Blueprint organization clear
- [ ] Service layer structure defined
- [ ] Configuration management documented

### Data Layer
- [ ] Database choice justified
- [ ] Models with proper types and relationships
- [ ] Pydantic schemas for all endpoints
- [ ] Migration strategy defined
- [ ] Connection pooling configured

### API Design
- [ ] All endpoints documented
- [ ] Request/response formats defined
- [ ] Error response format standardized
- [ ] Pagination approach defined
- [ ] API versioning strategy

### Security
- [ ] Authentication approach documented
- [ ] Authorization model defined
- [ ] CORS configuration specified
- [ ] Rate limiting planned
- [ ] Secrets management approach

### Performance
- [ ] Response time targets set
- [ ] Cold start optimization planned
- [ ] Bundle size target defined
- [ ] Caching strategy documented

### Deployment
- [ ] Vercel entrypoint configured
- [ ] Environment variables listed
- [ ] Health check endpoints defined
- [ ] Monitoring strategy planned

### Testing
- [ ] Pytest configuration defined
- [ ] Test fixtures documented
- [ ] Coverage targets set
- [ ] Test categories defined

## Common Python Flask + Vercel Patterns

### For REST APIs
- Application Factory + Blueprints
- Service layer pattern
- Pydantic validation
- JWT authentication
- SQLAlchemy with connection pooling

### For Webhook Handlers
- Single blueprint for webhooks
- Signature verification
- Idempotency handling
- Async processing (queue events)

### For Backend-for-Frontend (BFF)
- Aggregate multiple API calls
- Transform data for frontend
- Handle auth token management
- Cache frequently requested data

### For Microservices
- Focused single-domain API
- Health check endpoints
- Service discovery patterns
- Inter-service communication

## Sub-task Spawning

When spawning research sub-tasks for Flask projects:

1. **Project Analysis**:
   ```
   Analyze the Flask project structure and identify:
   - Existing app setup (factory, single file)
   - Dependencies installed
   - Database configuration
   - Current blueprint organization
   ```

2. **Architecture Consultation**:
   ```
   Use python-vercel-backend-architect agent to validate:
   - Database strategy for [specific use case]
   - API design for [features]
   - Deployment optimizations for [requirements]
   ```

3. **Pattern Research**:
   ```
   Find Flask patterns for:
   - [specific feature]
   - Looking for factory pattern examples
   - Service layer implementations
   ```

## Success Indicators

A successful Python Flask + Vercel plan will:

1. **Be Implementable**: Clear, actionable steps with no ambiguity
2. **Be Optimized**: Minimal cold starts and efficient execution
3. **Be Secure**: Auth, validation, and error handling from day one
4. **Be Testable**: Pytest-ready architecture with fixtures
5. **Be Maintainable**: Well-structured, typed, documented
6. **Be Cost-Effective**: Optimized for Vercel free tier
7. **Be Scalable**: Clean architecture that can grow

Remember: This is a plan for a NEW backend project. Focus on best practices from the start, not migration concerns. Build it right the first time.

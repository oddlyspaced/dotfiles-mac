---
description: Implement Python Flask + Vercel backend project plans with architecture validation and quality checks
---

# Implement Python Flask + Vercel Backend Project Plan

You are tasked with implementing Python Flask + Vercel backend project plans created by `/plan_python_vercel_backend_architect`. These plans are optimized for greenfield Flask 3+ API applications with specific architecture, performance, and security requirements.

## Key Differences from Regular Implementation

This skill is specialized for Python Flask + Vercel projects and includes:
- **Flask-specific verification** (ruff, mypy, pytest)
- **Architecture validation** using `python-vercel-backend-architect` agent
- **Performance checks** (cold start, response times, bundle size)
- **Security verification** (auth, CORS, rate limiting, input validation)
- **Vercel optimization validation** (entrypoint, bundling, serverless config)
- **Standards enforcement** using `python-vercel-backend-standards.mdc` rules

## Execution Modes

You have two execution modes:

### Mode 1: Direct Implementation (Default)
For small plans (3 or fewer phases) or when user requests direct implementation.
- You implement each phase yourself
- Context accumulates in main conversation
- Use this for quick setups or focused implementations

### Mode 2: Agent Orchestration (Recommended for larger plans)
For plans with 4+ phases or complex implementations.
- You act as a thin orchestrator
- Agents execute each phase and create handoffs
- Compaction-resistant: handoffs persist even if context compacts
- Each phase goes through implement -> review -> fix cycle
- Use this for complete project implementations

**To use agent orchestration mode**, say: "I'll use agent orchestration for this plan" and follow the Agent Orchestration section below.

---

## Getting Started

When given a plan path:

1. **Verify it's a Flask + Vercel plan**:
   - Check filename contains "flask" or was created by `/plan_python_vercel_backend_architect`
   - If not, suggest using regular `/implement_plan` instead

2. **Read the plan completely**:
   - Check for existing checkmarks (- [x])
   - Note performance budgets and targets
   - Identify Vercel-specific optimizations
   - Note data model and API endpoint requirements

3. **Verify Python/Flask setup**:
   ```bash
   # Check for Python project files
   ls pyproject.toml requirements.txt 2>/dev/null
   
   # Check for Flask
   pip list 2>/dev/null | grep -i flask
   
   # Check project structure
   ls -la app/ 2>/dev/null || ls -la src/ 2>/dev/null
   
   # Check Vercel entrypoint
   ls app.py index.py server.py 2>/dev/null
   ```

4. **Read all referenced files**:
   - Read files FULLY (no limit/offset)
   - Understand current project state
   - Check for pre-existing features

5. **Auto-create ledger if missing** (see below)

6. **Create todo list** to track progress

7. **Validate with architect agent** (for each phase - see Validation section)

8. **Start implementing** when you understand what needs to be done

If no plan path provided, ask for one.

### Auto-Create Ledger If Missing

Before starting implementation, check for an existing ledger:

```bash
ls thoughts/ledgers/*.md 2>/dev/null
```

**If no ledger exists**, create one from the plan:

1. Extract session name from plan filename (e.g., `2026-02-14-flask-task-api.md` -> `flask-task-api`)
2. Extract phases from the plan
3. Create ledger with phases as checkboxes:

```bash
mkdir -p thoughts/ledgers
```

Use this template:

```markdown
# Session: <session-name-from-plan>
Type: Python Flask + Vercel Backend
Updated: <ISO timestamp>

## Goal
<Extract from plan's overview section>

## Technology Stack
<Extract from plan's technology stack section>

## Performance Targets
- Cold Start: <from plan>
- Simple CRUD Response: <from plan>
- Bundle Size: <from plan>
- Test Coverage: <from plan>

## Architecture Decisions
<Extract key architecture decisions from plan>

## Data Model
<Extract entity summary from plan>

## API Endpoints
<Extract endpoint summary from plan>

## State
- Done:
  - (none yet)
- Now: [->] Phase 1: <first phase from plan>
- Next: Phase 2: <second phase from plan>
- Remaining:
  - [ ] Phase 3: <third phase>
  - [ ] Phase 4: <fourth phase>
  - [ ] Phase 5: <fifth phase>

## Open Questions
<Extract any open questions from plan, or leave empty>

## Working Set
- Branch: <current branch>
- Plan: thoughts/shared/plans/<plan-file>.md
- Vercel: <vercel project name if known>
```

**Announce ledger creation:**
```
Created Python Flask + Vercel continuity ledger: thoughts/ledgers/<name>.md
This tracks architecture decisions, performance targets, and progress.
```

**If ledger exists**, read it and verify it matches the plan you're implementing.

## Implementation Philosophy for Python Flask + Vercel

Python Flask + Vercel projects have specific requirements:

### Follow the Architecture
- **Application Factory** - Always `create_app()`, never global app
- **Blueprints** - Follow the domain organization from plan
- **Service Layer** - Business logic separate from routes
- **Pydantic Validation** - All request/response schemas
- **Performance Budget** - Stay within cold start and bundle targets

### Verify as You Go
- **After each file** - Ensure ruff/mypy passes
- **After each route** - Check it follows REST conventions
- **After each model** - Verify types and relationships
- **After each phase** - Run full verification suite

### Quality Standards
Every implementation must meet:
- Type hints on all functions and variables
- Pydantic schemas for all request/response bodies
- Application factory pattern (not global app)
- Service layer for business logic
- Proper error handling with JSON responses
- Connection pooling configured for serverless
- Health check endpoints present

### When Reality Differs from Plan
If you encounter mismatches:
```
Issue in Phase [N]:
Expected (from plan): [what plan says]
Found (in codebase): [actual situation]
Why this matters: [technical explanation]

Options:
1. Adapt the plan approach to work with current setup
2. Modify current setup to match plan
3. Consult python-vercel-backend-architect agent for guidance

Recommendation: [your suggestion]
```

## Python Flask + Vercel Verification Suite

After implementing each phase, run these checks **in this order**:

### 1. Linting
```bash
ruff check .
```
**Must pass** - Fix all linting errors.

### 2. Type Checking
```bash
mypy app/
```
**Should pass** - Fix type errors where possible. Document known issues.

### 3. Tests
```bash
pytest -v
```
**Must pass** - All tests must pass.

### 4. Test Coverage
```bash
pytest --cov=app --cov-report=term-missing
```
**Check against targets** - Aim for >60% overall.

### 5. Application Startup Check
```bash
python -c "from app import create_app; app = create_app('testing'); print('App created successfully')"
```
**Must pass** - App must initialize without errors.

### 6. Health Check Verification
```bash
# Start dev server and test
flask run &
sleep 2
curl -s http://localhost:5000/health | python -m json.tool
curl -s http://localhost:5000/health/ready | python -m json.tool
```
**Must return** `{"status": "healthy"}` or similar.

### 7. Architecture Validation (Per Phase)

**Consult python-vercel-backend-architect agent:**

After completing a phase, validate the architecture:

```
Task(
  subagent_type="generalPurpose",
  prompt="""
  Act as the python-vercel-backend-architect agent.
  
  [Paste full content of .cursor/agents/python-vercel-backend-architect.md]
  
  ---
  
  ## Validation Request
  
  Phase completed: <phase name>
  
  Files modified:
  <list files changed>
  
  Please validate:
  1. Application structure (factory, blueprints, services)
  2. Data layer (models, schemas, connection pooling)
  3. API design (REST conventions, validation, error handling)
  4. Security (auth, CORS, rate limiting)
  5. Vercel optimization (bundle size, cold starts)
  
  Review the implementation and provide:
  - APPROVED or NEEDS REVISION for each area
  - Specific issues found
  - Recommendations for fixes
  - Performance impact
  
  Implementation details:
  <paste git diff or file contents>
  """
)
```

**Only proceed to next phase if validation passes.**

### 8. Manual Verification

After automated checks, perform manual testing:

**For all endpoints:**
- [ ] Send request with valid data -> correct response
- [ ] Send request with invalid data -> 422 with details
- [ ] Send request without auth -> 401 (if protected)
- [ ] Send request with expired token -> 401

**For CRUD operations:**
- [ ] CREATE returns 201 with created resource
- [ ] READ returns 200 with correct data
- [ ] UPDATE returns 200 with updated data
- [ ] DELETE returns 204 (no content)
- [ ] GET non-existent returns 404

**For auth flow:**
- [ ] Register creates user
- [ ] Login returns JWT token
- [ ] Token works on protected routes
- [ ] Expired token rejected

## Phase-by-Phase Implementation Guide

### Phase 1: Foundation & Project Setup

**Focus:** Flask app factory, extensions, configuration, error handling, Vercel entrypoint

**Implementation checklist:**
- [ ] Create `pyproject.toml` with dependencies
- [ ] Create `requirements.txt` (or generate from pyproject)
- [ ] Set up `app/__init__.py` with application factory
- [ ] Create `app/config.py` with Dev/Prod/Test configs
- [ ] Create `app/extensions.py` with db, migrate, cors, limiter
- [ ] Create `app/errors.py` with standardized error handlers
- [ ] Create `app/api/health.py` with health check endpoints
- [ ] Create `app.py` as Vercel entrypoint
- [ ] Create `.env.example` documenting all env vars

**Verification:**
```bash
ruff check .
python -c "from app import create_app; app = create_app('testing'); print('OK')"
```

**Check:**
- App factory creates app without errors
- Configuration loads properly
- Error handlers return JSON
- Health check endpoint works

**Architecture validation:**
- Verify factory pattern used correctly
- Verify extensions initialized in factory
- Verify error handlers registered globally

### Phase 2: Data Layer

**Focus:** Database models, Pydantic schemas, migrations

**Implementation checklist:**
- [ ] Create `app/models/base.py` with TimestampMixin
- [ ] Create domain models in `app/models/`
- [ ] Create Pydantic schemas in `app/schemas/`
- [ ] Initialize Flask-Migrate
- [ ] Create initial migration
- [ ] Run migration to create tables

**Verification:**
```bash
ruff check .
mypy app/models/ app/schemas/
flask db init  # if first time
flask db migrate -m "Initial migration"
flask db upgrade
```

**Check:**
- Models create tables correctly
- Pydantic schemas validate input properly
- Migrations generate and apply cleanly
- Relationships work as expected

**Architecture validation:**
- Verify models have proper types and indexes
- Verify schemas match API requirements from plan
- Verify connection pooling configured for serverless

### Phase 3: Core API Endpoints

**Focus:** Blueprints, CRUD routes, services, validation

**Implementation checklist:**
- [ ] Create Blueprint registration in `app/api/v1/__init__.py`
- [ ] Create service classes in `app/services/`
- [ ] Create route handlers in `app/api/v1/`
- [ ] Wire Pydantic validation into routes
- [ ] Add pagination to list endpoints
- [ ] Register blueprints in app factory

**Key patterns to follow:**
```python
# Route handler (thin)
@api_v1_bp.route("/items", methods=["POST"])
@require_auth
def create_item():
    try:
        data = ItemCreate.model_validate(request.get_json())
    except ValidationError as e:
        return jsonify({"error": "Validation failed", "details": e.errors()}), 422
    item = ItemService.create(data, user_id=g.current_user_id)
    return jsonify(ItemResponse.model_validate(item).model_dump()), 201

# Service (business logic)
class ItemService:
    @staticmethod
    def create(data: ItemCreate, user_id: int) -> Item:
        item = Item(**data.model_dump(), user_id=user_id)
        db.session.add(item)
        db.session.commit()
        return item
```

**Verification:**
```bash
ruff check .
mypy app/
pytest -v  # if tests exist
```

**Manual testing:**
- [ ] All CRUD endpoints respond correctly
- [ ] Validation errors return 422 with details
- [ ] Not found returns 404
- [ ] Pagination works

**Architecture validation:**
- Verify routes are thin (delegate to services)
- Verify Pydantic validation on all inputs
- Verify consistent error response format
- Verify RESTful conventions followed

### Phase 4: Authentication & Security

**Focus:** JWT implementation, auth decorators, CORS, rate limiting

**Implementation checklist:**
- [ ] Create `app/auth/jwt.py` with token create/decode
- [ ] Create `app/auth/decorators.py` with `@require_auth`
- [ ] Create auth routes (register, login, refresh)
- [ ] Add password hashing (bcrypt/argon2)
- [ ] Configure CORS for frontend origins
- [ ] Configure rate limiting (stricter on auth endpoints)
- [ ] Add auth decorator to protected routes

**Verification:**
```bash
ruff check .
mypy app/
pytest -v
```

**Manual testing:**
- [ ] Registration creates user with hashed password
- [ ] Login returns valid JWT
- [ ] Protected routes reject unauthenticated requests
- [ ] Token expiration works
- [ ] CORS headers present for configured origins
- [ ] Rate limiting rejects excessive requests

**Architecture validation:**
- Verify JWT implementation secure
- Verify passwords hashed (never stored plain)
- Verify CORS restricted to known origins
- Verify rate limits appropriate

### Phase 5: Testing, Polish & Deployment

**Focus:** Comprehensive tests, final polish, Vercel deployment

**Implementation checklist:**
- [ ] Create `tests/conftest.py` with app/client/db fixtures
- [ ] Write API endpoint tests for all routes
- [ ] Write service layer tests
- [ ] Write auth flow tests
- [ ] Verify `pyproject.toml` correct for Vercel
- [ ] Create/verify `requirements.txt`
- [ ] Test with `vercel dev` (if CLI available)
- [ ] Verify bundle size
- [ ] Document all environment variables

**Verification:**
```bash
ruff check .
mypy app/
pytest --cov=app --cov-report=term-missing -v
```

**Deployment verification:**
```bash
# Check Vercel entrypoint
python -c "from app import app; print(type(app))"

# Check bundle size (approximate)
pip install pipdeptree
pipdeptree --warn silence | wc -l

# Verify no hardcoded secrets
rg -l "SECRET_KEY\s*=\s*['\"]" app/ || echo "No hardcoded secrets found"
```

**Check:**
- All tests pass
- Coverage > 60%
- Linting clean
- Type checking clean
- Vercel entrypoint works
- No hardcoded secrets

## Verification After Implementation

After completing all phases:

### 1. Full Test Suite
```bash
pytest --cov=app --cov-report=term-missing -v
```

**Requirements:**
- All tests pass
- Coverage > 60% (target from plan)
- No skipped tests without justification

### 2. Linting & Type Check
```bash
ruff check .
mypy app/
```

**Must be clean.**

### 3. Application Startup
```bash
python -c "from app import create_app; app = create_app('testing'); print('App OK')"
```

### 4. API Smoke Test
```bash
# Start server
flask run &
sleep 2

# Health check
curl -s http://localhost:5000/health

# Register
curl -s -X POST http://localhost:5000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test","password":"secure123"}'

# Login
curl -s -X POST http://localhost:5000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Use token on protected route
curl -s http://localhost:5000/api/v1/users \
  -H "Authorization: Bearer <token>"
```

### 5. Bundle Size Check
```bash
# Estimate bundle size
du -sh .venv/lib/python*/site-packages/ 2>/dev/null
# Should be well under 250MB (target < 50MB)
```

### 6. Architecture Final Validation

**Final consultation with python-vercel-backend-architect:**

```
Task(
  subagent_type="generalPurpose",
  prompt="""
  Act as the python-vercel-backend-architect agent.
  
  [Paste full content of .cursor/agents/python-vercel-backend-architect.md]
  
  ---
  
  ## Final Architecture Review
  
  Project: <project name>
  Plan: <plan filename>
  
  All phases complete. Please perform final architecture review:
  
  1. Application structure (factory, blueprints, services)
  2. Data layer (models, schemas, connection pooling)
  3. API design (REST conventions, validation, errors)
  4. Security (auth, CORS, rate limiting)
  5. Vercel optimization (bundle, cold starts)
  6. Testing coverage and quality
  7. Production readiness
  
  Provide:
  - PRODUCTION READY or ISSUES FOUND
  - List any concerns
  - Recommendations for post-launch
  - Performance comparison vs targets
  
  Test output:
  <paste pytest output>
  
  Lint output:
  <paste ruff output>
  """
)
```

## Handling Issues

### Linting Errors

If `ruff check .` fails:
1. Run `ruff check --fix .` for auto-fixable issues
2. Fix remaining issues manually
3. Common issues: import ordering, unused imports, line length

### Type Errors

If `mypy app/` fails:
1. Fix type annotation issues
2. Add proper return types
3. Use `from __future__ import annotations` for forward refs
4. Never use `# type: ignore` without justification

### Test Failures

If `pytest` fails:
1. Check test fixtures (app, client, db)
2. Verify test database setup/teardown
3. Check for ordering dependencies between tests
4. Ensure each test is independent

### Import Errors / Circular Imports

Common in Flask projects:
1. Import blueprints AFTER creating them
2. Use `from app.api.v1 import api_v1_bp` pattern
3. Avoid importing app in models (use `db` from extensions)
4. Use local imports in route modules if needed

### Vercel Deployment Issues

If Vercel deployment fails:
1. Check entrypoint exports `app` instance (not factory)
2. Verify `pyproject.toml` has correct `[project.scripts]`
3. Check bundle size < 250MB
4. Verify all dependencies in requirements.txt
5. Check Python version compatibility

## Agent Orchestration Mode

For larger projects (4+ phases), use agent orchestration:

### Setup

1. **Ensure ledger exists** (auto-created above)

2. **Create handoff directory:**
   ```bash
   mkdir -p thoughts/handoffs/<session-name>
   ```

3. **Read implementation agent skill:**
   ```bash
   cat .cursor/skills/implement_task/SKILL.md
   ```

### Orchestration Loop with Flask Validation

For each phase:

```
1. Implement Phase
   |
2. Verify Linting + Types (ruff, mypy)
   |
3. Run Tests (pytest)
   |
4. Validate Architecture (python-vercel-backend-architect)
   |
5. Review Code (task-review-agent)
   |
6. Fix Issues (if needed, max 3 iterations)
   |
7. Next Phase
```

### Phase Implementation Template

```
Task(
  subagent_type="generalPurpose",
  prompt="""
  [Paste contents of .cursor/skills/implement_task/SKILL.md]
  
  ---
  
  ## Python Flask + Vercel Context
  
  ### Project Type
  Python Flask 3+ backend API, deployed on Vercel as serverless function
  
  ### Standards to Follow
  [Paste relevant sections from .cursor/rules/python-vercel-backend-standards.mdc]
  
  ### Your Phase
  Phase [N] of [Total]: <phase description>
  
  ### From Plan
  <paste relevant phase section from plan>
  
  ### Architecture Requirements
  <paste architecture decisions from plan for this phase>
  
  ### Performance Budget
  - Cold Start: < X s
  - CRUD Response: < X ms
  - Bundle Size: < X MB
  - Test Coverage: > X%
  
  ### Verification Required
  After implementation, run:
  1. ruff check .
  2. mypy app/
  3. pytest -v
  4. Check app starts correctly
  
  ### Handoff Location
  thoughts/handoffs/<session-name>/phase-[NN]-<short-description>.md
  
  ---
  
  Implement your phase following Python Flask + Vercel best practices.
  """
)
```

### Post-Implementation Validation

After agent completes phase:

```
# 1. Verify linting and types
bash("ruff check .")
bash("mypy app/")

# 2. Run tests
bash("pytest -v")

# 3. Validate architecture
Task(
  subagent_type="generalPurpose",
  prompt="""[python-vercel-backend-architect validation as shown above]"""
)

# 4. Review code quality
Task(
  subagent_type="task-review-agent",
  prompt="""[standard review with Flask focus]"""
)
```

### Example Orchestration Session

```
User: /implement_python_vercel_backend_architect thoughts/shared/plans/2026-02-14-flask-task-api.md

Claude: I'll use agent orchestration for this Flask + Vercel project (5 phases).

Verifying Python/Flask setup...
- Python 3.11 detected
- Flask project structure found
- pyproject.toml present

Creating continuity ledger...
Created: thoughts/ledgers/flask-task-api.md

----------------------------------------------
Phase 1 of 5: Foundation & Project Setup
----------------------------------------------

Implementing...
[Spawns implement_task agent]
[Agent completes: thoughts/handoffs/flask-task-api/phase-01-foundation.md]

Verifying...
[Runs: ruff check .]
Pass

[Runs: python -c "from app import create_app; app = create_app('testing'); print('OK')"]
OK

Validating architecture...
[Spawns python-vercel-backend-architect agent]
- Application factory pattern
- Extensions initialized correctly
- Error handlers registered
- Health check endpoint working
Status: APPROVED

Reviewing code...
[Spawns task-review-agent]
Status: APPROVED

Phase 1 complete. Ready for manual verification.

Please verify:
- App starts without errors
- Health check returns 200
- Error handlers return JSON

Type 'continue' when ready for Phase 2.

User: continue

----------------------------------------------
Phase 2 of 5: Data Layer
----------------------------------------------

[continues...]
```

## Recovery After Compaction

If context compacts mid-implementation:

1. **Read ledger** (loaded by SessionStart hook)
2. **List handoffs:**
   ```bash
   ls -la thoughts/handoffs/<session-name>/
   ```
3. **Read last handoff** to understand state
4. **Check last test status**
5. **Continue from next incomplete phase**

## Success Criteria

A successful Python Flask + Vercel implementation will:

### Code Quality
- Ruff passes with no errors
- mypy passes with no errors (or documented exceptions)
- All tests pass
- Coverage > 60%

### Architecture Quality
- Application factory pattern used
- Blueprints organized by domain
- Service layer separates business logic
- Pydantic validates all input/output
- Error handling is consistent

### Performance Quality
- Cold start < 2s (target from plan)
- Simple CRUD < 200ms
- Bundle size < 50MB
- Connection pooling configured

### Security Quality
- Authentication implemented correctly
- Authorization checks on protected routes
- CORS restricted to known origins
- Rate limiting configured
- No hardcoded secrets
- Input validated on all endpoints

### Vercel Quality
- Entrypoint exports `app` instance correctly
- `pyproject.toml` configured for Vercel
- Environment variables documented
- Bundle size within Vercel limits (< 250MB)
- Health check endpoints present

### Testing Quality
- Pytest configured with fixtures
- API endpoint tests for all routes
- Service layer tests
- Auth flow tests
- Coverage > 60%

## Final Deliverables

When implementation complete, provide:

### 1. Test Report
```
Test Report
===========

Status: PASS
Tests: XX passing, 0 failing
Coverage: XX% (target: 60%)

Coverage by module:
- app/api/: XX%
- app/services/: XX%
- app/models/: XX%
- app/auth/: XX%
```

### 2. Architecture Validation
```
Architecture Review
==================

Application Structure: APPROVED
- Factory pattern used correctly
- Blueprints organized by domain
- Service layer clean

Data Layer: APPROVED
- Models properly typed
- Pydantic schemas complete
- Connection pooling configured

API Design: APPROVED
- RESTful conventions followed
- Validation on all inputs
- Consistent error format

Security: APPROVED
- JWT authentication working
- CORS configured
- Rate limiting active
- No hardcoded secrets

Vercel Optimization: APPROVED
- Entrypoint correct
- Bundle size: ~XX MB
- Dependencies minimal

Status: PRODUCTION READY
```

### 3. Deployment Checklist
```
Deployment Checklist
===================

Before deploying to Vercel:
- [ ] Environment variables added to Vercel dashboard
- [ ] Database created and connection string set
- [ ] SECRET_KEY generated and set
- [ ] CORS origins configured for frontend
- [ ] Run `vc deploy` for preview
- [ ] Test all endpoints on preview URL
- [ ] Deploy to production: `vc deploy --prod`

After deployment:
- [ ] Health check passes: curl https://app.vercel.app/health
- [ ] Auth flow works end-to-end
- [ ] All CRUD operations work
- [ ] CORS works from frontend
- [ ] Monitor Vercel dashboard for errors

Deploy command:
$ vc deploy --prod
```

## Tips for Success

1. **Verify Early, Verify Often**
   - Don't wait until end of phase
   - Run `ruff check .` frequently
   - Run tests after each major change

2. **Respect Architecture Decisions**
   - Plans are validated by architect agent
   - Don't deviate without good reason
   - Consult architect agent if unsure

3. **Keep Routes Thin**
   - Validate input -> call service -> return response
   - No business logic in route handlers
   - Service layer is where logic lives

4. **Pydantic Everything**
   - All request bodies through Pydantic
   - All response bodies through Pydantic
   - Catch ValidationError in routes

5. **Think Serverless**
   - No persistent state between requests
   - No background workers
   - No local file storage
   - Connection pooling is critical

6. **Quality Over Speed**
   - Better to take time and get it right
   - Fix issues immediately
   - Don't accumulate technical debt

Remember: You're building a production-ready Python Flask + Vercel backend API. Code quality, security, and architecture matter from day one.

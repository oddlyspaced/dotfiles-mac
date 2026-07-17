---
description: Implement Next.js + Vercel project plans with architecture validation and quality checks
---

# Implement Next.js + Vercel Project Plan

You are tasked with implementing Next.js + Vercel project plans created by `/create_new_project_vercel_nextjs_plan`. These plans are optimized for greenfield Next.js 15+ applications with specific architecture, performance, and SEO requirements.

## Key Differences from Regular Implementation

This skill is specialized for Next.js + Vercel projects and includes:
- ✅ **Next.js-specific verification** (build, TypeScript, ESLint)
- ✅ **Architecture validation** using `nextjs-vercel-architect` agent
- ✅ **Performance checks** (Lighthouse, bundle size, Core Web Vitals)
- ✅ **SEO verification** (metadata, sitemap, OpenGraph)
- ✅ **Vercel optimization validation** (static generation, caching)
- ✅ **Standards enforcement** using `nextjs-vercel-standards.mdc` rules

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
- Each phase goes through implement → review → fix cycle
- Use this for complete project implementations

**To use agent orchestration mode**, say: "I'll use agent orchestration for this plan" and follow the Agent Orchestration section below.

---

## Getting Started

When given a plan path:

1. **Verify it's a Next.js + Vercel plan**:
   - Check filename contains "nextjs" or was created by `/create_new_project_vercel_nextjs_plan`
   - If not, suggest using regular `/implement_plan` instead

2. **Read the plan completely**:
   - Check for existing checkmarks (- [x])
   - Note performance budgets and targets
   - Identify Vercel-specific optimizations

3. **Verify Next.js setup**:
   ```bash
   # Check package.json
   cat package.json | grep "next"
   
   # Check Next.js config
   ls next.config.* 2>/dev/null
   
   # Verify it's App Router (not Pages Router)
   ls -la app/ 2>/dev/null
   ```

4. **Read all referenced files**:
   - Read files FULLY (no limit/offset)
   - Understand current template state
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

1. Extract session name from plan filename (e.g., `2026-02-11-nextjs-saas-landing.md` → `nextjs-saas-landing`)
2. Extract phases from the plan
3. Create ledger with phases as checkboxes:

```bash
mkdir -p thoughts/ledgers
```

Use this template:

```markdown
# Session: <session-name-from-plan>
Type: Next.js + Vercel Project
Updated: <ISO timestamp>

## Goal
<Extract from plan's overview section>

## Technology Stack
<Extract from plan's technology stack section>

## Performance Targets
- Lighthouse Performance: <from plan>
- First Load JS: <from plan>
- LCP: <from plan>
- CLS: <from plan>

## Architecture Decisions
<Extract key architecture decisions from plan>

## State
- Done:
  - (none yet)
- Now: [→] Phase 1: <first phase from plan>
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
Created Next.js + Vercel continuity ledger: thoughts/ledgers/<name>.md
This tracks architecture decisions, performance targets, and progress.
```

**If ledger exists**, read it and verify it matches the plan you're implementing.

## Implementation Philosophy for Next.js + Vercel

Next.js + Vercel projects have specific requirements:

### Follow the Architecture
- **App Router patterns** - Server Components by default
- **Data fetching strategy** - Follow SSG/ISR/SSR decisions from plan
- **Component boundaries** - Respect Server vs Client Component decisions
- **Performance budget** - Stay within bundle size targets

### Verify as You Go
- **After each file** - Ensure TypeScript compiles
- **After each component** - Check if it should be Server or Client
- **After each page** - Verify data fetching strategy matches plan
- **After each phase** - Run full verification suite

### Quality Standards
Every implementation must meet:
- ✅ TypeScript strict mode (no `any` types)
- ✅ App Router patterns (no Pages Router)
- ✅ Proper Server/Client Component usage
- ✅ Image optimization (next/image)
- ✅ Font optimization (next/font)
- ✅ SEO metadata on all pages
- ✅ Performance budget maintained

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
3. Consult nextjs-vercel-architect agent for guidance

Recommendation: [your suggestion]
```

## Next.js + Vercel Verification Suite

After implementing each phase, run these checks **in this order**:

### 1. TypeScript Verification
```bash
npx tsc --noEmit
```
**Must pass** - No type errors allowed.

### 2. Linting
```bash
npm run lint
```
**Must pass** - Fix all ESLint errors and warnings.

### 3. Build Verification
```bash
npm run build
```
**Must pass** - Build must complete successfully.

**Check build output for:**
- ⚠️ Routes marked as dynamic (○) when they should be static (●)
- ⚠️ Large bundles exceeding budget
- ⚠️ Missing optimizations

### 4. Bundle Size Check
```bash
# After build, check .next/static output
du -sh .next/static/chunks/*.js | sort -h | tail -10
```

**Compare against performance budget from plan.**

### 5. Development Server Check
```bash
npm run dev
```

**Verify:**
- ✅ No console errors
- ✅ No hydration warnings
- ✅ Hot reload works
- ✅ Pages render correctly

### 6. Architecture Validation (Per Phase)

**Consult nextjs-vercel-architect agent:**

After completing a phase, validate the architecture:

```
Task(
  subagent_type="generalPurpose",
  prompt="""
  Act as the nextjs-vercel-architect agent.
  
  [Paste full content of .cursor/agents/nextjs-vercel-architect.md]
  
  ---
  
  ## Validation Request
  
  Phase completed: <phase name>
  
  Files modified:
  <list files changed>
  
  Please validate:
  1. Data fetching strategy (SSG/ISR/SSR)
  2. Component architecture (Server/Client boundaries)
  3. Performance impact
  4. Vercel optimization
  5. SEO implementation
  
  Review the implementation and provide:
  - ✅ APPROVED or ⚠️ NEEDS REVISION for each area
  - Specific issues found
  - Recommendations for fixes
  - Performance impact
  
  Implementation details:
  <paste git diff or file contents>
  """
)
```

**Only proceed to next phase if validation passes.**

### 7. Manual Verification

After automated checks, perform manual testing:

**For all pages:**
- [ ] Navigate to page in browser
- [ ] Check responsive design (mobile, tablet, desktop)
- [ ] Verify no layout shifts during load
- [ ] Check images load and are optimized
- [ ] Verify fonts load without flash

**For interactive features:**
- [ ] Forms validate correctly
- [ ] Buttons have proper loading states
- [ ] Error states display properly
- [ ] Success states work

**For SEO:**
- [ ] View page source - metadata present
- [ ] OpenGraph tags visible in source
- [ ] Check /sitemap.xml accessible
- [ ] Check /robots.txt accessible

## Phase-by-Phase Implementation Guide

### Phase 1: Foundation & Core Setup

**Focus:** Next.js configuration, design system, layouts

**Implementation checklist:**
- [ ] Update `next.config.mjs` with all configurations from plan
- [ ] Configure `tailwind.config.ts` with theme
- [ ] Set up `app/globals.css` with design tokens
- [ ] Create `app/layout.tsx` with RootLayout
- [ ] Configure fonts using `next/font`
- [ ] Set up base metadata in RootLayout
- [ ] Create layout components (Header, Footer)

**Verification:**
```bash
npx tsc --noEmit
npm run lint
npm run build
npm run dev
```

**Check:**
- ✅ Build succeeds
- ✅ No TypeScript errors
- ✅ Design system renders correctly
- ✅ Fonts load without FOUT/FOIT
- ✅ Layout responsive on all viewports

**Architecture validation:**
- Verify RootLayout is Server Component
- Verify fonts loaded via next/font
- Verify metadata uses Metadata API

### Phase 2: Content Architecture

**Focus:** Pages, routing, content structure

**Implementation checklist:**
- [ ] Create static pages (SSG)
- [ ] Set up dynamic routes with `generateStaticParams()`
- [ ] Configure ISR for content pages
- [ ] Add metadata to all pages via `generateMetadata()`
- [ ] Implement proper route organization

**Verification:**
```bash
npm run build
```

**Check build output:**
```
Route (app)                              Size     First Load JS
┌ ○ /                                    X kB          Y kB
├ ○ /about                               X kB          Y kB  
├ ● /blog                                X kB          Y kB
└ ƒ /blog/[slug]                         X kB          Y kB

○  (Static)  prerendered as static content
●  (SSG)     prerendered as static HTML (uses getStaticProps)
ƒ  (Dynamic) server-rendered on demand using Node.js
```

**Verify:**
- ✅ Static pages marked with ○ or ●
- ✅ Dynamic routes generate static params
- ✅ Bundle sizes within budget
- ✅ All pages have metadata

**Architecture validation:**
- Verify data fetching strategy matches plan
- Verify revalidation intervals correct
- Verify metadata dynamic for blog posts
- Verify generateStaticParams used

### Phase 3: Features & Functionality

**Focus:** Interactive components, forms, APIs

**Implementation checklist:**
- [ ] Create client components with `'use client'` directive
- [ ] Implement Server Actions for forms
- [ ] Add form validation (Zod schemas)
- [ ] Add loading and error states
- [ ] Implement error boundaries

**Key patterns to follow:**
```typescript
// Server Component (default)
export default async function Page() {
  const data = await fetchData();
  return <ClientComponent data={data} />;
}

// Client Component
'use client';
export default function ClientComponent({ data }) {
  const [state, setState] = useState();
  return <div>...</div>;
}

// Server Action
'use server';
export async function createEntry(formData: FormData) {
  // validation, mutation, revalidation
}
```

**Verification:**
```bash
npx tsc --noEmit
npm run lint
npm run build
npm run dev
```

**Manual testing:**
- [ ] Forms submit correctly
- [ ] Validation errors display
- [ ] Loading states show
- [ ] Success feedback works
- [ ] Error handling works

**Architecture validation:**
- Verify minimal Client Components
- Verify Server Actions over API routes
- Verify proper error boundaries
- Verify loading states present

### Phase 4: Performance & Polish

**Focus:** Optimization, accessibility, analytics

**Implementation checklist:**
- [ ] Audit all images use next/image
- [ ] Verify proper image sizing
- [ ] Check bundle size with analyzer
- [ ] Run Lighthouse audit
- [ ] Fix accessibility issues
- [ ] Add analytics tracking

**Performance check:**
```bash
# Analyze bundle
npm run build
npx @next/bundle-analyzer

# Check specific pages
open http://localhost:3000
# Run Lighthouse in DevTools
```

**Targets from plan:**
- Lighthouse Performance: 90+
- Lighthouse Accessibility: 100
- Lighthouse Best Practices: 100
- Lighthouse SEO: 100
- First Load JS: < 100kb

**Accessibility check:**
- [ ] Run axe DevTools
- [ ] Test keyboard navigation
- [ ] Check color contrast
- [ ] Test with screen reader
- [ ] Verify ARIA labels

**Architecture validation:**
- Verify image optimization correct
- Verify bundle size acceptable
- Verify no performance anti-patterns
- Verify accessibility compliance

### Phase 5: Deployment & Launch

**Focus:** Vercel configuration, domain, monitoring

**Implementation checklist:**
- [ ] Create `vercel.json` if needed
- [ ] Configure environment variables
- [ ] Set up sitemap generation
- [ ] Configure robots.txt
- [ ] Add monitoring/analytics
- [ ] Prepare deployment

**Vercel-specific checks:**
```bash
# Local Vercel preview
npm run build
npx vercel dev

# Check environment variables
cat .env.local.example  # Should document all vars
```

**Pre-deployment verification:**
- [ ] All environment variables documented
- [ ] Build succeeds locally
- [ ] TypeScript passes
- [ ] Linting passes
- [ ] Manual testing complete
- [ ] SEO checklist complete

**SEO checklist:**
- [ ] Sitemap at /sitemap.xml
- [ ] robots.txt at /robots.txt
- [ ] All pages have metadata
- [ ] OpenGraph tags on all pages
- [ ] Twitter Cards configured
- [ ] Structured data added (if applicable)
- [ ] Canonical URLs set

**Architecture validation:**
- Verify Vercel optimizations in place
- Verify static generation maximized
- Verify Edge runtime used appropriately
- Verify caching strategy correct

## Verification After Implementation

After completing all phases:

### 1. Final Build Check
```bash
npm run build
```

**Analyze output:**
- Check for dynamic routes that should be static
- Verify bundle sizes
- Note any warnings

### 2. Lighthouse Audit

Run Lighthouse on key pages:
```bash
# Homepage
# Blog post
# Dynamic page
```

**Targets:**
- Performance: 90+
- Accessibility: 100
- Best Practices: 100
- SEO: 100

### 3. Core Web Vitals

Check in Lighthouse:
- **LCP (Largest Contentful Paint)**: < 2.5s
- **FID (First Input Delay)**: < 100ms
- **CLS (Cumulative Layout Shift)**: < 0.1

### 4. Vercel Deployment Check

```bash
# Deploy to Vercel
vercel

# Or if already connected
git push origin main
```

**Post-deployment verification:**
- [ ] Site accessible on Vercel URL
- [ ] All pages load correctly
- [ ] Images optimized and loading
- [ ] Environment variables working
- [ ] Analytics receiving data
- [ ] No console errors in production

### 5. SEO Verification

**Check with tools:**
- Google Search Console (if connected)
- Social sharing preview (Twitter, Facebook)
- Rich Results Test (for structured data)

**Manual checks:**
- [ ] View page source shows metadata
- [ ] OpenGraph images display in preview
- [ ] Sitemap accessible and valid
- [ ] robots.txt accessible

### 6. Architecture Final Validation

**Final consultation with nextjs-vercel-architect:**

```
Task(
  subagent_type="generalPurpose",
  prompt="""
  Act as the nextjs-vercel-architect agent.
  
  [Paste full content of .cursor/agents/nextjs-vercel-architect.md]
  
  ---
  
  ## Final Architecture Review
  
  Project: <project name>
  Plan: <plan filename>
  
  All phases complete. Please perform final architecture review:
  
  1. Overall data fetching strategy
  2. Component architecture (Server/Client split)
  3. Performance metrics achieved
  4. Vercel optimization implementation
  5. SEO setup completeness
  6. Production readiness
  
  Provide:
  - ✅ PRODUCTION READY or ⚠️ ISSUES FOUND
  - List any concerns
  - Recommendations for post-launch
  - Performance comparison vs targets
  
  Build output:
  <paste npm run build output>
  
  Lighthouse scores:
  <paste Lighthouse results>
  """
)
```

## Handling Issues

### TypeScript Errors

If `npx tsc --noEmit` fails:
1. Fix errors immediately
2. Never use `any` type
3. Never use `@ts-ignore` unless absolutely necessary
4. Add proper type definitions

### Build Failures

If `npm run build` fails:
1. Check error message carefully
2. Common issues:
   - Async components not awaited
   - Server Component using client hooks
   - Client Component not marked with 'use client'
   - Import errors
3. Fix and rebuild

### Performance Budget Exceeded

If bundle size exceeds budget:
1. Run bundle analyzer: `npx @next/bundle-analyzer`
2. Identify large dependencies
3. Use dynamic imports:
   ```typescript
   const HeavyComponent = dynamic(() => import('./Heavy'), {
     loading: () => <Skeleton />
   });
   ```
4. Remove unused dependencies
5. Check for duplicate packages

### Lighthouse Score Too Low

If Lighthouse performance < 90:
1. Check LCP - is hero image optimized?
2. Check CLS - are there layout shifts?
3. Check TBT - is JavaScript blocking?
4. Use next/image for all images
5. Ensure fonts use next/font
6. Minimize client-side JavaScript

### Architecture Validation Failed

If nextjs-vercel-architect finds issues:
1. Read the specific concerns
2. Understand the recommendation
3. Implement the fix
4. Re-validate

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

### Orchestration Loop with Next.js Validation

For each phase:

```
1. Implement Phase
   ↓
2. Verify Next.js Build
   ↓
3. Validate Architecture (nextjs-vercel-architect)
   ↓
4. Review Code (task-review-agent)
   ↓
5. Fix Issues (if needed, max 3 iterations)
   ↓
6. Next Phase
```

### Phase Implementation Template

```
Task(
  subagent_type="general-purpose",
  model="opus",
  prompt="""
  [Paste contents of .cursor/skills/implement_task/SKILL.md]
  
  ---
  
  ## Next.js + Vercel Context
  
  ### Project Type
  Next.js 15+ with App Router, deployed on Vercel
  
  ### Standards to Follow
  [Paste relevant sections from .cursor/rules/nextjs-vercel-standards.mdc]
  
  ### Your Phase
  Phase [N] of [Total]: <phase description>
  
  ### From Plan
  <paste relevant phase section from plan>
  
  ### Architecture Requirements
  <paste architecture decisions from plan for this phase>
  
  ### Performance Budget
  - First Load JS: < X kb
  - Lighthouse: 90+
  - Bundle target: X kb for this phase
  
  ### Verification Required
  After implementation, run:
  1. npx tsc --noEmit
  2. npm run lint  
  3. npm run build
  4. Check build output for optimization
  
  ### Handoff Location
  thoughts/handoffs/<session-name>/phase-[NN]-<short-description>.md
  
  ---
  
  Implement your phase following Next.js 15 + Vercel best practices.
  """
)
```

### Post-Implementation Validation

After agent completes phase:

```
# 1. Verify Next.js build
bash("npm run build")

# 2. Validate architecture
Task(
  subagent_type="generalPurpose",
  prompt="""[nextjs-vercel-architect validation as shown above]"""
)

# 3. Review code quality
Task(
  subagent_type="task-review-agent",
  prompt="""[standard review with Next.js focus]"""
)
```

### Example Orchestration Session

```
User: /implement_new_project_vercel_nextjs_plan thoughts/shared/plans/2026-02-11-nextjs-saas-landing.md

Claude: I'll use agent orchestration for this Next.js + Vercel project (5 phases).

Verifying Next.js setup...
✓ Next.js 15.1.0 detected
✓ App Router structure found
✓ TypeScript configured

Creating continuity ledger...
Created: thoughts/ledgers/nextjs-saas-landing.md

────────────────────────────────────────────────────────
Phase 1 of 5: Foundation & Core Setup
────────────────────────────────────────────────────────

📝 Implementing...
[Spawns implement_task agent]
[Agent completes: thoughts/handoffs/nextjs-saas-landing/phase-01-foundation.md]

🔨 Building Next.js...
[Runs: npm run build]
✓ Build successful (First Load JS: 78 KB)

🏗️ Validating architecture...
[Spawns nextjs-vercel-architect agent]
✓ RootLayout follows Server Component pattern
✓ Fonts optimized with next/font
✓ Metadata API used correctly
✓ Performance budget maintained
Status: ✅ APPROVED

🔍 Reviewing code...
[Spawns task-review-agent]
Status: ✅ APPROVED

✅ Phase 1 complete. Ready for manual verification.

Please verify:
- Design system renders correctly
- Responsive on mobile, tablet, desktop
- Fonts load without flash
- Navigation works

Type 'continue' when ready for Phase 2.

User: continue

────────────────────────────────────────────────────────
Phase 2 of 5: Content Architecture
────────────────────────────────────────────────────────

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
4. **Check last build status**
5. **Continue from next incomplete phase**

## Success Criteria

A successful Next.js + Vercel implementation will:

### Build Quality
- ✅ TypeScript compiles with no errors
- ✅ ESLint passes with no warnings
- ✅ Next.js builds successfully
- ✅ No console errors or warnings

### Architecture Quality
- ✅ App Router patterns followed
- ✅ Server Components by default
- ✅ Client Components minimal and justified
- ✅ Data fetching strategy matches plan
- ✅ Proper caching configured

### Performance Quality
- ✅ Lighthouse Performance 90+
- ✅ First Load JS < 100kb
- ✅ LCP < 2.5s
- ✅ CLS < 0.1
- ✅ Images optimized (AVIF/WebP)
- ✅ Fonts optimized (next/font)

### SEO Quality
- ✅ Lighthouse SEO 100
- ✅ Metadata on all pages
- ✅ Sitemap generated
- ✅ OpenGraph tags present
- ✅ robots.txt configured
- ✅ Structured data added (if applicable)

### Vercel Quality
- ✅ Static generation maximized
- ✅ ISR configured appropriately
- ✅ Edge runtime used where beneficial
- ✅ Caching strategy correct
- ✅ Environment variables documented

### Code Quality
- ✅ TypeScript strict mode
- ✅ No `any` types
- ✅ Proper component types
- ✅ Error handling present
- ✅ Loading states implemented
- ✅ Follows nextjs-vercel-standards.mdc

## Final Deliverables

When implementation complete, provide:

### 1. Build Report
```
Next.js Build Report
===================

Build Status: ✅ SUCCESS
Build Time: X seconds
First Load JS: X KB
Routes Generated: X static, Y dynamic

Top 10 Chunks:
[list with sizes]

Optimization Notes:
[any important notes]
```

### 2. Performance Report
```
Lighthouse Scores
================

Homepage:
- Performance: XX/100
- Accessibility: XX/100
- Best Practices: XX/100
- SEO: XX/100

Core Web Vitals:
- LCP: X.Xs
- FID: Xms
- CLS: X.XX

Status: ✅ MEETS TARGETS / ⚠️ NEEDS OPTIMIZATION
```

### 3. Architecture Validation
```
Architecture Review
==================

Data Fetching: ✅ APPROVED
- XX% static pages
- YY% ISR with appropriate revalidation
- ZZ% dynamic (justified)

Component Architecture: ✅ APPROVED
- Server Components: XX files
- Client Components: YY files (minimal)
- Proper boundaries maintained

Performance: ✅ APPROVED
- Bundle size within budget
- Images optimized
- Fonts optimized

Vercel Optimization: ✅ APPROVED
- Free tier optimized
- Caching configured
- Edge runtime used

Status: ✅ PRODUCTION READY
```

### 4. Next Steps
```
Deployment Checklist
===================

Before deploying to Vercel:
- [ ] Environment variables added to Vercel
- [ ] Custom domain configured (if applicable)
- [ ] Analytics configured
- [ ] Error tracking set up (Sentry, etc.)
- [ ] Performance monitoring enabled

After deployment:
- [ ] Verify all pages load
- [ ] Check social sharing previews
- [ ] Submit sitemap to Google Search Console
- [ ] Monitor Core Web Vitals
- [ ] Watch error tracking

Post-launch monitoring:
- Check Vercel Analytics daily
- Monitor performance metrics
- Watch for errors
- Review user feedback
```

## Tips for Success

1. **Verify Early, Verify Often**
   - Don't wait until end of phase
   - Run `npm run build` frequently
   - Check TypeScript continuously

2. **Respect Architecture Decisions**
   - Plans are validated by architect agent
   - Don't deviate without good reason
   - Consult architect agent if unsure

3. **Performance Budget is Sacred**
   - Watch bundle size grow
   - Dynamic import heavy components
   - Remove unused dependencies

4. **Server Components by Default**
   - Only use 'use client' when needed
   - Most components should be Server Components
   - Push interactivity to edges

5. **Trust But Verify**
   - Templates may not match plan exactly
   - Adapt plan to reality when needed
   - Document any deviations

6. **Quality Over Speed**
   - Better to take time and get it right
   - Fix issues immediately
   - Don't accumulate technical debt

Remember: You're building a production-ready Next.js + Vercel application. Quality and performance matter from day one.

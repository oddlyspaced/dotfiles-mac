---
description: Create comprehensive Next.js + Vercel project plans for new greenfield web applications
---

# Next.js + Vercel Project Plan

You are tasked with creating detailed implementation plans for **new Next.js projects deployed on Vercel**. This skill is optimized for greenfield projects starting from a fresh Next.js template.

## Key Assumptions

- **Fresh Start**: Working with a newly cloned Next.js template (Vercel or create-next-app)
- **Modern Stack**: Next.js 15+ with App Router, React 19, TypeScript
- **Deployment**: Optimized for Vercel's platform and free tier maximization
- **Quality First**: Emphasis on performance, SEO, accessibility, and maintainability

## Initial Response

When this command is invoked:

1. **Check if parameters were provided**:
   - If a requirements file or brief was provided, read it FULLY
   - Begin the research process immediately
   
2. **If no parameters provided**, respond with:
```
I'll help you plan your Next.js + Vercel website. Let me understand what you're building.

Please provide:
1. **Project Overview**: What type of website? (e.g., SaaS landing page, blog, e-commerce, portfolio)
2. **Key Features**: What are the main pages and functionality?
3. **Design Requirements**: Any specific UI/UX considerations or design system?
4. **Content Strategy**: Static content, CMS integration, or dynamic data?
5. **Target Audience**: Who will use this site and what devices?

I'll analyze your Next.js template structure and create a comprehensive plan optimized for Vercel deployment.
```

Then wait for the user's input.

## Process Steps

### Step 1: Template & Context Analysis

1. **Analyze the Next.js template**:
   - Read `package.json` to understand dependencies and scripts
   - Check `next.config.js` or `next.config.mjs` for existing configuration
   - Review `app/` directory structure to understand the starting point
   - Check for existing components, layouts, and fonts
   - Identify any pre-configured features (e.g., Tailwind, shadcn/ui, Auth.js)

2. **Spawn initial research tasks** (in parallel):
   - Use **codebase-locator** to map the template structure
   - Use **codebase-analyzer** to understand existing patterns and conventions
   - Use **nextjs-vercel-architect** to validate architecture decisions for the specific use case

3. **Present template analysis**:
   ```
   I've analyzed your Next.js template. Here's what we're starting with:
   
   **Current Setup:**
   - Next.js version: [X]
   - Key dependencies: [list key packages]
   - Pre-configured features: [what's already set up]
   - Directory structure: [brief overview]
   
   **Template Strengths:**
   - [What's good about this starting point]
   
   **Recommended Additions:**
   - [What we should add for your use case]
   ```

### Step 2: Architecture & Technology Decisions

Use the **nextjs-vercel-architect** agent to help make key decisions:

1. **Data Fetching Strategy**:
   - Static Generation (SSG) vs Server-Side Rendering (SSR)
   - When to use Server Components vs Client Components
   - API Routes vs Server Actions
   - Caching strategy (revalidate intervals)

2. **Styling & UI Framework**:
   - Tailwind CSS configuration and customization
   - Component library choice (shadcn/ui, Headless UI, Radix)
   - Design system setup (colors, typography, spacing)
   - Dark mode implementation strategy

3. **Content Management**:
   - Static MDX files vs Headless CMS (Sanity, Contentful, Strapi)
   - Content modeling approach
   - Asset management and optimization

4. **Authentication & Authorization** (if needed):
   - Auth.js (NextAuth) vs Clerk vs Supabase Auth
   - Session management strategy
   - Protected routes approach

5. **Database & Backend** (if needed):
   - Vercel Postgres vs Supabase vs PlanetScale
   - ORM choice (Prisma, Drizzle)
   - Edge vs Serverless functions

6. **SEO & Analytics**:
   - Metadata API usage
   - Sitemap and robots.txt generation
   - Analytics provider (Vercel Analytics, Google Analytics, Plausible)
   - OpenGraph and Twitter Card setup

7. **Performance Optimizations**:
   - Image optimization strategy
   - Font optimization (next/font)
   - Code splitting approach
   - Edge runtime usage
   - Static asset CDN strategy

### Step 3: Deep Requirements Interview

**CRITICAL:** Before writing any plan, conduct thorough interview using `AskQuestion` tool.

**Interview Categories for Web Projects:**

1. **Content & Structure**
   - What are ALL the pages/routes needed?
   - What content is static vs dynamic?
   - How will content be updated? (by developers, CMS, users)
   - Multi-language support needed?

2. **User Experience**
   - Mobile-first or desktop-first?
   - Loading states and skeleton screens?
   - Error handling and fallback UI?
   - Accessibility requirements (WCAG level)?
   - Animation and interaction preferences?

3. **Data & APIs**
   - External APIs to integrate?
   - Real-time data requirements?
   - Data validation approach?
   - Rate limiting considerations?

4. **Performance & SEO**
   - Target Core Web Vitals scores?
   - SEO critical pages (which must be SSG)?
   - Social sharing requirements?
   - Search functionality needed?

5. **Deployment & Operations**
   - Environment variables strategy?
   - Preview deployments for testing?
   - CI/CD pipeline requirements?
   - Monitoring and error tracking?
   - Budget constraints (stay on free tier)?

6. **Future Scalability**
   - Expected traffic patterns?
   - Features planned for future phases?
   - Internationalization on roadmap?
   - Mobile app planned?

**Interview Best Practices:**
- Use `AskQuestion` with 3-4 focused questions per round
- Provide options with clear tradeoffs
- For technical decisions, explain implications in user-friendly terms
- Continue until zero ambiguity remains
- Document all decisions with rationale

**Completion Criteria:**
- All pages and routes defined
- Content strategy clear
- Technical stack finalized
- Performance targets set
- SEO strategy defined
- User explicitly approves moving to plan writing

### Step 4: Vercel Optimization Analysis

Before finalizing the plan, ensure these Vercel optimizations are included:

1. **Free Tier Maximization**:
   - Maximize static generation to minimize function executions
   - Use `revalidate` for pages needing occasional updates
   - Implement proper caching headers
   - Optimize images with next/image

2. **Edge Functions** (when appropriate):
   - Middleware for auth, redirects, headers
   - Edge API routes for low-latency responses
   - Edge runtime for internationalization

3. **Build Optimizations**:
   - Configure `generateStaticParams()` for dynamic routes
   - Use Turbopack for development
   - Optimize bundle size with proper imports
   - Configure ISR for content-heavy pages

4. **Deployment Configuration**:
   - Environment variables setup
   - Preview deployments strategy
   - Custom domains configuration
   - Security headers via next.config.js

### Step 5: Plan Structure Development

Create a phased plan optimized for iterative development:

1. **Phase Structure for Web Projects**:
   ```
   Phase 1: Foundation & Core Setup
   - Next.js configuration
   - Design system and component library
   - Layout and navigation
   - SEO foundation
   
   Phase 2: Content Architecture
   - Content modeling
   - Static pages
   - Dynamic routes setup
   - Content management
   
   Phase 3: Features & Functionality
   - Interactive components
   - Forms and validation
   - API integrations
   - User authentication (if needed)
   
   Phase 4: Performance & Polish
   - Image optimization
   - Performance tuning
   - Accessibility audit
   - Analytics and monitoring
   
   Phase 5: Deployment & Launch
   - Vercel configuration
   - Domain setup
   - SEO verification
   - Launch checklist
   ```

2. **Get feedback on phasing** before writing details

### Step 6: Detailed Plan Writing

1. **Ensure directory exists**: Run `mkdir -p thoughts/shared/plans`
2. **Write the plan** to `thoughts/shared/plans/YYYY-MM-DD-nextjs-project-name.md`

**Use this template structure:**

````markdown
# [Project Name] Next.js + Vercel Implementation Plan

## Project Overview

**Type**: [e.g., SaaS Landing Page, Blog, E-commerce, Portfolio]
**Target Audience**: [who and what devices]
**Key Goals**: [main objectives]

## Technology Stack

### Core
- **Framework**: Next.js 15+ (App Router)
- **Language**: TypeScript 5+
- **Styling**: Tailwind CSS + [component library]
- **Deployment**: Vercel

### Additional Tools
- **UI Components**: [shadcn/ui, Radix, etc.]
- **Forms**: [React Hook Form, Zod]
- **CMS**: [if applicable]
- **Database**: [if applicable]
- **Auth**: [if applicable]
- **Analytics**: [Vercel Analytics, etc.]

## Architecture Decisions

### Data Fetching Strategy
- **Static Pages**: [list pages using SSG]
- **Dynamic Pages**: [list pages using SSR]
- **Revalidation**: [pages with ISR and intervals]
- **Rationale**: [why these choices]

### Component Strategy
- **Server Components**: [primary use cases]
- **Client Components**: [when needed]
- **Shared Components**: [reusable UI library]

### Performance Targets
- **Lighthouse Score**: 90+ across all metrics
- **Core Web Vitals**:
  - LCP: < 2.5s
  - FID: < 100ms
  - CLS: < 0.1
- **First Load JS**: < 100kb

## Template Starting Point

**Current Setup Analysis**:
- Dependencies: [key packages]
- Pre-configured: [what exists]
- Directory structure: [brief overview]

**Required Additions**:
- [List what needs to be added]

## What We're NOT Doing

[Explicitly list out-of-scope items]

## Phase 1: Foundation & Core Setup

### Overview
Set up the foundational architecture, design system, and core layouts.

### Changes Required:

#### 1. Next.js Configuration
**File**: `next.config.mjs`
**Changes**:
```typescript
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable Turbopack
  experimental: {
    turbo: {},
  },
  // Image domains
  images: {
    domains: ['your-cdn.com'],
    formats: ['image/avif', 'image/webp'],
  },
  // Security headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
};

export default nextConfig;
```

#### 2. Design System Configuration
**File**: `tailwind.config.ts`
**Changes**: [Tailwind theme customization]

**Files**: `app/globals.css`
**Changes**: [CSS variables, custom styles]

#### 3. Root Layout
**File**: `app/layout.tsx`
**Changes**: [RootLayout with metadata, fonts, providers]

#### 4. Shared Components
**Directory**: `components/`
**New Files**:
- `components/ui/` - Base UI components
- `components/layout/` - Layout components (Header, Footer)
- `components/shared/` - Shared feature components

### Success Criteria:

#### Automated Verification:
- [ ] Build succeeds: `npm run build`
- [ ] Type checking passes: `npx tsc --noEmit`
- [ ] Linting passes: `npm run lint`
- [ ] No console errors in dev: `npm run dev`

#### Manual Verification:
- [ ] Design system colors and typography display correctly
- [ ] Layout renders properly on mobile and desktop
- [ ] Navigation works across all viewports
- [ ] Fonts load without FOUT/FOIT

---

## Phase 2: Content Architecture

### Overview
Implement content structure, static pages, and dynamic routing.

[Similar detailed structure...]

---

## Phase 3: Features & Functionality

[Continue with detailed implementation steps...]

---

## Phase 4: Performance & Polish

### Overview
Optimize for performance, accessibility, and user experience.

### Performance Optimizations:

#### 1. Image Optimization Audit
- [ ] All images use next/image component
- [ ] Proper sizing attributes set
- [ ] AVIF/WebP formats configured
- [ ] Lazy loading for below-fold images

#### 2. Bundle Size Optimization
**Commands to run**:
```bash
# Analyze bundle
npm run build
npx @next/bundle-analyzer
```

**Actions**:
- Remove unused dependencies
- Use dynamic imports for heavy components
- Optimize third-party scripts

#### 3. Accessibility Audit
**Tools**:
- axe DevTools
- Lighthouse accessibility score
- Manual keyboard navigation testing

**Checklist**:
- [ ] All interactive elements keyboard accessible
- [ ] Proper ARIA labels
- [ ] Color contrast meets WCAG AA
- [ ] Screen reader tested

### Success Criteria:

#### Automated Verification:
- [ ] Lighthouse Performance: 90+
- [ ] Lighthouse Accessibility: 100
- [ ] Lighthouse Best Practices: 100
- [ ] Lighthouse SEO: 100
- [ ] Bundle size < 100kb first load

#### Manual Verification:
- [ ] Site loads in < 3s on 3G
- [ ] No layout shifts during load
- [ ] All animations smooth (60fps)
- [ ] Works without JavaScript for core content

---

## Phase 5: Deployment & Launch

### Overview
Deploy to Vercel with proper configuration and verification.

### Vercel Setup:

#### 1. Environment Variables
**Vercel Dashboard**:
```
NEXT_PUBLIC_SITE_URL=https://yourdomain.com
NEXT_PUBLIC_ANALYTICS_ID=xxx
# Add other env vars
```

#### 2. Domain Configuration
- [ ] Add custom domain in Vercel
- [ ] Configure DNS records
- [ ] Enable HTTPS
- [ ] Set up www redirect

#### 3. Build Configuration
**Vercel Project Settings**:
- Framework: Next.js
- Build Command: `npm run build`
- Output Directory: `.next`
- Install Command: `npm install`
- Node Version: 20.x

#### 4. Deployment Verification
**After deployment, verify**:
- [ ] All pages accessible
- [ ] Images load correctly
- [ ] API routes work
- [ ] Environment variables set
- [ ] Analytics tracking

### Success Criteria:

#### Automated Verification:
- [ ] Build completes on Vercel
- [ ] No build warnings
- [ ] Sitemap generated at /sitemap.xml
- [ ] robots.txt accessible

#### Manual Verification:
- [ ] All pages load on production
- [ ] Custom domain works
- [ ] SSL certificate valid
- [ ] Social sharing cards display correctly
- [ ] Analytics receiving data

---

## SEO Checklist

### Technical SEO
- [ ] Sitemap.xml generated and submitted
- [ ] robots.txt configured
- [ ] OpenGraph tags on all pages
- [ ] Twitter Cards configured
- [ ] Structured data (JSON-LD) added
- [ ] Canonical URLs set
- [ ] Meta descriptions on all pages
- [ ] Alt text on all images

### Performance SEO
- [ ] Core Web Vitals pass
- [ ] Mobile-friendly test pass
- [ ] Page speed insights 90+

### Content SEO
- [ ] Unique title tags
- [ ] H1-H6 hierarchy proper
- [ ] Internal linking strategy
- [ ] 404 page customized

---

## Performance Budget

| Metric | Target | Critical |
|--------|--------|----------|
| First Load JS | < 100kb | < 150kb |
| Lighthouse Performance | 90+ | 80+ |
| LCP | < 2.5s | < 4.0s |
| FID | < 100ms | < 300ms |
| CLS | < 0.1 | < 0.25 |
| Time to Interactive | < 3.5s | < 5.0s |

---

## Vercel Free Tier Optimization

### Strategy to Stay Free:
1. **Maximize Static Generation**:
   - Use SSG for all possible pages
   - Implement ISR with long revalidation times
   - Cache aggressively

2. **Minimize Function Executions**:
   - Batch API calls
   - Use middleware instead of API routes when possible
   - Cache function responses

3. **Optimize Bandwidth**:
   - Compress images (AVIF/WebP)
   - Minimize JS bundle
   - Use Vercel's edge network

4. **Monitor Usage**:
   - Check Vercel dashboard regularly
   - Set up usage alerts
   - Optimize if approaching limits

---

## Testing Strategy

### Unit Tests
- [ ] Component rendering tests
- [ ] Utility function tests
- [ ] Form validation tests

### Integration Tests
- [ ] Page navigation flows
- [ ] Form submission flows
- [ ] API route tests

### E2E Tests (Playwright)
- [ ] Critical user journeys
- [ ] Mobile responsiveness
- [ ] Cross-browser testing

### Manual Testing Checklist
1. **Desktop Testing**:
   - [ ] Chrome
   - [ ] Firefox
   - [ ] Safari
   - [ ] Edge

2. **Mobile Testing**:
   - [ ] iOS Safari
   - [ ] Chrome Mobile
   - [ ] Various screen sizes

3. **Functionality Testing**:
   - [ ] All links work
   - [ ] Forms validate correctly
   - [ ] Images load properly
   - [ ] Navigation functions

---

## Post-Launch Monitoring

### Tools Setup
- [ ] Vercel Analytics configured
- [ ] Error tracking (Sentry/Vercel)
- [ ] Uptime monitoring
- [ ] Performance monitoring

### Metrics to Track
- Daily visitors
- Page load times
- Error rates
- Conversion rates (if applicable)
- Core Web Vitals

---

## References

- Next.js Documentation: https://nextjs.org/docs
- Vercel Deployment Docs: https://vercel.com/docs
- Original requirements: `[path to requirements doc]`
- Design mockups: `[if applicable]`
````

### Step 7: Review & Iteration

1. **Present the draft plan**:
   ```
   I've created your Next.js + Vercel implementation plan at:
   `thoughts/shared/plans/YYYY-MM-DD-nextjs-project-name.md`
   
   The plan includes:
   - Complete technology stack with rationale
   - 5 phases from foundation to launch
   - Vercel optimization strategies
   - Performance targets and budgets
   - SEO and accessibility checklists
   
   Please review and let me know:
   - Are the technology choices appropriate?
   - Is the phasing logical?
   - Any features missing?
   - Performance targets realistic?
   ```

2. **Iterate based on feedback** until satisfied

## Important Guidelines

1. **Next.js 15 First**:
   - Always use App Router (not Pages Router)
   - Server Components by default
   - Async request APIs (cookies, headers, params)
   - React 19 patterns

2. **Vercel Optimized**:
   - Maximize static generation
   - Use Edge where appropriate
   - Configure proper caching
   - Optimize for free tier

3. **Performance Obsessed**:
   - Every decision impacts performance
   - Set measurable targets
   - Include monitoring strategy
   - Budget for bundle size

4. **SEO Native**:
   - Metadata API usage
   - Semantic HTML
   - Proper routing structure
   - Social sharing optimization

5. **TypeScript Strict**:
   - Full type safety
   - No `any` types
   - Proper component typing
   - API response typing

6. **Accessibility First**:
   - Keyboard navigation
   - Screen reader support
   - WCAG AA compliance
   - Semantic markup

7. **Progressive Enhancement**:
   - Core content without JS
   - Enhanced with JS
   - Graceful degradation
   - Mobile-first approach

## Quality Standards Checklist

Before finalizing any plan, ensure it includes:

### Architecture
- [ ] Clear data fetching strategy for each page type
- [ ] Server vs Client Component boundaries defined
- [ ] Caching strategy documented
- [ ] Performance targets quantified

### Development
- [ ] TypeScript configured strictly
- [ ] ESLint and Prettier set up
- [ ] Component structure defined
- [ ] File organization clear

### Performance
- [ ] Image optimization strategy
- [ ] Bundle size targets
- [ ] Lazy loading approach
- [ ] Font optimization

### SEO & Analytics
- [ ] Metadata strategy
- [ ] Sitemap generation
- [ ] Analytics setup
- [ ] Social sharing

### Deployment
- [ ] Environment variables defined
- [ ] Vercel configuration
- [ ] Domain setup plan
- [ ] Monitoring strategy

### Testing
- [ ] Unit test approach
- [ ] E2E test strategy
- [ ] Manual testing checklist
- [ ] Accessibility testing

## Common Next.js + Vercel Patterns

### For Marketing Sites
- Maximize SSG
- MDX for content
- ISR for blog posts
- Edge middleware for A/B testing

### For SaaS Apps
- Auth.js for authentication
- Server Actions for mutations
- Protected routes with middleware
- Vercel Postgres for data

### For E-commerce
- Product pages with ISR
- Shopping cart in client state
- Checkout with Server Actions
- Stripe integration

### For Blogs
- MDX for content
- generateStaticParams for posts
- RSS feed generation
- Search with FlexSearch

## Sub-task Spawning

When spawning research sub-tasks for Next.js projects:

1. **Template Analysis**:
   ```
   Analyze the Next.js template structure at app/ and identify:
   - Pre-configured features
   - Existing components
   - Styling setup
   - Font configuration
   ```

2. **Architecture Consultation**:
   ```
   Use nextjs-vercel-architect agent to validate:
   - Data fetching strategy for [specific pages]
   - Component architecture for [features]
   - Deployment optimizations for [use case]
   ```

3. **Pattern Research**:
   ```
   Find Next.js patterns for:
   - [specific feature]
   - Looking for App Router examples
   - Server Component implementations
   ```

## Success Indicators

A successful Next.js + Vercel plan will:

1. **Be Implementable**: Clear, actionable steps with no ambiguity
2. **Be Optimized**: Maximum use of static generation and caching
3. **Be Fast**: Performance targets defined and achievable
4. **Be Accessible**: WCAG compliance built-in from start
5. **Be SEO-Friendly**: Search optimization as core feature
6. **Be Maintainable**: Clear structure, typed, testable
7. **Be Cost-Effective**: Optimized for Vercel free tier when possible

Remember: This is a plan for a NEW project. Focus on best practices from the start, not migration concerns. Build it right the first time.

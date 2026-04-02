# Frontend Technology Stack Selection Matrix

When initializing or migrating a frontend project, you MUST evaluate the application type and enforce the corresponding technology stack without exception.

## 1. Type A: Hybrid / Highly Interactive SPA
- **Target Use Cases**: Back-office management systems, SaaS operational tools, authenticated dashboards, complex form handling.
- **Core Framework**: Vite + React SPA.
- **Routing**: Client-side routing using `react-router-dom`.
- **Data Fetching**: All API interactions must be encapsulated using `TanStack Query` (React Query) for caching and async state.
- **Deployment Criteria**: If deployed on IIS, the build output MUST include a `web.config` configured with URL Rewrite rules to support client-side routing.

## 2. Type B: Content-Driven / SEO-Critical Apps
- **Target Use Cases**: Public landing pages, news portals, e-commerce storefronts requiring Open Graph previews.
- **Core Framework**: Next.js (App Router architecture).
- **Data Fetching**: Prioritize Server Components (RSC) for data fetching to ensure critical keywords and meta tags are rendered in HTML before reaching the client.
- **Deployment Criteria**: Must be deployed in a Node.js runtime environment (e.g., Azure App Service on Linux).

## 3. Mandatory Common Infrastructure
Regardless of the chosen architecture (Type A or Type B), the following standards apply universally:
- **Language**: TypeScript with `strict` mode enabled.
- **Styling**: Tailwind CSS v4.
- **UI Components**: `shadcn/ui` (built on top of Radix UI primitives).
- **State Management**: `Zustand` must be used for any cross-component UI state management.
- **Performance**: 
  - All images must be processed and served in `WebP` format.
  - Strict implementation of Lazy Loading for below-the-fold assets and heavy components.

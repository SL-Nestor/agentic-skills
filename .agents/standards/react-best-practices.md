# React & Next.js Best Practices (Vercel Engineering Standards)

This standard is derived from Vercel's performance optimization guidelines. All React/Next.js development within this SSDLC MUST adhere to these rules.

## 1. Eliminating Waterfalls (CRITICAL)
- **Parallel Requests**: Use `Promise.all()` for independent operations.
- **Cheap Conditions First**: Check sync conditions before awaiting remote values.
- **Defer Await**: Move `await` into specific branches where the data is actually needed.
- **Suspense Streaming**: Use Suspense boundaries to stream slow content.

## 2. Bundle Size Optimization (CRITICAL)
- **No Barrel Imports**: Import directly from the source file, avoid `index.ts` barrel files.
- **Dynamic Loading**: Use `next/dynamic` for heavy client-side components.
- **Conditional Loading**: Only load heavy modules when the feature is active.

## 3. Server-Side Performance (HIGH)
- **Action Security**: Authenticate and validate Server Actions exactly like API routes.
- **Request Memoization**: Use `React.cache()` for per-request data deduplication.
- **Minimal Serialization**: Minimize the amount of data passed from Server Components to Client Components.
- **Hoist Static I/O**: Hoist font/logo loading to the module level.

## 4. Re-render Optimization (MEDIUM)
- **Functional setState**: Use `setState(prev => ...)` for stable callbacks.
- **Primitive Dependencies**: Use primitive values in `useEffect` dependency arrays.
- **Memoization**: Extract expensive work into memoized components, but avoid memo for simple primitives.
- **Lazy Init**: Pass an initializer function to `useState` for expensive calculations.

## 5. Rendering Performance (MEDIUM)
- **Safe Conditionals**: Use ternary `condition ? <A /> : null` instead of `condition && <A />` to avoid inadvertent `0` rendering.
- **Hoisting JSX**: Extract static JSX elements outside the component function.
- **Content Visibility**: Use `content-visibility` for long lists to optimize mounting time.

## 6. JavaScript Performance (LOW-MEDIUM)
- **Early Exits**: Return early from functions to reduce nesting and improve readability.
- **O(1) Lookups**: Use `Map` or `Set` for repeated lookups instead of array searching.
- **Iteration Optimization**: Combine multiple `.filter().map()` into a single loop or pass where possible.

---
*Derived from: https://github.com/vercel-labs/agent-skills*

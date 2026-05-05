---
name: ssdlc-threat-modeling
description: "Use this skill during SSDLC Phase 1 when performing threat modeling for .NET applications. Covers STRIDE methodology, threat identification for ASP.NET Core Web API, EF Core, Blazor, and Azure services, input validation rules, and actionable Dev Tasks generation."
---

# SSDLC Threat Modeling Skill

## When to Use
Activate during Phase 1 of the SSDLC workflow when reading specs/design artifacts and producing `docs/security/Threat_Model.md`.

## STRIDE Methodology

For each component identified in `design.md`, systematically evaluate all 6 STRIDE categories:

| Threat | Question | .NET Mitigation |
|--------|----------|-----------------|
| **S**poofing | Can an attacker pretend to be another user/service? | ASP.NET Identity, JWT Bearer, Azure AD B2C, mTLS |
| **T**ampering | Can data be modified in transit or at rest? | HTTPS enforcement, anti-forgery tokens, EF Core concurrency tokens, Azure Key Vault |
| **R**epudiation | Can a user deny performing an action? | Structured audit logging via `ILogger<T>`, Application Insights, immutable audit tables |
| **I**nformation Disclosure | Can sensitive data leak? | Data Protection API, column-level encryption, `[PersonalData]` attribute, response filtering |
| **D**enial of Service | Can the system be overwhelmed? | Rate limiting middleware, Azure Front Door, circuit breakers (Polly), request size limits |
| **E**levation of Privilege | Can a user gain unauthorized access? | Policy-based authorization, resource-based auth, minimal claim sets, role separation |

## Threat Catalog by Technology

### ASP.NET Core Web API

```
THREAT: Missing authentication on internal endpoints
VECTOR: Attacker discovers /api/admin/users without [Authorize]
MITIGATION: Apply global AuthorizationPolicy as fallback
CODE:
  builder.Services.AddAuthorizationBuilder()
      .SetFallbackPolicy(new AuthorizationPolicyBuilder()
          .RequireAuthenticatedUser()
          .Build());

THREAT: Mass assignment via over-posting
VECTOR: Client sends extra JSON fields that bind to sensitive properties
MITIGATION: Use dedicated request records, never bind to entities directly
CODE:
  // WRONG: public async Task<IActionResult> Update([FromBody] UserEntity user)
  // RIGHT:
  public record UpdateUserRequest(string DisplayName, string Email);
  public async Task<IActionResult> Update([FromBody] UpdateUserRequest request)

THREAT: Excessive data exposure in API responses
VECTOR: Entity with navigation properties serialized directly, leaking related data
MITIGATION: Always map to response DTOs, use [JsonIgnore] as a safety net
PITFALL: System.Text.Json serializes all public properties by default including EF navigation properties

THREAT: Missing CORS restriction
VECTOR: Malicious site makes authenticated requests to your API
MITIGATION: Explicit origin allowlist, never AllowAnyOrigin() with AllowCredentials()

THREAT: Insecure deserialization
VECTOR: Polymorphic JSON deserialization allows arbitrary type instantiation
MITIGATION: Use System.Text.Json with JsonSerializerOptions.RespectNullableAnnotations = true
           Never use TypeNameHandling in Newtonsoft.Json
```

### EF Core Data Access

```
THREAT: SQL Injection via raw queries
VECTOR: String interpolation in FromSqlRaw()
MITIGATION: Always use FromSqlInterpolated() or parameterized queries
CODE:
  // WRONG: context.Users.FromSqlRaw($"SELECT * FROM Users WHERE Name = '{name}'")
  // RIGHT: context.Users.FromSqlInterpolated($"SELECT * FROM Users WHERE Name = {name}")

THREAT: Unintended cascade deletes
VECTOR: DeleteBehavior.Cascade removes child records without audit trail
MITIGATION: Use DeleteBehavior.Restrict, implement soft-delete pattern
CODE:
  modelBuilder.Entity<Order>()
      .HasOne(o => o.Customer)
      .WithMany(c => c.Orders)
      .OnDelete(DeleteBehavior.Restrict);

THREAT: Sensitive data in migration history
VECTOR: Seed data with passwords/secrets stored in migration files committed to Git
MITIGATION: Never seed sensitive data in migrations, use environment-specific data seeding

THREAT: Connection string exposure
VECTOR: Connection string with password in appsettings.json committed to repo
MITIGATION: Use Azure Managed Identity (no password), or User Secrets in dev, Key Vault in prod
CODE:
  // Managed Identity — no connection string password
  builder.Services.AddDbContext<AppDbContext>(options =>
      options.UseSqlServer(connectionString, sql =>
          sql.UseAzureSqlDefaults()));  // .NET 9+ enables retry + managed identity

THREAT: N+1 query information timing attack
VECTOR: Attacker probes endpoints to infer data existence via response time differences
MITIGATION: Consistent response times, use .AsSplitQuery() for complex includes
```

### Blazor (Server / WASM)

```
THREAT: WASM client-side tampering
VECTOR: All Blazor WASM code runs on the client; attacker modifies authorization logic
MITIGATION: NEVER trust client-side authorization. Always re-validate on the API server.
PITFALL: <AuthorizeView> in WASM is UX-only, not security. The API must enforce authorization.

THREAT: SignalR connection hijacking (Blazor Server)
VECTOR: Attacker reuses or forges SignalR connection token
MITIGATION: Enable authentication on the Hub, validate user on each circuit

THREAT: Cross-site scripting via MarkupString
VECTOR: Rendering user input with (MarkupString)userContent bypasses Blazor's auto-encoding
MITIGATION: Never use MarkupString with user-controlled input. Use Blazor's default rendering.
CODE:
  // WRONG: @((MarkupString)userComment)
  // RIGHT: @userComment  — Blazor auto-encodes by default

THREAT: Excessive state in Blazor Server circuits
VECTOR: Sensitive data stored in circuit state accessible if connection is intercepted
MITIGATION: Store minimal state, encrypt sensitive circuit data, implement circuit timeout
```

### Azure Services

```
THREAT: Over-permissioned Managed Identity
VECTOR: App Service identity has Contributor on entire resource group
MITIGATION: Least-privilege RBAC, scope to specific resources
PRINCIPLE: One Managed Identity per service, one role assignment per resource

THREAT: Service Bus message poisoning
VECTOR: Malicious messages cause repeated processing failures filling dead-letter queue
MITIGATION: Schema validation on receive, max delivery count with dead-letter monitoring
CODE:
  // Validate message schema before processing
  if (!message.TryDeserialize<OrderCommand>(out var command, out var errors))
  {
      await args.DeadLetterMessageAsync(args.Message, "InvalidSchema", string.Join("; ", errors));
      return;
  }

THREAT: Azure Function anonymous trigger abuse
VECTOR: HTTP-triggered Function with AuthorizationLevel.Anonymous exposed to internet
MITIGATION: Use AuthorizationLevel.Function minimum, prefer API Management or Azure AD auth

THREAT: Key Vault secret caching stale
VECTOR: Rotated secret not picked up because app caches indefinitely
MITIGATION: Use Azure.Extensions.AspNetCore.Configuration.Secrets with reload interval
CODE:
  builder.Configuration.AddAzureKeyVault(
      new Uri(vaultUri),
      new DefaultAzureCredential(),
      new AzureKeyVaultConfigurationOptions { ReloadInterval = TimeSpan.FromMinutes(5) });
```

## Input Validation Rules Template

For each endpoint/handler identified in specs:

```markdown
| Field | Type | Required | Min | Max | Pattern | Sanitize | Threat |
|-------|------|----------|-----|-----|---------|----------|--------|
| email | string | yes | 5 | 254 | RFC 5322 | trim, lowercase | Spoofing |
| amount | decimal | yes | 0.01 | 999999.99 | — | — | Tampering |
| searchQuery | string | no | — | 100 | — | HTML encode | XSS |
```

Always implement validation at two layers:
1. **FluentValidation** in Application layer (business rules)
2. **Data Annotations** on request records (structural validation)

## Output: Threat_Model.md Structure

```markdown
# Threat Model — {Feature Name}

## Scope
- Components: [from design.md]
- Data flows: [from specs/]
- Trust boundaries: [API ↔ Client, API ↔ Database, API ↔ Azure Services]

## STRIDE Analysis
### Component: {Name}
| ID | Threat | Category | Severity | Mitigation | Dev Task |
|----|--------|----------|----------|------------|----------|
| T-001 | ... | Spoofing | High | ... | Implement JWT validation |

## Input Validation Matrix
[Table as above]

## Dev Tasks (merge with OpenSpec tasks.md)
- [ ] T-001: Implement JWT Bearer authentication
- [ ] T-002: Add FluentValidation for all request DTOs
- [ ] ...
```

## Common Pitfalls

1. **Threat modeling after implementation** — Always model BEFORE writing code. Retrofitting is 10x more expensive.
2. **Only modeling happy paths** — Explicitly model error responses, timeout paths, retry behavior.
3. **Ignoring infrastructure threats** — Include deployment targets (App Service config, network rules) in scope.
4. **Missing trust boundaries** — Every process-to-process communication crosses a trust boundary, even internal services.
5. **Severity without context** — Rate severity by business impact (data loss, compliance violation, revenue impact), not just technical exploitability.

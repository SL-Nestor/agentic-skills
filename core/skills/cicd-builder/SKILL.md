---
name: cicd-builder
description: "DevOps 工程師：產出安全、環境隔離的 CI/CD pipeline（GitHub Actions / GitLab CI）。在 Security Gate PASS 後執行，支援 .NET API + React/Next.js 全端專案，涵蓋 Test、Build、Security Scan、Deploy 完整流程，並強制要求 Production 部署的手動核准閘口。"
metadata:
  pattern: generator
  domain: devops
---

# DevOps 工程師 (CI/CD Pipeline Builder)

## 🎯 角色定義

你是 Release Engineering 專家。你在 **Security Gate PASS** 後才開始工作。

⚠️ **前置條件**：在產出任何 pipeline 之前，必須先讀取 `AGENT_HANDOFF.md` 確認 Phase 4 (Security Gate) 狀態為 `✅ Pass`。如果是 `❌ Fail`，立即停止並通知使用者。

---

## 📋 工作流程

### Step 1：偵測專案結構

讀取專案根目錄，識別以下資訊：

```
□ 後端類型：ASP.NET Core Web API / Minimal API / gRPC
□ 前端類型：Vite + React (Type A) / Next.js (Type B) / 無前端
□ 測試框架：MSTest / xUnit / NUnit
□ 部署目標：Azure App Service / Azure Container Apps / Docker / K8s
□ CI 平台：GitHub Actions / GitLab CI
□ 容器化：是否有 Dockerfile
```

### Step 2：產出對應的 Pipeline

---

## 📄 Pipeline 範本

### GitHub Actions — .NET API + React/Next.js 全端

```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  DOTNET_VERSION: '9.0.x'
  NODE_VERSION: '22.x'
  AZURE_WEBAPP_NAME: ${{ vars.AZURE_WEBAPP_NAME }}

jobs:
  # ─────────────────────────────────────────
  # Stage 1: Test (並行執行前後端測試)
  # ─────────────────────────────────────────
  test-backend:
    name: 🧪 Backend Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Restore dependencies
        run: dotnet restore

      - name: Build
        run: dotnet build --no-restore -c Release

      - name: Run Tests with Coverage
        run: |
          dotnet test --no-build -c Release \
            --collect:"XPlat Code Coverage" \
            --results-directory ./coverage \
            --logger "trx;LogFileName=results.trx"

      - name: Upload Coverage Report
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: coverage/

      - name: Enforce Coverage Threshold
        run: |
          # 最低測試覆蓋率 80%，低於此值 pipeline 失敗
          dotnet tool install -g dotnet-reportgenerator-globaltool
          reportgenerator -reports:coverage/**/*.xml \
            -targetdir:coverage/report \
            -reporttypes:"Html;Cobertura" \
            -thresholds:"linecoverage:80;branchcoverage:70"

  test-frontend:
    name: 🧪 Frontend Tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: src/Frontend/package-lock.json

      - name: Install dependencies
        working-directory: src/Frontend
        run: npm ci

      - name: Run Vitest
        working-directory: src/Frontend
        run: npm run test:coverage

  # ─────────────────────────────────────────
  # Stage 2: Security Scan
  # ─────────────────────────────────────────
  security-scan:
    name: 🔒 Security Scan
    runs-on: ubuntu-latest
    needs: [test-backend, test-frontend]
    steps:
      - uses: actions/checkout@v4

      - name: .NET Dependency Vulnerability Scan
        run: |
          dotnet restore
          dotnet list package --vulnerable --include-transitive 2>&1 | \
            tee vulnerability-report.txt
          # 如果發現嚴重漏洞，pipeline 失敗
          if grep -q "Critical\|High" vulnerability-report.txt; then
            echo "❌ Critical/High vulnerabilities found. Blocking deployment."
            cat vulnerability-report.txt
            exit 1
          fi

      - name: npm Audit
        working-directory: src/Frontend
        run: npm audit --audit-level=high

      - name: Secret Scanning (Gitleaks)
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  # ─────────────────────────────────────────
  # Stage 3: Build
  # ─────────────────────────────────────────
  build:
    name: 🏗️ Build
    runs-on: ubuntu-latest
    needs: [security-scan]
    outputs:
      image-tag: ${{ steps.meta.outputs.tags }}
    steps:
      - uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: src/Frontend/package-lock.json

      - name: Build Frontend
        working-directory: src/Frontend
        run: |
          npm ci
          npm run build

      - name: Publish Backend
        run: |
          dotnet publish src/Backend -c Release \
            -o ./publish \
            --no-restore

      - name: Upload Build Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-publish
          path: ./publish
          retention-days: 5

  # ─────────────────────────────────────────
  # Stage 4: Deploy to Staging
  # ─────────────────────────────────────────
  deploy-staging:
    name: 🚀 Deploy → Staging
    runs-on: ubuntu-latest
    needs: [build]
    environment: staging
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    steps:
      - name: Download Build Artifact
        uses: actions/download-artifact@v4
        with:
          name: app-publish
          path: ./publish

      - name: Deploy to Azure App Service (Staging)
        uses: azure/webapps-deploy@v3
        with:
          app-name: ${{ env.AZURE_WEBAPP_NAME }}
          slot-name: staging
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE_STAGING }}
          package: ./publish

      - name: Run Smoke Tests on Staging
        run: |
          # 部署後執行基本健康檢查
          STAGING_URL="https://${{ env.AZURE_WEBAPP_NAME }}-staging.azurewebsites.net"
          echo "Checking $STAGING_URL/health..."
          for i in {1..5}; do
            STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$STAGING_URL/health")
            if [ "$STATUS" = "200" ]; then
              echo "✅ Health check passed"
              exit 0
            fi
            echo "Attempt $i failed (status: $STATUS), retrying in 10s..."
            sleep 10
          done
          echo "❌ Staging health check failed after 5 attempts"
          exit 1

  # ─────────────────────────────────────────
  # Stage 5: Deploy to Production (需要手動核准)
  # ─────────────────────────────────────────
  deploy-production:
    name: 🏭 Deploy → Production
    runs-on: ubuntu-latest
    needs: [deploy-staging]
    environment: production   # ⚠️ 這個 environment 必須在 GitHub 設定中配置 required reviewers
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Download Build Artifact
        uses: actions/download-artifact@v4
        with:
          name: app-publish
          path: ./publish

      - name: Deploy to Azure App Service (Production)
        uses: azure/webapps-deploy@v3
        with:
          app-name: ${{ env.AZURE_WEBAPP_NAME }}
          slot-name: production
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE_PROD }}
          package: ./publish

      - name: Post-Deployment Verification
        run: |
          PROD_URL="https://${{ env.AZURE_WEBAPP_NAME }}.azurewebsites.net"
          STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$PROD_URL/health")
          if [ "$STATUS" != "200" ]; then
            echo "❌ Production health check failed. Consider rollback."
            exit 1
          fi
          echo "✅ Production deployment verified"
```

---

### GitLab CI — 同等功能版本

```yaml
# .gitlab-ci.yml
stages:
  - test
  - security
  - build
  - deploy-staging
  - deploy-production

variables:
  DOTNET_VERSION: "9.0"

test:backend:
  stage: test
  image: mcr.microsoft.com/dotnet/sdk:9.0
  script:
    - dotnet restore
    - dotnet build -c Release
    - dotnet test -c Release --collect:"XPlat Code Coverage"
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/**/*.xml

test:frontend:
  stage: test
  image: node:22-alpine
  script:
    - cd src/Frontend && npm ci && npm run test:coverage

security:scan:
  stage: security
  script:
    - dotnet list package --vulnerable --include-transitive
    - cd src/Frontend && npm audit --audit-level=high
  needs: [test:backend, test:frontend]

build:
  stage: build
  image: mcr.microsoft.com/dotnet/sdk:9.0
  script:
    - dotnet publish src/Backend -c Release -o ./publish
  artifacts:
    paths:
      - ./publish
  needs: [security:scan]

deploy:staging:
  stage: deploy-staging
  environment:
    name: staging
    url: https://your-app-staging.azurewebsites.net
  script:
    - az webapp deploy --resource-group $AZURE_RG --name $AZURE_APP_NAME --src-path ./publish
  needs: [build]
  rules:
    - if: $CI_COMMIT_BRANCH == "develop" || $CI_COMMIT_BRANCH == "main"

deploy:production:
  stage: deploy-production
  environment:
    name: production
    url: https://your-app.azurewebsites.net
  when: manual    # ⚠️ 必須手動觸發
  script:
    - az webapp deploy --resource-group $AZURE_RG --name $AZURE_APP_NAME-prod --src-path ./publish
  needs: [deploy:staging]
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

---

## 🔑 Secrets 清單

產出 pipeline 後，必須向使用者提供以下清單，說明需要在 Repo Settings 中設定哪些 Secrets：

```markdown
## 需要在 GitHub/GitLab 設定的 Secrets

### GitHub Repository Secrets
| Secret Name | 說明 | 如何取得 |
|-------------|------|---------|
| AZURE_WEBAPP_PUBLISH_PROFILE_STAGING | Staging 部署憑證 | Azure Portal → App Service → Get publish profile |
| AZURE_WEBAPP_PUBLISH_PROFILE_PROD | Production 部署憑證 | Azure Portal → App Service → Get publish profile |

### GitHub Repository Variables（非機密，可公開）
| Variable Name | 說明 | 範例值 |
|---------------|------|--------|
| AZURE_WEBAPP_NAME | Azure Web App 名稱 | my-app-name |

### GitHub Environments 設定（重要！）
1. 前往 Settings → Environments
2. 建立 "staging" environment（不需要 required reviewers）
3. 建立 "production" environment → 新增 Required Reviewers（至少 1 人）
   這樣 Production 部署才會等待人工核准。
```

---

## 🛡️ 安全要求（強制）

**[AI DIRECTIVE]** 以下規則在任何情況下都不得妥協：

1. **絕對禁止**在 pipeline YAML 中 hardcode 任何機密值
2. Production 部署**必須**有 `environment: production` 並在 GitHub 設定 Required Reviewers，或 `when: manual`
3. **必須**包含 Security Scan stage（Dependency vulnerability + Secret scanning）
4. **必須**包含 Coverage Threshold 強制要求（Backend: 80%, Frontend: 70%）
5. **必須**包含 Post-deployment Health Check

---

## 📊 更新 AGENT_HANDOFF.md

完成後更新：
1. Phase 5 狀態改為 `✅ Pass`
2. 在 Artifacts Registry 登記 pipeline 文件路徑
3. 將 `next_agent` 改為 `team-coordinator`（進行最終歸檔）

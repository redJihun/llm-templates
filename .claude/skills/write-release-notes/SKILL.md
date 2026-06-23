---
name: write-release-notes
description: Use when preparing a release and needing to write release notes. Triggered when creating a GitHub Release, tagging a version, or asked to summarize changes since the last release. Compares current state with previous git tag to generate Release title and Release notes. If the project has PRD and BACKLOG documents, uses PRD-aware mode to organize by milestone phases and carry forward unfinished items.
---

# Write Release Notes

## Overview

Generate release title and release notes by comparing the current state with the previous release tag. Two modes available:

- **Git-only mode**: Analyzes git commit history by conventional commit type (`feat/fix/refactor`). Use when no PRD/BACKLOG docs exist.
- **PRD-aware mode**: Organizes by PRD milestone phases (P0/P1/P2), cross-references BACKLOG for carry-forward items, includes project statistics. Use when PRD and BACKLOG docs exist.

## Mode Selection

Does the project have `PRD.md` (or equivalent) and `BACKLOG.md`?
- **Yes** → Follow Steps 1–2 (git), then Steps 6–10 (PRD-aware template)
- **No** → Follow Steps 1–5 (git-only template)

## Steps

### 1. Identify Previous Release

```bash
# Most recent tag
git describe --tags --abbrev=0

# All recent tags for context
git tag --sort=-creatordate | head -5

# Current version (if using hatch-vcs or setuptools-scm)
git describe --tags
```

### 2. Gather Commits Since Last Release

```bash
PREV_TAG=$(git describe --tags --abbrev=0)

# One-line summary (for scanning)
git log ${PREV_TAG}..HEAD --oneline --no-merges

# Subject only (for processing)
git log ${PREV_TAG}..HEAD --pretty=format:"%s" --no-merges

# Full detail with author/date
git log ${PREV_TAG}..HEAD --pretty=format:"%h %s (%an, %ad)" --date=short --no-merges
```

### 3. Categorize Commits

Group commits by conventional commit type prefix:

| Prefix | Section |
|--------|---------|
| `feat` | 새 기능 (Features) |
| `fix` | 버그 수정 (Bug Fixes) |
| `refactor` | 코드 개선 (Improvements) |
| `perf` | 성능 개선 (Performance) |
| `test` | 테스트 (Tests) |
| `docs` | 문서 (Documentation) |
| `chore`, `ci`, `build` | 기타 (Other) |

Commits without a prefix: place in most relevant section based on content.

### 4. Write Release Title

Format: `v{version} - {main feature or theme}`

Rules:
- Extract the **dominant change** (most impactful `feat` or theme)
- Keep to 50 characters or fewer after the version prefix
- Use Korean for description if commits are in Korean

Examples:
```
v1.0.0 - MTR 칩 발급 서버 초기 릴리즈
v1.1.0 - 권한 관리 및 사용자 인증 개선
v1.2.0 - 발급 성능 최적화 및 버그 수정
```

### 5. Write Release Notes

Use this template:

```markdown
## 변경 사항 요약
{2-3 sentences describing the overall theme of this release}

---

### 새 기능 (Features)
- {feat commit subject without type prefix}
- ...

### 버그 수정 (Bug Fixes)
- {fix commit subject without type prefix}
- ...

### 코드 개선 (Improvements)
- {refactor/perf commit subjects}
- ...

### 기타 (Chore / CI / Docs)
- {chore/ci/docs commits}
- ...

---

## 데이터베이스 버전 (선택 사항)
현재 Alembic 마이그레이션 상태를 포함하려면:

| SW 버전 | Alembic Revision | 설명 |
|---------|-----------------|------|
| v1.0.0 | 365f9c393d8d | ISSUANCE v1.0.0 스키마 |

```bash
alembic upgrade head   # 최신으로 업그레이드
alembic current        # 현재 revision 확인
```
```

## Quick Reference

| Task | Command |
|------|---------|
| Previous tag | `git describe --tags --abbrev=0` |
| Commits since tag | `git log <tag>..HEAD --oneline --no-merges` |
| Count of commits | `git log <tag>..HEAD --oneline --no-merges \| wc -l` |
| Files changed | `git diff --stat <tag>..HEAD` |

---

## PRD-Aware Mode (Steps 6–10)

Use when the project has milestone-based PRD and BACKLOG documents.

### 6. Read PRD Milestone Structure

Find which phases/milestones are in scope for this release:

```
- PRD §scope or §milestones → phase names (e.g., P0 긴급수정, P1 핵심업무, P2 운영고도화)
- PRD §requirements → feature IDs mapped to phases (FR-P0-xx, FR-P1-xx, FR-P2-xx)
- PRD §schedule → current milestone completion status
```

### 7. Read BACKLOG for Carry-Forward Items

```
- BACKLOG §현재 마일스톤 → items NOT completed this release (이월 대상)
- BACKLOG §기술부채 → known limitations to mention in release notes
- Filter: only items originally planned for this milestone
```

### 8. Map Commits to PRD Feature IDs

Cross-reference git commits with PRD feature IDs:
- Commits mentioning FR-P1-xx → belongs to P1 section
- Commits without FR-ID → infer phase from scope keyword (auth/dashboard/machine/etc.)
- Infrastructure commits (Alembic, Docker, uv) → separate "인프라 및 도구" section

### 9. Collect Statistics

```bash
# BE commits since last tag
git log ${PREV_TAG}..HEAD --oneline --no-merges | wc -l

# Alembic migration count
ls alembic/versions/*.py | wc -l
alembic current   # latest revision

# API endpoint count (FastAPI)
grep -r "^@router\." issuance_be_fastapi/routers/ | wc -l
```

For FE repo: check parallel git log if applicable.

Additional stats to include (read from models/routers):
- Table count (SQLAlchemy models)
- Active router count
- Endpoint breakdown by domain

### 10. Write PRD-Aware Release Notes

Use this template:

```markdown
# Release Notes — v{version} ({마일스톤 이름})

> **릴리즈 일자**: {YYYY-MM-DD} (예정)
> **이전 버전**: v{prev}
> **범위**: {PRD phase names and brief description}

---

## 주요 변경사항

### {P0 phase name}: {subtitle}

- **{기능명}** — {설명} (`{commit hash}`)
- ...

### {P1 phase name}: {subtitle}

- **{기능명}** — {설명} (`{commit hash}`)
- ...

### {P2 phase name}: {subtitle}

- **{기능명}** — {설명} (`{commit hash}`)
- ...

### 인프라 및 도구

- **{항목}** — {설명} (`{commit hash}`)

---

## 미완료 항목 ({다음 마일스톤} 이월)

| 항목 | 사유 | 이월 시점 |
|------|------|----------|
| {BACKLOG 미완료 항목} | {사유} | {예상 시점} |

## 알려진 제한사항

- {BACKLOG 기술부채에서 추출}

---

## 통계

- **BE 커밋**: {N}개
- **FE 커밋**: {N}개 (해당 시)
- **테이블**: {N}개 + VIEW {N}개
- **API 라우터**: 활성 {N}개
- **API 엔드포인트**: 약 {N}개 ({domain} {N} + ...)
- **Alembic 마이그레이션**: {N} revisions

---

## 다음 단계

{다음 마일스톤 이름} ({기간}, ~{날짜}):
- {MS-xx}: {설명}
- {MS-xx}: {설명}
```

---

## Common Mistakes

- **Including merge commits** — always use `--no-merges`
- **Copying raw commit subjects verbatim** — remove the `type(scope):` prefix for readability
- **Omitting DB version** — include Alembic revision when schema changed
- **Generic title** — "v1.1.0 - Various improvements" is not useful; name the dominant feature
- **[PRD mode] Skipping BACKLOG cross-check** — always list carry-forward items explicitly; omitting them makes the release notes misleading
- **[PRD mode] Using commit-type sections** — PRD-aware mode organizes by milestone phase, NOT by `feat/fix/refactor`
- **[PRD mode] Omitting statistics** — endpoint counts and migration stats are part of the PRD-aware template

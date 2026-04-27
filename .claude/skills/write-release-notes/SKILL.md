---
name: write-release-notes
description: Use when preparing a release and needing to write release notes. Triggered when creating a GitHub Release, tagging a version, or asked to summarize changes since the last release. Compares current state with previous git tag to generate Release title and Release notes.
---

# Write Release Notes

## Overview

Generate release title and release notes by comparing the current state with the previous release tag. Analyzes git commit history, categorizes changes, and produces formatted output ready to paste into GitHub Releases.

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

## Common Mistakes

- **Including merge commits** — always use `--no-merges`
- **Copying raw commit subjects verbatim** — remove the `type(scope):` prefix for readability
- **Omitting DB version** — include Alembic revision when schema changed
- **Generic title** — "v1.1.0 - Various improvements" is not useful; name the dominant feature

---
name: squash-merge-suggest
description: 브랜치의 커밋 이력과 diff를 분석해 Squash Merge 커밋 메시지(패턴C)를 제안합니다 (머지 실행 안 함)
allowed-tools: ["Bash"]
model: sonnet
---

# /squash-merge-suggest — Squash Merge 커밋 메시지 제안

## 역할 정의

이 커맨드는 현재 작업 브랜치의 전체 커밋 이력과 변경 내용을 분석하여, **ADR-0001에 정의된 패턴C** 형식의 Squash Merge 커밋 메시지를 제안합니다.

절대 금지:
- `git merge` 실행
- `git commit` 실행
- `git push` 실행

허용:
- `git log` (읽기 전용)
- `git diff` (읽기 전용)
- `git branch` (읽기 전용)

---

## 입력 형식

```
$ARGUMENTS 파싱:
- 대상 브랜치 (선택, 기본값: master)
  예: /squash-merge-suggest          → 대상: master
  예: /squash-merge-suggest develop  → 대상: develop
```

$ARGUMENTS가 비어 있으면 `master`, 값이 있으면 해당 브랜치명을 대상 브랜치로 사용합니다.

---

## 수행 단계

### Step 1. 현재 브랜치 확인

```bash
git branch --show-current
```

### Step 2. 대상 브랜치와 공통 조상 기준으로 커밋 목록 수집

```bash
git log {target}..HEAD --oneline
git log {target}..HEAD --format="%s%n%b%n---"
```

- 커밋 수가 0이면 "현재 브랜치에 {target} 대비 새 커밋이 없습니다." 출력 후 종료
- 커밋 메시지들의 제목과 본문을 모두 수집

### Step 3. 변경 파일 통계 및 실제 diff 수집

```bash
git diff {target}...HEAD --stat
git diff {target}...HEAD
```

- diff가 너무 길면 (500줄 초과) `--stat` 결과와 커밋 메시지만으로 분석
- 변경된 파일 경로에서 scope 추론

### Step 4. 브랜치명에서 type/scope 추론

- 브랜치명 패턴: `feat/alerts-recent` → type: `Feat`, scope: `alerts` 또는 주요 변경 도메인
- 브랜치명보다 **실제 변경 내용을 우선시** (예: 실제로는 리팩토링이 주목적이면 `Refac`)

### Step 5. 패턴C 메시지 생성

수집한 정보(커밋 메시지 목록 + diff stat + 브랜치명)를 종합하여:

- **type**: 변경 목적 분류 (Feat/Fix/Docs/Refac/Chore/Test/Style)
  - 참고: [commit-message-suggest.md](commit-message-suggest.md)의 type 목록
- **scope**: 주요 변경 도메인 (변경 파일 경로에서 추론, 여러 도메인이면 핵심만)
- **한 줄 요약**: 브랜치 작업 전체를 대표하는 50자 이내 한국어 요약
- **변경 이유(Why)**: 커밋 메시지들에서 공통 목적/배경 추출 (왜 이 작업이 필요했는지)
- **Changes 목록**: 각 커밋 또는 파일 변경 단위로 요약 (3~5개 항목)

---

## 출력 형식

다음 형식으로 출력:

```
---
**Squash Merge 커밋 메시지 제안**

현재 브랜치: {branch}
대상 브랜치: {target}
포함 커밋: {N}개

**[제안 메시지]**
```
<type>(<scope>): <한 줄 요약>

<변경 이유 — 왜 이 작업이 필요했는지>

Changes:
- 세부 변경 항목 1
- 세부 변경 항목 2
- 세부 변경 항목 3

See also: docs/architecture-decision-records/0001-squash-merge-strategy.md
```

**선택 근거**
- **type 선정**: {이유}
- **scope 선정**: {이유}
- **Why 요약 근거**: {어떤 커밋 메시지/diff에서 추출했는지}
---

> 머지는 직접 실행하지 않습니다. 메시지를 복사해서 사용하세요.
```

---

## 완료 보고

메시지 제안 완료 후 다음 정보를 포함:

```
✓ Squash Merge 메시지 제안 완료
  현재 브랜치: {branch}
  대상 브랜치: {target}
  포함 커밋: {N}개

위의 [제안 메시지]를 복사해서 git merge 시 사용하세요.
```

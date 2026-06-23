---
name: update-prd
description: Use when new requirements, constraints, bugs, or stakeholder feedback need to be recorded in project definition documents (PRD.md and/or BACKLOG.md). Triggered by meeting feedback, bug reports, mid-project requests, or any "add this to the backlog" instruction.
---

# Update PRD / BACKLOG

## Overview

새 요구사항·제약·버그·피드백을 `PRD.md`와 `BACKLOG.md`에 일관된 형식으로 반영한다.
두 문서는 교차 참조 관계이므로 **항상 함께** 갱신 여부를 판단해야 한다.

## 대상 문서

| 문서 | 경로 | 역할 |
|------|------|------|
| PRD | `issuance-fastapi/docs/dev-notes/PRD.md` | 마일스톤별 기능 요구사항 상세 |
| BACKLOG | `issuance-fastapi/docs/work-logs/BACKLOG.md` | 장기 예정 업무 + 기술부채 목록 |

## Step 1: 입력 분류

새 항목을 다음 기준으로 분류한다.

### 항목 유형 판별

| 유형 | 예시 | 기록 위치 |
|------|------|-----------|
| 새 기능 요구사항 | "X 기능 추가해줘" | PRD + BACKLOG 모두 |
| 버그 리포트 | "Y 버튼 동작 안 함" | BACKLOG `추가된 요구사항` 섹션 |
| 기술부채 | "print() 제거", "deprecated API 교체" | BACKLOG `🔧 기술부채` 섹션 |
| 마일스톤 재구조화 | 일정 변경, 우선순위 조정 | PRD + BACKLOG 모두 |
| 이해관계자 피드백 | 중간보고 피드백, 싱크업 결과 | BACKLOG `추가된 요구사항` 섹션 + PRD 편입 여부 판단 |

### 긴급도 판별 → 마일스톤 배정

```
긴급도: 상 → 현재 진행 중 마일스톤(2차)에 편입 고려
긴급도: 중 → 3차 마일스톤으로 이관
긴급도: 하 → 3차 or Long-term으로 이관
```

## Step 2: 문서별 갱신 규칙

### BACKLOG.md 갱신

**`추가된 요구사항` 섹션** (날짜별 피드백·버그 기록):

```markdown
### YYYY-MM-DD {출처}(by. 이름 직급)

- 항목 설명 (중요도: 상/중/하, 긴급도: 상/중/하) → **PRD MS2-XX** (PRD 편입 시)
- [x] 완료된 항목
- 미완료 항목
```

**`🔧 기술부채` 섹션** (기술적 개선 사항):

```markdown
### [분류]

- **항목 제목**
  - 위치: `파일경로:라인`
  - 조치: 해야 할 내용
```

**마일스톤 섹션** (MS2-XX, MS3-XX):

```markdown
### MS2-0N: 항목 제목

- [ ] 세부 작업 항목
- [ ] 예상: N주
```

### PRD.md 갱신

**§5 (2차), §6 (3차), §7 (4차 이후)** 해당 마일스톤 섹션에 추가:

```markdown
#### FR-P{N}-{NN}: 요구사항 제목

- **배경**: 왜 필요한가
- **범위**: BE / FE / 양쪽
- [ ] 세부 구현 항목 1
- [ ] 세부 구현 항목 2
```

**FR- ID 채번 규칙:**
- 현재 마일스톤(2차): `FR-P2-` 접두사
- 기존 최대 번호 확인 후 +1

## Step 3: 날짜 갱신 노트 추가

항목 추가 후 해당 마일스톤 섹션 상단 `> 갱신` 블록에 오늘 날짜로 한 줄 추가:

```markdown
> **YYYY-MM-DD 갱신**: {추가된 내용 한 줄 요약}. {PRD 편입 여부 또는 이관 마일스톤}.
```

## Step 4: 교차 참조 확인

- BACKLOG에 항목 추가 시 → PRD에 편입 필요한지 판단, 필요하면 함께 갱신
- PRD에 항목 추가 시 → BACKLOG `추가된 요구사항`에 출처 기록
- 완료 처리 시 → 양쪽 모두 `[x]` 체크 또는 ~~취소선~~ 반영

## Quick Reference

| 상황 | 할 일 |
|------|-------|
| 버그 리포트 | BACKLOG `추가된 요구사항` 섹션에 날짜별 기록 |
| 이해관계자 피드백 | BACKLOG 기록 + PRD 편입 필요 시 FR- ID 채번 후 양쪽 갱신 |
| 새 기능 요구 | 마일스톤 배정 판단 → PRD 해당 §에 추가 → BACKLOG MS 섹션에 반영 |
| 기술부채 발견 | BACKLOG `🔧 기술부채 [분류]` 아래 추가 |
| 일정/마일스톤 변경 | PRD + BACKLOG 둘 다 일정 테이블·섹션 제목 갱신 |
| 항목 완료 처리 | 양쪽 `[ ]` → `[x]` 체크, 필요 시 ~~취소선~~ |

## Common Mistakes

- **BACKLOG만 수정하고 PRD 스킵** — 새 기능은 PRD에 FR- 항목도 추가해야 함
- **날짜 갱신 노트 누락** — 섹션 상단 `> **날짜 갱신**` 한 줄 항상 추가
- **교차 참조 표기 누락** — BACKLOG에서 `→ **PRD MS2-XX**` 없으면 추적 불가
- **FR- ID 중복** — 기존 최대 번호 먼저 확인 후 채번
- **긴급 항목을 Long-term에만 기록** — 긴급도 상이면 현재 마일스톤 편입 여부 반드시 검토
- **완료 체크를 한쪽만 반영** — PRD와 BACKLOG 양쪽 동시 체크

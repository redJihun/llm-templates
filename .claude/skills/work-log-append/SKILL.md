---
name: work-log-append
description: Use when wanting to record committed work into a weekly work log file. Triggered after a git commit (FE or BE), or when asked to append a work log entry. Finds the current week's log file automatically, formats an entry matching the existing log style, and appends it to the [작업 로그] section.
---

# Work Log Append

## Overview

Analyzes recent git commits and appends a formatted work log entry to the current week's work log file (`docs/work-logs/YYMMDD-YYMMDD-WXX.md`). Preserves the existing log format exactly.

## Log Entry Format

```
- {월}/{일}({요일}): {작업 내용 요약} ({저장소}); {추가 항목}
```

**요일 표기:** 월화수목금토일

**예시:**
```
- 5/4(월): MS2-03 v1.2(Profile/ChipFirmware/Script) BE+FE 완료 (`9aec7d9` BE, `2c7019e` FE)
- 5/4(월): MS2-04 리포팅 API 기본 구현 (`f7f9a8b` BE)
- 5/6(화): 프로필 버전 관리 UI를 ProfileDetail 페이지에 통합 (`ab1324f` FE)
```

## Steps

### 1. 작업 일지 파일 확인

인자로 파일 경로가 주어진 경우 해당 파일 사용. 없으면 자동 탐색:

```bash
# 현재 날짜 확인
date "+%y%m%d"

# 현재 주차 파일 찾기 (오늘 날짜가 범위에 포함되는 파일)
ls issuance-fastapi/docs/work-logs/ | grep -E "^[0-9]{6}-[0-9]{6}-W[0-9]+"
```

파일명 패턴: `YYMMDD-YYMMDD-WXX.md` (예: `260504-260508-W19.md`)
오늘 날짜(YYMMDD)가 파일명의 시작~끝 범위에 포함되는 파일을 선택.

### 2. 커밋 내용 수집

인자로 저장소 경로(`@경로` 또는 절대 경로)가 주어진 경우 해당 저장소만 분석. 없으면 BE+FE 모두 확인:

```bash
# 최근 커밋 확인 (해당 저장소에서)
cd {저장소경로}
git log --oneline -5

# staged 변경이 있는 경우 (커밋 전)
git diff --cached --stat
```

**저장소 레이블:**
- `issuance-fastapi/` → `BE`
- `re-issuance-machine-frontend/` → `FE`

### 3. 날짜 및 요일 계산

```bash
date "+%-m/%-d(%a)"
# 예: 5/6(Tue) → 5/6(화)
```

요일 영어→한국어 변환:
| 영어 | 한국어 |
|------|--------|
| Mon | 월 |
| Tue | 화 |
| Wed | 수 |
| Thu | 목 |
| Fri | 금 |

### 4. 로그 항목 작성

커밋 메시지를 바탕으로 한국어 작업 내용 요약 작성:
- 커밋 타입/스코프 제거하고 핵심 내용만 추출
- 커밋 1개 = 항목 1줄, 여러 커밋이면 날짜가 같아도 각각 별도 줄로 작성

**형식:**
```
- {월}/{일}({요일}): {내용} ({repo})
- {월}/{일}({요일}): {내용} ({repo})
```

### 5. 작업 일지에 추가

`**[작업 로그]**` 섹션을 찾아 마지막 로그 항목 다음에 추가:

```
**[작업 로그]**

> 위 작업 계획과 별개로 실제 작업한 내용을 간략한 로그로 기록
> 작업 계획 체크리스트와 이 기록을 바탕으로 완료된 업무 정리

- 5/4(월): 기존 항목 ...
- 5/6(화): 새로 추가된 항목 ...    ← 여기에 추가
```

같은 날짜 항목이 이미 있어도 새 줄로 추가. 날짜별 항목 수 제한 없음.

## Quick Reference

| 상황 | 처리 방법 |
|------|-----------|
| 인자로 파일 경로 있음 | 해당 파일 직접 사용 |
| 인자로 저장소 경로 있음 | 해당 저장소의 최근 커밋만 분석 |
| 인자 없음 | 현재 날짜로 파일 탐색, BE+FE 모두 분석 |
| 같은 날 항목 이미 있음 | 기존 항목 아래에 새 줄로 추가 |

## Common Mistakes

- **여러 커밋을 한 줄에 이어 쓰기** — 커밋 1개당 항목 1줄, 같은 날이라도 각각 별도 줄로 작성
- **커밋 타입 포함** — `Feat(profile): ...` → `프로필 버전 관리 UI ...`로 변환
- **섹션 밖에 추가** — 반드시 `**[작업 로그]**` 섹션의 기존 항목 아래에 추가
- **저장소 레이블 누락** — 뒤에 항상 `BE` 또는 `FE` 레이블 추가

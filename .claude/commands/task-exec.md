---
name: task-exec
description: TASK.md를 읽고 workflow.md 실행자 역할로 구현 수행
allowed-tools: ["Read", "Edit", "Write", "Bash", "Glob", "Grep", "Agent"]
model: haiku
---

# /task-exec — TASK.md 실행자 커맨드

## 역할 정의

당신은 workflow.md의 **실행자(Phase 2)** 역할입니다.

**금지 행동:**
- `git commit`, `git push` 절대 금지
- TASK.md에 명시되지 않은 파일 수정 금지
- 추가 설계나 임의 판단 금지 — TASK.md 지시 사항만 정확히 수행
- RESULT.md는 같은 디렉토리에만 생성

---

## 실행 절차

### 1단계: TASK 파일 읽기

`$ARGUMENTS`에 지정된 경로의 TASK.md를 읽습니다.
- 경로가 없으면 기본값 `temp/TASK.md` 사용
- 파일이 없으면 → "TASK.md를 찾을 수 없습니다: {경로}" 출력 후 종료

### 2단계: 수정 대상 파일 파악

TASK.md에서 다음 정보를 추출합니다:
- **수정 대상 파일 목록** (테이블 또는 경로 목록)
- **변경 내용** (구체적 코드 블록 또는 설명)
- **검증 기준** (체크리스트)

### 3단계: 대상 파일 전체 읽기 (병렬)

수정하기 전에 **모든 대상 파일을 먼저 Read 툴로 읽습니다.**
- Edit 툴을 사용하려면 사전 읽기가 필수
- 여러 파일이면 병렬 Read 수행

### 4단계: 구현

TASK.md에 명시된 변경 내용을 정확히 적용합니다:
- 코드 블록이 제공된 경우 해당 코드를 그대로 사용
- TASK.md의 지시 사항을 벗어나는 추가 수정 금지
- 기존 패턴(CLAUDE.md의 Key Patterns) 준수

### 5단계: RESULT.md 작성

TASK.md와 같은 디렉토리에 RESULT.md를 작성합니다.

**형식:**
```markdown
# RESULT: {TASK 제목}

## 완료 시각
{ISO 8601 형식 datetime}

## 수정된 파일
- path/to/file — {변경 요약}
- path/to/another — {변경 요약}

## 검증 기준 달성 여부
- [x] 항목1
- [x] 항목2
- [ ] 항목3 (미달성 이유: ...)

## 비고
{특이사항 또는 오류 — 없으면 생략}
```

**예시:**
```markdown
# RESULT: ISRN-84 최근 알림/에러 UI 개선

## 완료 시각
2026-03-25T14:32:15+09:00

## 수정된 파일
- src/pages/dashboard/DashboardRecentAlerts.tsx — Badge를 span으로 교체, 레이아웃 개선

## 검증 기준 달성 여부
- [x] INFO / WARN / ERROR 뱃지 색상 정상 표시
- [x] 메시지 텍스트가 뱃지에 가려지지 않음
- [x] 날짜/참조ID 분리 정렬
- [x] 항목 간 구분선 표시
```

### 5.5단계: work log 1줄 기록

RESULT.md 작성 완료 후, 가장 최신 work log에 작업 내용을 1줄 추가합니다.

**절차:**
1. Glob으로 `docs/work-logs/` 에서 `??????-??????-W*.md` 패턴 파일을 찾아 수정일 기준 가장 최근 파일을 선택합니다.
2. Grep으로 해당 파일에 `**[작업 로그]**` 섹션이 있는지 확인합니다.
3. 섹션이 없으면 이 단계를 건너뜁니다.
4. 섹션이 있으면, Edit 툴로 `- ...` 줄 바로 위에 1줄을 삽입합니다:
   ```
   - {TASK 제목 한 줄 요약} ({완료 시각 YYYY-MM-DD})
   ```

**예시:**
```
- ISRN-84 대시보드 알림 뱃지 색상 수정 (2026-03-30)
```

**주의:**
- `- ...` 줄이 없으면 `**[작업 로그]**` 섹션의 마지막 `-` 항목 아래에 추가합니다.
- 기존 내용은 수정하지 않습니다.
- work log 파일이 없으면 이 단계를 건너뜁니다.

### 6단계: 완료 보고

RESULT.md 작성 완료 후:
```
✓ RESULT.md 작성 완료
📂 위치: {RESULT.md 경로}

관리자에게 RESULT.md를 확인하도록 전달하고 추가 작업 없이 종료합니다.
```

---

## 특수 경우 처리

### FE 파일 경로
- 경로가 `../re-issuance-machine-frontend/` 등 상대경로면 그대로 따라갑니다.
- 프로젝트 경계를 벗어나도 괜찮습니다.

### 검증 단계
- 현재 버전: **구현만 수행**, 검증은 별도 수행
- BE: `/verify` 커맨드로 ruff + pytest 검사
- FE: 수동으로 eslint/prettier 실행 후 RESULT.md에 결과 기록

### TASK.md가 없는 경우
인라인 지시가 들어오는 경우:
```
/task-exec "DashboardRecentAlerts.tsx의 Badge를 span으로 교체하고 색상을 정의하세요"
```
→ 이 경우 RESULT.md는 `temp/RESULT.md`에 고정 생성

---

## 주의사항

1. **파일 읽기 필수** — Edit 사용 전 Read로 먼저 읽어야 함
2. **범위 준수** — TASK.md에 명시된 파일만 수정
3. **코드 정확성** — 지시된 코드 블록을 그대로 반영
4. **에러 처리** — 구현 중 에러 발생 시 RESULT.md의 "비고" 섹션에 기록
5. **Git 금지** — 커밋/푸시는 절대 실행하지 않음

---
description: 스테이징된 변경분을 읽어 커밋 메시지를 제안합니다 (커밋 실행 안 함)
allowed-tools: Bash
model: haiku
---

스테이징된 git 변경분을 분석해서 커밋 메시지 후보를 제안해줘.

## 수행 단계

1. `git diff --cached --stat` — 변경된 파일 목록 확인
2. `git diff --cached` — 실제 변경 내용 확인
3. `git log --oneline -5` — 이 프로젝트의 실제 커밋 스타일 확인

## 커밋 메시지 규칙 (이 프로젝트 컨벤션)

### 헤더 형식 (필수, 50자 이내)

```
<type>(<scope>): <한글 설명>
```

### type 목록

| type | 사용 시점 |
|------|-----------|
| `Feat` | 새로운 기능 추가 |
| `Fix` | 버그 수정 |
| `Docs` | 문서 수정만 (.md, .mdc 파일) |
| `Style` | 코드 포맷팅, 세미콜론 누락 등 동작 무관 변경 |
| `Refac` | 코드 리팩토링 (동작 변경 없음) |
| `Test` | 테스트 코드 추가/수정 |
| `Chore` | 빌드·패키지·설정 파일 수정 (requirements.txt, docker-compose 등) |

### scope 결정 기준

변경된 파일의 도메인/모듈 이름을 사용:
- `domain/board/crud/dashboard.py` → scope: `dashboard`
- `domain/board/crud/session.py` → scope: `sessions`
- `routers/workinfos.py` → scope: `workinfo`
- `.claude/commands/*.md`, `.cursor/rules/*.mdc` → scope: `chore` 또는 파일 주제
- 여러 도메인 동시 변경 → 가장 핵심 도메인 또는 상위 개념 사용

### 본문 (body) — 선택, 72자 줄바꿈

변경이 복잡하거나 이유 설명이 필요한 경우:
```
<type>(<scope>): <한 줄 요약>

<변경 이유 — 왜 이 작업이 필요했는지>

Changes:
- 세부 변경 항목 1
- 세부 변경 항목 2
```

### 작성 주의사항

- 헤더 끝에 마침표 없음
- 본문은 "무엇을" 보다 "왜" 위주로 작성
- `Fix` 단일 커밋은 본문 생략 가능
- `Docs` 타입은 `.mdc`(Cursor 규칙), `.md`(문서) 파일만 변경 시 사용
- `Chore` 타입은 `requirements.txt`, `docker-compose.yml`, `.env.example` 등 빌드·환경 설정 시 사용

## 출력 형식

스테이징된 변경이 없으면: "스테이징된 변경사항이 없습니다." 만 출력.

스테이징된 변경이 있으면 아래 형식으로 출력:

---
**커밋 메시지 제안**

**[1안]** (헤더만, 단순한 경우)
```
<type>(<scope>): <한글 설명>
```

**[2안]** (본문 포함, 변경이 복잡한 경우)
```
<type>(<scope>): <한글 설명>

<변경 이유>

Changes:
- 항목1
- 항목2
```

**선택 근거**: type 선정 이유 + scope 선정 이유 각 한 줄
---

> 커밋은 직접 실행하지 않습니다. 마음에 드는 메시지를 복사해서 사용하세요.

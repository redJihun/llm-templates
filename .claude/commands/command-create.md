---
name: command-gen
description: 새로운 Claude Code 커맨드를 일관된 포맷으로 생성
allowed-tools: ["Read", "Glob", "Write"]
model: sonnet
---

# /command-gen — 커맨드 생성 스킬

## 목적

사용자가 제공한 정보를 바탕으로 `.claude/commands/` 에 새 커맨드 파일을 생성한다.
기존 커맨드 패턴을 분석하여 일관된 포맷을 유지한다.

## 입력 형식

/command-gen name=<커맨드명> purpose=<목적> [model=haiku|sonnet] [tools=Tool1,Tool2,...]

| 파라미터 | 필수 | 설명 | 예시 |
|----------|------|------|------|
| `name` | ✓ | 커맨드 파일명 (kebab-case) | `name=db-check` |
| `purpose` | ✓ | 커맨드의 목적/역할 | `purpose=DB 연결 상태 점검` |
| `model` | - | 실행 모델 (기본값: haiku) | `model=sonnet` |
| `tools` | - | 허용 툴 목록 (기본값: Bash,Read) | `tools=Bash,Read,Write` |

파라미터 형식 없이 자연어로 입력해도 된다:
/command-gen DB 연결 상태를 점검하는 db-check 커맨드를 만들어줘

## 실행 절차

### 1. 입력 파싱

$ARGUMENTS 에서 다음을 추출한다:
- **name**: 커맨드 파일명 (없으면 목적에서 추론, kebab-case로 변환)
- **purpose**: 커맨드의 역할/목적
- **model**: `haiku` 또는 `sonnet` (기본값: `haiku`)
- **tools**: 허용 툴 배열 (기본값: `["Bash", "Read"]`)

**모델 자동 결정 기준** (명시 없을 때):
- `haiku`: bash 명령 나열, 검증 실행, boilerplate 생성, 문서 분석
- `sonnet`: 컨텍스트 분석, 코드 설계 판단, 다단계 의사결정 포함

### 2. 기존 커맨드 참조

목적과 가장 유사한 기존 커맨드 1개를 Read로 읽어 본문 구조를 참조한다:

| 목적 유형 | 참조 커맨드 |
|-----------|-----------|
| 코드 검증/점검 | `.claude/commands/verify.md` |
| 코드/파일 생성 | `.claude/commands/crud-gen.md` |
| 작업 계획/분석 | `.claude/commands/task-plan.md` |
| 배포/운영 점검 | `.claude/commands/deploy-check.md` |
| 메시지/문서 작성 | `.claude/commands/commit-message-suggest.md` |

목적이 불명확하거나 해당 없으면 참조 생략하고 구조 A 기본 사용.

### 3. 본문 구조 결정

목적에 따라 두 가지 구조 중 선택:

**구조 A (절차형)** — bash 명령 위주, `model: haiku` 적합:
```
# /{name} — {한 줄 설명}

## 목적
{목적 설명}

## 수행 단계

### 1. {단계명}
{bash 명령 또는 설명}

### 2. {단계명}
...

## 결과 정리
{출력 형식 예시}
```

**구조 B (역할정의형)** — 분석/판단 포함, `model: sonnet` 적합:
```
# /{name} — {한 줄 설명}

## 역할 정의

{역할 설명}

절대 금지:
- ...

허용:
- ...

## 실행 절차

### 1. {단계명}
...

## 완료 보고
{출력 형식 예시}
```

**구조 선택 기준**:
- `model: haiku` → 구조 A
- `model: sonnet` + 분석/판단 포함 → 구조 B

### 4. 커맨드 파일 생성

다음 frontmatter로 `.claude/commands/{name}.md` 를 Write 툴로 생성:

```yaml
---
name: {name}
description: {purpose를 한 줄로 요약한 한국어 설명}
allowed-tools: {tools JSON 배열}
model: {model}
---
```

이어서 결정한 구조(A 또는 B)로 본문을 작성한다.

**작성 품질 기준**:
- `$ARGUMENTS` 플레이스홀더를 사용자 입력 참조 지점에 반드시 사용
- bash 명령은 코드블록으로 감싸기
- 출력/결과 형식은 예시로 제시
- 모호한 표현 금지 ("처리한다" → "ruff check 실행 후 에러 라인을 나열한다")
- 파일 생성 전 `Glob(".claude/commands/{name}.md")` 로 중복 확인

### 5. 완료 보고

생성 완료 후 다음 형식으로 출력:

```
커맨드 생성 완료: .claude/commands/{name}.md
모델: {model}
허용 툴: {tools}
구조: {A(절차형) 또는 B(역할정의형)}
사용 방법: /{name} {입력 예시}
```

---

## 최종 예상 결과

`/command-gen name=db-check purpose=DB 연결 상태 점검` 실행 시:
- `.claude/commands/db-check.md` 가 생성된다
- frontmatter: `name`, `description`, `allowed-tools`, `model` 포함
- 본문: 절차형(구조 A) + bash 명령으로 작성됨
- 기존 커맨드와 동일한 포맷 유지

## 검증 기준

- [ ] `.claude/commands/command-gen.md` 파일이 생성됨
- [ ] frontmatter에 `name`, `description`, `allowed-tools`, `model` 4개 필드 존재
- [ ] `$ARGUMENTS` 플레이스홀더가 본문에 존재
- [ ] 입력 파라미터 표 (name/purpose/model/tools) 포함
- [ ] 구조 A / 구조 B 선택 기준이 명시됨
- [ ] 완료 보고 출력 형식이 명시됨
- [ ] 중복 확인(Glob) 단계 포함

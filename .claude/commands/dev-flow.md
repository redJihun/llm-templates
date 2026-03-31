---
name: dev-flow
description: 태스크 설명을 받아 하네스를 선택하고 설계→구현→검증 3단계 워크플로우를 실행하는 디스패처 커맨드
allowed-tools: ["Read", "Glob", "Grep", "Bash", "Write", "Agent"]
model: sonnet
---

# /dev-flow — 하네스 라우터 & 3단계 워크플로우 실행

## 역할 정의

당신은 `.claude/agents/dispatcher.md`의 **Dispatcher** 역할이다.
태스크를 받아 적합한 에이전트 팀을 선택하고, 3단계(설계→구현→검증)로 순서대로 실행한다.

절대 금지:
- 하네스 선택을 사용자 확인 없이 결정하는 것
- Phase 순서를 건너뛰는 것 (구현자 tier가 없는 하네스 제외)
- git commit, git push

허용:
- 하네스 후보 제시 후 사용자 선택 대기
- TASK.md 생성 및 갱신
- Agent 툴로 각 tier 에이전트 호출

## 실행 절차

### 0단계: 입력 파싱

`$ARGUMENTS`에서 태스크 설명을 추출한다.
비어있으면 → "어떤 작업을 진행할까요? 태스크 설명을 입력해주세요." 출력 후 종료.

### 1단계: 하네스 선택 (dispatcher.md 프로토콜)

`.claude/agents/dispatcher.md`의 **태스크 키워드 → 하네스 후보 매핑** 테이블을 기준으로:

1. `$ARGUMENTS`에서 키워드를 추출한다.
2. 1순위 + 2순위 하네스를 선정한다.
3. 다음 형식으로 사용자에게 제시한다:

    [Dispatcher] 태스크 분석 결과:

    추천 하네스 조합:
      A. {1순위} + {2순위} ({이유})
      B. {1순위} 단독 ({이유})
      C. 직접 지정: ___

    어느 조합으로 진행할까요? (A/B/C)

4. 사용자 선택 후 하네스 목록을 확정하고 Phase 1을 시작한다.

> FRONTEND_PATH 관리: fullstack-webapp 하네스 선택 시에만 FRONTEND_PATH를 입력받는다.
> 미설정 상태면 "프론트엔드 경로를 입력해주세요 (예: ../re-issuance-machine-frontend):" 질문.

### 2단계: Phase 1 — 설계 (설계자 tier)

선택된 각 하네스의 **설계자 tier** 에이전트를 순서대로 실행한다.

하네스별 설계자 tier (`dispatcher.md` 매핑 테이블 참조):
| 하네스 | 설계자 tier |
|--------|------------|
| fullstack-webapp | architect |
| api-designer | api-architect |
| database-architect | data-modeler |
| code-reviewer | architecture-reviewer |
| legacy-modernizer | legacy-analyzer, refactoring-strategist |
| microservice-designer | domain-analyst, service-architect, communication-designer, observability-engineer |
| performance-optimizer | bottleneck-analyst |

설계 완료 후 `dispatcher.md`의 **TASK.md 자동 생성 포맷**에 따라 `temp/TASK.md`를 생성한다.
- 하네스 1개: 단일 섹션 포맷
- 하네스 2개 이상: 하네스별 섹션 분리 포맷

### 3단계: Phase 2 — 구현 (구현자 tier)

구현자 tier가 없는 하네스(code-reviewer, microservice-designer)는 이 단계를 건너뛴다:

    [Phase 2 건너뜀] {하네스명}은 구현자 tier가 없습니다. Phase 3으로 진행합니다.

구현자 tier가 있는 경우 `/task-exec temp/TASK.md` 실행을 안내하거나
Agent 툴로 실행자 역할 에이전트를 호출한다.

### 4단계: Phase 3 — 검증 (검증자 tier)

선택된 각 하네스의 **검증자 tier** 에이전트를 순서대로 실행한다.

하네스별 검증자 tier (`dispatcher.md` 매핑 테이블 참조):
| 하네스 | 검증자 tier |
|--------|------------|
| fullstack-webapp | qa-engineer |
| api-designer | schema-validator, mock-tester, review-auditor |
| database-architect | performance-analyst, security-auditor, integration-reviewer |
| code-reviewer | style-inspector, security-analyst, performance-analyst, review-synthesizer |
| legacy-modernizer | regression-tester, modernization-reviewer |
| microservice-designer | architecture-reviewer |
| performance-optimizer | profiler, benchmark-manager, perf-reviewer |

### 5단계: 완료 보고

    [dev-flow 완료]
    하네스: {선택된 하네스}
    Phase 1 (설계): ✓
    Phase 2 (구현): ✓ / 건너뜀
    Phase 3 (검증): ✓
    TASK.md: temp/TASK.md

## 에러 핸들링

| 상황 | 처리 |
|------|------|
| 키워드 매핑 불분명 | 사용자에게 태스크 유형 직접 선택 요청 |
| 구현자 tier 없는 하네스 | Phase 2 자동 건너뜀, 사용자에게 안내 |
| FRONTEND_PATH 미제공 | fullstack-webapp 선택 시에만 입력 요청 |
| 설계자 에이전트 실패 | 1회 재시도 후 실패 시 수동 입력 요청 |

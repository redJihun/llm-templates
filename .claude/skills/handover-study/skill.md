---
name: handover-study
description: "인수인계 코드/문서를 scope별 학습 자료(정리본·플래시카드·퀴즈)로 변환하고, 인터랙티브 채점·간격반복 퀴즈로 숙지도를 검토하는 스킬. '인수인계 공부', 'handover study', '발급 스크립트 학습자료 만들어줘' 같은 요청에 사용. 서브커맨드: curriculum/generate/quiz/status."
---

# handover-study — 인수인계 학습 자료 생성·숙지 검토 스킬

워크스페이스 전체(코드+문서)를 scope별로 분리된 학습 자료로 변환하고 인터랙티브 퀴즈로 숙지도를 검토한다.

## 공통 규칙
- 산출물은 전용 레포 `handover-study/<scope>/` 아래에만 생성한다. 학습 대상 레포를 수정하지 않는다 (cross-repo 규칙).
- 학습 대상 코드는 읽기 전용.
- 모든 산출물 생성 시 `references/honesty-rules.md`를 적용한다.
- 응답 언어: 한국어.

## 서브커맨드 디스패처

입력 형식: `/handover-study <subcommand> <args>`

| 서브커맨드 | 형식 | 동작 |
|-----------|------|------|
| curriculum | `curriculum <scope>` | 대상 범위 탐색 → curriculum.md 생성 (→ §curriculum) |
| generate | `generate <scope> <주제>` | 모듈 정리본+플래시카드+퀴즈 풀 생성 (→ §generate) |
| quiz | `quiz <scope> <주제>` | 인터랙티브 출제·채점·오답 트래킹 (→ §quiz) |
| status | `status [<scope>]` | 진도 요약 (→ §status) |

서브커맨드가 없거나 모호하면 위 표를 보여주고 입력을 요청한다.

## §curriculum — `curriculum <scope>`

1. scope 인자 확인. 없으면 기존 scope 목록(`handover-study/*/` 디렉토리)을 보여주고 입력 요청.
2. 사용자에게 **대상 범위**(레포/디렉토리/주제)를 확인한다. 이미 인자에 포함됐으면 생략.
3. `handover-study/<scope>/` 디렉토리를 만들고 `references/templates.md`의 `_scope.md` 템플릿으로 `_scope.md` 작성 (대상 경로·설명 기록).
4. 대상 범위를 **Explore 에이전트로 레포별 병렬 fan-out** 탐색한다. 각 에이전트는:
   - 해당 경로의 디렉토리 구조·핵심 파일·기존 문서를 수집
   - 모듈 후보(주제 단위)를 반환
5. 수집 결과를 MECE·최대 3단계 깊이로 모듈 분할. 각 모듈에 학습 목표를 **행동 동사**로 기술.
6. `templates.md`의 curriculum.md 템플릿으로 `handover-study/<scope>/curriculum.md` 작성. 모듈은 `NN-kebab-slug` 순번.
7. `progress.md`·`review-queue.md`를 템플릿으로 초기화 (모듈 목록 반영).
8. 완료 후 모듈 목록을 사용자에게 보여주고 `generate <scope> <주제>` 안내.

honesty-rules 적용: 탐색 못 한 영역은 _scope.md "설명"에 미확인으로 남긴다.

## §generate — `generate <scope> <주제>`

1. `handover-study/<scope>/curriculum.md` 없으면 "먼저 `curriculum <scope>` 실행" 안내 후 중단.
2. 주제 인자로 모듈 식별. 모호하면 curriculum.md 모듈 목록 보여주고 선택 요청.
3. 해당 모듈의 대상 소스 파일을 **Read로 직접 확인**한다 (Explore로 위치 파악 후 핵심 파일 Read).
4. `references/templates.md`의 summary.md 템플릿으로 정리본 작성:
   - 비유(메탈모델) → 한 줄 요약 → 핵심 개념(근거 `file_path:line`) → 개념도 → 코드 예제(실제 발췌) → 흔한 오해 → 메타인지 체크포인트(행동 동사) → 근거/미확인 블록
   - honesty-rules.md 적용: 확인 못 한 항목은 "미확인" 블록에.
5. flashcards.md 작성: 핵심 개념을 Q/A 카드로, 카드ID `M<NN>-C01`부터 부여, 각 A에 근거.
6. quiz-bank.md 작성: 객관식·단답·"이 코드가 하는 일 설명" 혼합, 각 문제에 정답+해설+근거.
7. curriculum.md의 해당 모듈 상태를 "생성됨"으로 갱신.
8. 산출 경로를 사용자에게 보고하고 `quiz <scope> <주제>` 안내.

## §quiz — `quiz <scope> <주제>`

1. `handover-study/<scope>/modules/<주제>/quiz-bank.md` 없으면 "먼저 `generate <scope> <주제>`" 안내 후 중단.
2. review-queue.md 읽고 현재 세션 카운트 +1. `references/spaced-repetition.md`의 출제 우선순위 적용:
   - 복습 예정 카드(다음 복습 회차 <= 현재 세션) 우선
   - 부족분은 quiz-bank.md 미출제 문제로 채움
3. **한 문제씩** 사용자에게 제시하고 답을 받는다 (한 응답에 한 문제).
4. 답 채점 + 해설 + 근거(`file_path:line`) 제시.
5. 채점 결과로 spaced-repetition.md 규칙대로 review-queue.md 갱신:
   - 오답: 카드 추가/연속정답 0, 다음 복습 회차 = 현재+1
   - 정답: 연속정답 +1, 다음 복습 회차 1→3→7 확장
6. 세션 종료 시(사용자 중단 또는 문제 소진) progress.md의 숙지도(%)·점수 이력 갱신.
   - 숙지도 = 누적 정답/누적 출제 비율 등 단순 산식.
7. 약한 영역(오답 많은 모듈)을 요약해 다음 학습 제안.

honesty-rules 적용: 채점은 quiz-bank.md 정답 기준, 정답 모호 시 "판정 보류"로 표시하고 근거 함께 제시.

## §status — `status [<scope>]`

1. scope 지정 시: 해당 `handover-study/<scope>/progress.md`·`review-queue.md`·`curriculum.md`를 읽어 요약.
   - 모듈별 숙지도(%), 복습 대기 카드 수, 미생성 모듈.
2. scope 생략 시: `handover-study/*/` 전체를 순회해 scope별 한 줄 요약 + 전체 진척도.
3. 다음 추천 행동 제시 (미생성 모듈 generate, 복습 대기 카드 quiz 등).

## 에러 핸들링

| 상황 | 처리 |
|------|------|
| curriculum.md 없는데 generate/quiz 호출 | "먼저 `curriculum <scope>` 실행" 안내 후 중단 |
| 주제 인자 모호 | curriculum.md 모듈 목록 제시, 선택 요청 |
| scope 미지정 | `handover-study/*/` 기존 scope 목록 제시, 선택 요청 |
| scope 디렉토리 없음 (curriculum 외) | "해당 scope 없음. `curriculum <scope>`로 먼저 생성" 안내 |
| 소스 파일 못 찾음 | 해당 항목 "미확인"으로 정리본에 명시, 진행 중단 안 함 |

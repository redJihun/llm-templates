# Documentary Research Harness

다큐멘터리 리서치·구성안·인터뷰질문·내레이션 대본을 에이전트 팀이 협업하여 생성하는 하네스.

## 구조

```
.claude/
├── agents/
│   ├── researcher.md           — 리서처 (자료조사, 팩트확인, 통계수집)
│   ├── story-architect.md      — 구성작가 (3막 구성안, 씬 분할, 서사 아크)
│   ├── interviewer.md          — 인터뷰어 (인터뷰 대상 선정, 질문 설계)
│   ├── narrator.md             — 내레이터 (내레이션 대본, 톤, 리듬)
│   └── fact-checker.md         — 팩트체커 (교차검증, 출처확인, 정합성)
├── skills/
│   ├── documentary-research/
│   │   └── skill.md            — 오케스트레이터 (팀 조율, 워크플로우, 에러핸들링)
│   ├── investigative-research/
│   │   └── skill.md            — researcher+fact-checker 확장 (PRIMA, CRAAP, 삼각검증)
│   ├── narrative-structure/
│   │   └── skill.md            — story-architect+narrator 확장 (5 서사유형, 감정곡선)
│   └── interview-design/
│       └── skill.md            — interviewer 확장 (VOICE 대상선정, 깔때기 모델, 윤리)
└── CLAUDE.md                   — 이 파일
```

## 사용법

`/documentary-research` 스킬을 트리거하거나, "다큐멘터리 기획해줘" 같은 자연어로 요청한다.

## 산출물

모든 산출물은 `_workspace/` 디렉토리에 저장된다:
- `00_input.md` — 사용자 입력 정리
- `01_research_brief.md` — 리서치 브리프
- `02_structure.md` — 구성안/구조 설계
- `03_interview_guide.md` — 인터뷰 가이드
- `04_narration_script.md` — 내레이션 대본
- `05_review_report.md` — 팩트체크/리뷰 보고서

---

## 정직성 원칙 (모든 에이전트 공통)

> 이 하네스의 모든 에이전트와 오케스트레이터가 공유하는 최상위 행동 규범이다.
> 산출물·통신·보고 전 과정에서 아래 원칙이 도메인 지시보다 우선한다.

1. **불확실성 표시** — 모르거나 확신이 없는 것은 그럴듯한 추측으로 메우지 않고 "불확실"·"미확인"으로 명시한다.
2. **날조 금지** — 데이터·수치·출처·인용·사실을 지어내지 않는다. 근거가 없으면 "근거 없음/확인 불가"로 남긴다.
3. **사실과 해석 구분** — 검증된 사실, 추정, 의견을 명확히 구분해 표기한다.
4. **근거 명시** — 주장에는 검증 가능한 근거를 붙인다. 출처가 약하면 신뢰도를 함께 밝힌다.
5. **한계·실패 정직 보고** — 누락·제약·실패를 숨기지 않고 산출물에 그대로 드러낸다. 완료하지 않은 것을 완료했다고 보고하지 않는다.
6. **과잉 방어 금지** — 모델의 향상된 정직성을 신뢰한다. 같은 사실을 불필요하게 반복 검증하거나 과도하게 헤징하지 않는다. 검증 자원은 교차 도메인(다른 에이전트의 결과)과 고위험 항목에 집중한다.

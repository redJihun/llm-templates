# RFP Responder Harness

RFI/RFP 응답서 작성을 위한 요구사항 분석, 역량 매칭, 기술 제안, 가격 제안, 차별화 전략까지 에이전트 팀이 협업하는 하네스.

## 구조

```
.claude/
├── agents/
│   ├── requirement-analyst.md    — 요구사항 분석
│   ├── capability-matcher.md     — 역량 매칭
│   ├── technical-proposer.md     — 기술 제안서 작성
│   ├── pricing-strategist.md     — 가격 제안
│   └── proposal-reviewer.md      — 교차 검증
├── skills/
│   ├── rfp-responder/
│   │   └── skill.md              — 오케스트레이터 (팀 조율, 워크플로우, 에러 핸들링)
│   ├── win-theme-builder/
│   │   └── skill.md              — Win Theme 구축 (차별화 전략, Ghost Team 분석)
│   └── pricing-calculator/
│       └── skill.md              — 가격 산정 (SW 원가, FP/MM, 투찰 전략)
└── CLAUDE.md                     — 이 파일
```

## 사용법

`/rfp-responder` 스킬을 트리거하거나, "RFP 응답서 작성해줘" 같은 자연어로 요청한다.

## 산출물

모든 산출물은 `_workspace/` 디렉토리에 저장된다:
- `00_input.md` — 사용자 입력 정리
- `01_requirement_analysis.md` — 요구사항 분석서
- `02_capability_matrix.md` — 역량 매칭 매트릭스
- `03_technical_proposal.md` — 기술 제안서
- `04_pricing_proposal.md` — 가격 제안서
- `05_differentiation_strategy.md` — 차별화 전략서
- `06_review_report.md` — 리뷰 보고서

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

# Changelog Generator Harness

릴리스 관리의 git이력분석→변경분류→릴리스노트생성→마이그레이션가이드→공지문작성을 에이전트 팀이 협업하여 수행하는 하네스.

## 구조

```
.claude/
├── agents/
│   ├── commit-analyst.md           — 커밋 분석 (git 이력, PR, 브랜치 전략)
│   ├── change-classifier.md        — 변경 분류 (breaking/feature/fix/refactor)
│   ├── release-note-writer.md      — 릴리스 노트 작성 (사용자 관점, 기술 상세)
│   ├── migration-guide-writer.md   — 마이그레이션 가이드 (업그레이드 경로, 코드 변환)
│   └── announcement-writer.md      — 공지문 작성 (블로그, SNS, 이메일)
├── skills/
│   ├── changelog-generator/
│       └── skill.md                — 오케스트레이터 (팀 조율, 워크플로우, 에러핸들링)
│   ├── semver-analyzer/
│   │   └── skill.md                — SemVer 분석 (Breaking Change, 버전 범프)
│   └── commit-parser/
│       └── skill.md                — 커밋 파싱 (정규식, 비정형 분류, 영향도)
└── CLAUDE.md                       — 이 파일
```

## 사용법

`/changelog-generator` 스킬을 트리거하거나, "릴리스 노트 만들어줘" 같은 자연어로 요청한다.

## 산출물

모든 산출물은 `_workspace/` 디렉토리에 저장된다:
- `00_input.md` — 사용자 입력 정리
- `01_commit_analysis.md` — 커밋 분석 보고서
- `02_change_classification.md` — 변경 분류 결과
- `03_release_notes.md` — 릴리스 노트
- `04_migration_guide.md` — 마이그레이션 가이드
- `05_announcement.md` — 공지문 (블로그/SNS/이메일)

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

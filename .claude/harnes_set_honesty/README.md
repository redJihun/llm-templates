# Harness 100 — 실전 에이전트 팀 하네스 컬렉션 (정직성 최적화 에디션)

일상생활과 업무에 바로 적용할 수 있는 **100가지 에이전트 팀 하네스**를 구축한 프로젝트입니다.

각 하네스는 Claude Code의 에이전트 팀 기능을 활용하여 도메인 전문가 4~5명이 협업하는 프로덕션급 워크플로우를 구성합니다.

## 정직성 최적화 (honesty-optimized 에디션)

이 디렉토리(`harnes_set_honesty`)는 원본 `harnes_set`의 복사본에 **모델 정직성(honesty) 향상을 반영해 최적화**한 에디션이다.

**배경** — 최신 모델은 정직성이 대폭 향상되어, 모르는 것을 추측으로 메우거나 데이터를 날조하는 경향이 크게 줄었다. 기존 하네스는 honesty 지시가 일부 파일(489개 중 "정직" 명시 3개)에만 비일관적으로 흩어져 있었고, 구형 모델 대비용 반복 검증 스캐폴딩이 무거웠다.

**적용한 변경:**

1. **강화 + 일관화** — 100개 모든 하네스의 `CLAUDE.md` 끝에 동일한 **`## 정직성 원칙` 블록**을 주입했다. 불확실성 표시·날조 금지·사실과 해석 구분·근거 명시·한계 정직 보고를 모든 에이전트 공통 최상위 규범으로 명문화했다.
2. **정리(과잉 방어 완화)** — 원칙 6(`과잉 방어 금지`)으로 처리했다. 흩어진 ad-hoc 헤징·반복 자기검증 지시를 무분별하게 삭제하면 에이전트 간 **교차 검토 워크플로**(legitimate cross-agent review)까지 손상되므로, 삭제 대신 정책 레벨에서 "모델의 향상된 정직성을 신뢰하고 검증 자원을 교차 도메인·고위험 항목에 집중"하도록 재배치했다.

**본문 점검 결과 (agents 489 + skills 315 = 804개 본문 파일)** — RALPLAN 합의(Planner·Architect·Critic)를 거쳐, 본문에 흩어진 헤징 문구를 실제로 삭제·축소하는 작업을 수행했다. 결정적 grep 게이트(사과 패딩·불확실 산문·필러·영어 헤징)로 후보를 추리고, honesty-정렬 원칙(`추측 금지`·`모르면`)·심각도 라벨·경계 있는 교차검토 루프(`재검증(최대 N회)`)·의도된 end-user 출력 블록은 제외 룰셋으로 보호했다.

- **결과: 제거 대상 진짜 헤징 0건.** 원시 후보 4건(사과 표현)은 전수 컨텍스트 확인 결과 모두 도메인 콘텐츠였다 — customer-support 공감 응대 스크립트, chatbot 폴백 봇 발화, crisis-communication 위기유형별 톤 매핑 표·보도자료 인용문 템플릿. 모두 의도된 출력/방법론이므로 보존했다.
- **이유** — 본문의 의심 키워드(`반드시` 314줄, `주의` 176줄 등)는 모델 능력에 대한 방어적 헤징이 아니라 도메인 방법론·우선순위 라벨이었다. 모델 정직성에 대한 과잉 방어 산문은 본문에 사실상 존재하지 않았다. 음성(negative) 결과 자체가 정직한 산출물이며, 편집을 날조하지 않았다.

**원본 대비 차이** — 100개 `CLAUDE.md`에 `## 정직성 원칙` 섹션이 추가된 것과 이 `README.md` 갱신이 유일한 파일 변경이다. 804개 agents/skills 본문은 점검 후 **0건 편집**으로 도메인 로직을 그대로 보존했다.

## 프로젝트 규모

| 항목 | 수량 |
|------|------|
| 하네스 | 100개 |
| 에이전트 정의 | 489개 |
| 스킬 (오케스트레이터 + 에이전트 확장) | 315개 |
| 총 파일 | 904개 |

## 사용법

원하는 하네스 폴더를 프로젝트에 복사하면 바로 사용할 수 있습니다:

```bash
# 예시: youtube-production 하네스를 내 프로젝트에 적용
cp -r 01-youtube-production/.claude/ /path/to/my-project/.claude/
```

각 하네스 폴더의 `CLAUDE.md`에서 구조와 사용법을 확인할 수 있습니다.

## 하네스 구조

모든 하네스는 동일한 구조를 따릅니다:

```
{NN}-{harness-name}/
└── .claude/
    ├── CLAUDE.md                          # 프로젝트 개요
    ├── agents/
    │   ├── {agent-1}.md                   # 전문 에이전트 정의
    │   ├── {agent-2}.md
    │   ├── {agent-3}.md
    │   ├── {agent-4}.md
    │   └── {agent-5}.md (선택)
    └── skills/
        ├── {orchestrator}/
        │   └── skill.md                   # 오케스트레이터 스킬
        ├── {agent-skill-1}/
        │   └── skill.md                   # 에이전트 확장 스킬
        └── {agent-skill-2}/
            └── skill.md                   # 에이전트 확장 스킬
```

## 품질 기준

모든 하네스는 다음 기준을 충족합니다:

- **에이전트 팀 모드** — SendMessage로 직접 통신, 교차 검증
- **도메인 전문성** — 각 분야의 실전 프레임워크와 방법론 적용
- **산출물 템플릿** — 에이전트별 구조화된 산출물 포맷 정의
- **의존 관계 관리** — 작업 순서와 병렬 실행 명시
- **에러 핸들링** — 실패 시 폴백 전략 정의
- **작업 규모별 모드** — 풀/축소/단일 모드 지원
- **테스트 시나리오** — 정상/기존파일활용/에러 흐름 3종
- **트리거 경계** — should-trigger + NOT-trigger 명시
- **에이전트 확장 스킬** — 에이전트별 2~3개 도메인 특화 스킬로 전문성 강화

---

## 카테고리 1: 콘텐츠 제작 & 크리에이티브 (01~15)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 01 | [youtube-production](01-youtube-production/) | YouTube 영상 기획→대본→썸네일→SEO 풀파이프라인 | 5명 |
| 02 | [podcast-studio](02-podcast-studio/) | 팟캐스트 기획·리서치·대본·쇼노트 | 5명 |
| 03 | [newsletter-engine](03-newsletter-engine/) | 뉴스레터 큐레이션·작성·A/B변형 | 5명 |
| 04 | [content-repurposer](04-content-repurposer/) | 1개 원본→블로그·SNS·뉴스레터·PT 다중 변환 | 5명 |
| 05 | [game-narrative](05-game-narrative/) | 게임 스토리·퀘스트·대사·분기 시나리오 | 5명 |
| 06 | [brand-identity](06-brand-identity/) | 네이밍→슬로건→톤앤매너→가이드라인 | 5명 |
| 07 | [comic-creator](07-comic-creator/) | 4컷/장편 만화: 콘티→대사→이미지생성→편집 | 5명 |
| 08 | [course-builder](08-course-builder/) | 온라인 강의: 커리큘럼→교안→퀴즈→실습 | 5명 |
| 09 | [documentary-research](09-documentary-research/) | 다큐 리서치·구성안·인터뷰질문·내레이션 | 5명 |
| 10 | [social-media-manager](10-social-media-manager/) | SNS 콘텐츠 달력·포스트·해시태그·분석 | 5명 |
| 11 | [book-publishing](11-book-publishing/) | 전자책: 원고편집→표지→메타데이터→배포 | 5명 |
| 12 | [advertising-campaign](12-advertising-campaign/) | 광고 캠페인: 타깃→카피→크리에이티브→미디어플랜 | 5명 |
| 13 | [presentation-designer](13-presentation-designer/) | 프레젠테이션: 스토리보드→슬라이드→발표노트 | 5명 |
| 14 | [translation-localization](14-translation-localization/) | 다국어 번역·현지화·문화적응·용어관리 | 5명 |
| 15 | [visual-storytelling](15-visual-storytelling/) | 비주얼 스토리텔링: AI이미지+HTML레이아웃 | 5명 |

## 카테고리 2: 소프트웨어 개발 & DevOps (16~30)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 16 | [fullstack-webapp](16-fullstack-webapp/) | 풀스택 웹앱: 설계→프론트→백엔드→테스트→배포 | 5명 |
| 17 | [mobile-app-builder](17-mobile-app-builder/) | 모바일 앱: UI/UX→코드→API→스토어배포 | 5명 |
| 18 | [api-designer](18-api-designer/) | REST/GraphQL API 설계·문서화·목업·테스트 | 5명 |
| 19 | [database-architect](19-database-architect/) | DB: 모델링→마이그레이션→인덱싱→최적화 | 5명 |
| 20 | [cicd-pipeline](20-cicd-pipeline/) | CI/CD 파이프라인 설계·구축·최적화 | 5명 |
| 21 | [code-reviewer](21-code-reviewer/) | 코드 리뷰: 스타일→보안→성능→아키텍처 | 5명 |
| 22 | [legacy-modernizer](22-legacy-modernizer/) | 레거시 현대화: 분석→리팩토링→마이그레이션 | 5명 |
| 23 | [microservice-designer](23-microservice-designer/) | 마이크로서비스 아키텍처 설계·분해·통신 | 5명 |
| 24 | [test-automation](24-test-automation/) | 테스트 자동화: 전략→작성→CI→커버리지 | 5명 |
| 25 | [incident-postmortem](25-incident-postmortem/) | 장애 사후분석: 타임라인→근본원인→재발방지 | 5명 |
| 26 | [infra-as-code](26-infra-as-code/) | IaC: Terraform/Pulumi→보안→비용최적화 | 5명 |
| 27 | [data-pipeline](27-data-pipeline/) | 데이터 파이프라인: ETL→품질검증→모니터링 | 5명 |
| 28 | [security-audit](28-security-audit/) | 보안 감사: 취약점→코드분석→침투테스트→권고 | 5명 |
| 29 | [performance-optimizer](29-performance-optimizer/) | 성능 최적화: 프로파일링→병목→최적화→벤치마크 | 5명 |
| 30 | [open-source-launcher](30-open-source-launcher/) | 오픈소스 런칭: 코드정리→문서→라이선스→커뮤니티 | 5명 |

## 카테고리 3: 데이터 & AI/ML (31~42)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 31 | [ml-experiment](31-ml-experiment/) | ML 실험: 데이터→모델→학습→평가→배포 | 5명 |
| 32 | [data-analysis](32-data-analysis/) | 데이터 분석: 탐색→정제→분석→시각화→보고서 | 5명 |
| 33 | [text-processor](33-text-processor/) | 텍스트 처리: 요약·분류·추출·감성분석 | 5명 |
| 34 | [data-migration](34-data-migration/) | 데이터 마이그레이션: 스키마매핑→변환→검증 | 5명 |
| 35 | [api-client-generator](35-api-client-generator/) | API 클라이언트 SDK 자동 생성 | 5명 |
| 36 | [design-system](36-design-system/) | UI 디자인 시스템: 토큰→컴포넌트→스토리북 | 5명 |
| 37 | [web-scraper](37-web-scraper/) | 웹 스크래핑: 크롤러→파서→저장→모니터링 | 5명 |
| 38 | [chatbot-builder](38-chatbot-builder/) | 챗봇: 대화설계→NLU→통합→테스트 | 5명 |
| 39 | [changelog-generator](39-changelog-generator/) | 릴리스: git분석→릴리스노트→마이그레이션가이드 | 5명 |
| 40 | [cli-tool-builder](40-cli-tool-builder/) | CLI 도구: 명령설계→코드→테스트→문서→배포 | 5명 |
| 41 | [llm-app-builder](41-llm-app-builder/) | LLM 앱: 프롬프트→RAG→평가→최적화→배포 | 5명 |
| 42 | [bi-dashboard](42-bi-dashboard/) | BI 대시보드: KPI→시각화→자동보고 | 5명 |

## 카테고리 4: 비즈니스 & 전략 (43~55)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 43 | [startup-launcher](43-startup-launcher/) | 스타트업: 아이디어검증→BM→MVP→피칭 | 5명 |
| 44 | [market-research](44-market-research/) | 시장 조사: 산업→경쟁→소비자→트렌드 | 5명 |
| 45 | [gov-funding-plan](45-gov-funding-plan/) | 정부지원사업 사업계획서 작성 | 5명 |
| 46 | [product-manager](46-product-manager/) | PM: 로드맵→PRD→유저스토리→스프린트 | 5명 |
| 47 | [strategy-framework](47-strategy-framework/) | 전략: OKR→BSC→SWOT→비전→로드맵 | 5명 |
| 48 | [sales-enablement](48-sales-enablement/) | 영업: 고객분석→제안서→PT→팔로업 | 5명 |
| 49 | [customer-support](49-customer-support/) | 고객지원: FAQ→응대매뉴얼→에스컬레이션 | 5명 |
| 50 | [pricing-strategy](50-pricing-strategy/) | 가격 전략: 원가→경쟁→가치기반→시뮬레이션 | 5명 |
| 51 | [investor-report](51-investor-report/) | 투자자 보고서: 재무→KPI→시장→전략 | 5명 |
| 52 | [scenario-planner](52-scenario-planner/) | 시나리오: 변수→매트릭스→영향→대응전략 | 5명 |
| 53 | [financial-modeler](53-financial-modeler/) | 재무 모델링: 수익→비용→시나리오→밸류에이션 | 5명 |
| 54 | [grant-writer](54-grant-writer/) | 보조금 신청: 공고분석→사업계획→예산→제출 | 5명 |
| 55 | [rfp-responder](55-rfp-responder/) | RFI/RFP 응답서 작성 | 5명 |

## 카테고리 5: 교육 & 학습 (56~65)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 56 | [language-tutor](56-language-tutor/) | 외국어: 레벨테스트→커리큘럼→레슨→퀴즈 | 5명 |
| 57 | [exam-prep](57-exam-prep/) | 시험 준비: 출제경향→약점진단→모의고사→오답 | 5명 |
| 58 | [thesis-advisor](58-thesis-advisor/) | 논문: 주제→문헌→방법론→집필→교정 | 5명 |
| 59 | [coding-bootcamp](59-coding-bootcamp/) | 코딩 교육: 커리큘럼→실습→코드리뷰→포트폴리오 | 4명 |
| 60 | [debate-simulator](60-debate-simulator/) | 토론 시뮬레이션: 찬반→교차심문→심판→보고서 | 5명 |
| 61 | [competency-modeler](61-competency-modeler/) | 역량 모델링: 직무분석→역량사전→루브릭 | 4명 |
| 62 | [adr-writer](62-adr-writer/) | ADR: 기술컨텍스트→대안비교→트레이드오프→문서화 | 5명 |
| 63 | [research-assistant](63-research-assistant/) | 학술 연구: 문헌검색→메모→비평→참고문헌 | 5명 |
| 64 | [knowledge-base-builder](64-knowledge-base-builder/) | 지식관리: 수집→분류→마크다운위키→검색인덱스 | 5명 |
| 65 | [personal-branding](65-personal-branding/) | 개인 브랜딩: 이력서→포트폴리오→LinkedIn | 5명 |

## 카테고리 6: 법률 & 규정 (66~72)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 66 | [contract-analyzer](66-contract-analyzer/) | 계약서 분석·작성·검토·위험평가 | 5명 |
| 67 | [compliance-checker](67-compliance-checker/) | 규정 준수: 법률매핑→갭분석→개선계획 | 4명 |
| 68 | [patent-drafter](68-patent-drafter/) | 특허: 선행기술→청구항→명세서→도면설명 | 5명 |
| 69 | [privacy-engineer](69-privacy-engineer/) | 개인정보보호: GDPR/PIPA→PIA→동의서 | 4명 |
| 70 | [legal-research](70-legal-research/) | 법률 리서치: 판례→법리분석→의견서 | 4명 |
| 71 | [service-legal-docs](71-service-legal-docs/) | 서비스 법무문서: 약관+처리방침+쿠키+환불 일체 | 4명 |
| 72 | [regulatory-filing](72-regulatory-filing/) | 인허가 신고서류: 요건조사→신청서→첨부자료 | 4명 |

## 카테고리 7: 건강 & 라이프스타일 (73~80)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 73 | [meal-planner](73-meal-planner/) | 식단: 영양분석→식단설계→레시피→장보기 | 4명 |
| 74 | [fitness-program](74-fitness-program/) | 운동: 프로그램설계→가이드→식단연계→기록 | 4명 |
| 75 | [tax-calculator](75-tax-calculator/) | 세금: 소득분석→공제최적화→절세시뮬레이션 | 4명 |
| 76 | [travel-planner](76-travel-planner/) | 여행: 목적지→일정→예산→현지정보 | 4명 |
| 77 | [space-concept-board](77-space-concept-board/) | 공간 컨셉보드: 무드보드→컬러→가구→예산 | 5명 |
| 78 | [personal-finance](78-personal-finance/) | 재무관리: 수입지출→예산→투자→은퇴설계 | 5명 |
| 79 | [side-project-launcher](79-side-project-launcher/) | 사이드프로젝트: 아이디어→기술스택→MVP→런칭 | 5명 |
| 80 | [wedding-planner](80-wedding-planner/) | 결혼 준비: 타임라인→예산→업체비교→체크리스트 | 5명 |

## 카테고리 8: 커뮤니케이션 & 문서 (81~88)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 81 | [technical-writer](81-technical-writer/) | 기술 문서: 구조설계→집필→다이어그램→리뷰 | 5명 |
| 82 | [report-generator](82-report-generator/) | 업무 보고서: 데이터→분석→시각화→집필 | 5명 |
| 83 | [sop-writer](83-sop-writer/) | SOP: 프로세스분석→절차서→체크리스트→교육 | 5명 |
| 84 | [meeting-strategist](84-meeting-strategist/) | 회의 전략: 안건→배경→의사결정프레임워크 | 5명 |
| 85 | [public-speaking](85-public-speaking/) | 퍼블릭스피킹: 연설문→발표→토론→Q&A | 5명 |
| 86 | [proposal-writer](86-proposal-writer/) | 제안서: 고객분석→솔루션→가격→차별화 | 5명 |
| 87 | [crisis-communication](87-crisis-communication/) | 위기 소통: 상황→메시지→보도자료→Q&A | 5명 |
| 88 | [risk-register](88-risk-register/) | 리스크 관리대장: 식별→평가→대응→모니터링 | 5명 |

## 카테고리 9: 운영 & 프로세스 (89~95)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 89 | [event-organizer](89-event-organizer/) | 이벤트: 컨셉→프로그램→홍보→실행→평가 | 5명 |
| 90 | [hiring-pipeline](90-hiring-pipeline/) | 채용: JD→소싱→스크리닝→면접→오퍼 | 5명 |
| 91 | [onboarding-system](91-onboarding-system/) | 온보딩: 체크리스트→교육→멘토→30-60-90 | 5명 |
| 92 | [operations-manual](92-operations-manual/) | 업무 매뉴얼 자동 생성: 분석→플로차트→FAQ | 5명 |
| 93 | [feedback-analyzer](93-feedback-analyzer/) | 피드백 분석: 감성→주제분류→트렌드→인사이트 | 5명 |
| 94 | [audit-report](94-audit-report/) | 내부감사: 범위→체크리스트→발견→권고→추적 | 5명 |
| 95 | [procurement-docs](95-procurement-docs/) | 구매 문서: 요구사항→벤더비교→평가→검수 | 5명 |

## 카테고리 10: 전문 도메인 (96~100)

| # | 하네스 | 설명 | 에이전트 |
|---|--------|------|---------|
| 96 | [real-estate-analyst](96-real-estate-analyst/) | 부동산: 시장→입지→수익성→리스크→투자보고서 | 5명 |
| 97 | [ecommerce-launcher](97-ecommerce-launcher/) | 이커머스: 상품기획→상세페이지→가격→마케팅 | 5명 |
| 98 | [academic-paper](98-academic-paper/) | 학술 논문: 연구설계→실험→분석→집필→투고 | 5명 |
| 99 | [sustainability-audit](99-sustainability-audit/) | ESG 감사: 환경→사회→거버넌스→보고서 | 5명 |
| 100 | [ip-portfolio](100-ip-portfolio/) | IP 포트폴리오: 특허→상표→저작권→라이선스전략 | 5명 |

---

## 주요 도메인 전문성 하이라이트

각 하네스는 해당 도메인의 실전 프레임워크를 내장하고 있습니다:

| 도메인 | 적용된 프레임워크/방법론 |
|--------|----------------------|
| 콘텐츠 | AIDA, 패턴 인터럽트, SEO 키워드 매핑, 플랫폼별 규격 |
| 개발 | SOLID, DDD, OWASP Top 10, 테스트 피라미드, DORA 메트릭 |
| 데이터 | Star/Snowflake 스키마, Great Expectations, SHAP/LIME |
| 비즈니스 | BMC, TAM/SAM/SOM, Porter's 5 Forces, RICE, OKR |
| 교육 | Bloom's Taxonomy, ADDIE, CEFR, 에빙하우스 간격 반복 |
| 법률 | IRAC, MQM, GDPR/PIPA, IPC/CPC 분류 |
| 라이프 | BMR/TDEE, KDRIs, ACSM 가이드라인, Van Westendorp |
| 문서 | Diataxis, PREP, STAR, MADR, SemVer |
| 운영 | SIPOC/RACI, 4C 프레임워크, SMART, NPS/CSAT |
| 전문 | GHG Protocol, Cap Rate/IRR, IMRaD, Georgia-Pacific |

## 라이선스

Apache License 2.0 — [LICENSE](../LICENSE) 참조

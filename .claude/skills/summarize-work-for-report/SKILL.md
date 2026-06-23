---
name: summarize-work-for-report
description: Use when summarizing completed work from weekly work logs for a non-technical general audience — organization-wide status updates, briefings, or reports where readers are outside the engineering team.
---

# Summarize Work for Report

## Overview

주간 작업 로그에서 완료 항목을 추출하여, 기술 직군이 아닌 독자(본부 전체 등)에게 전달할 수 있는 간결한 요약 2~3개로 정리한다.

## Input

```
<작업로그 파일 경로> [추가 파일...]
```

- 복수 주차 파일 허용 (예: W17.md W18.md)
- claude-mem 관찰 ID도 허용

## Process

1. 작업 로그 파일 읽기 (또는 `get_observations`으로 완료 항목 추출)
2. `[x]` 완료 항목 및 커밋/병합된 내용 수집
3. 기술 용어 → 일반 언어 변환 (아래 표 참고)
4. 핵심 업무 2~3개로 압축

## Output Format

```
- [업무 주제] [완료 | 진행 중 | 착수]
- [업무 주제] [완료 | 진행 중 | 착수]
```

항목당 1줄. 완료 여부를 자연스럽게 문장에 포함.

## Language Rules

| 기술 용어 | 일반 표현 |
|-----------|-----------|
| API, 엔드포인트 | 서버 기능 |
| JWT, 인증 토큰 | 로그인 인증 |
| CORS | 외부 접근 도메인 제한 |
| 409, HTTP 상태코드 | 오류 처리, 방어 처리 |
| FE / 프론트엔드 | 화면 |
| BE / 백엔드 | 서버 |
| React, FastAPI 등 프레임워크명 | 생략 또는 "시스템" |
| 참조 무결성 | 연결된 데이터 보호 |
| 마이그레이션 | 전환, 이전 |
| 리팩토링 | 개선, 정리 |
| 테스트 코드 | (독자 불필요 시 생략) |

## Example

**입력:** W17(API 인증 적용, CORS 제한, FE 에러 처리) + W18(상태 기반 참조 차단, 409 처리, 발급화면 개발)

**출력:**
```
- 리뉴얼 서버 전체 기능에 로그인 인증 적용 및 외부 접근 허용 도메인 제한 완료 (보안 강화)
- 연결된 데이터가 있는 항목을 실수로 삭제할 수 없도록 방어 처리 구현 완료
- 기존 발급 화면을 리뉴얼 시스템 안으로 통합하는 신규 화면 개발 착수
```

## Notes

- 항목 수: 기본 2~3개. 주차가 여러 개여도 통합해서 압축
- 진행 중 항목은 "착수" / "진행 중"으로 자연스럽게 표현
- 독자가 같은 직무가 아님을 항상 가정 — 전문 용어 사용 금지

# 코드 품질 규칙

<!--
  .claude/rules/code-quality.md
  매 턴 자동 로드됨. 간결하게 유지할 것.
  프로젝트에 맞게 {{placeholder}} 수정 후 사용.
-->

## 파일 크기 제한

- 단일 파일 **500줄 이내** — 초과 시 모듈 분리
- 단일 함수 **50줄 이내** — 초과 시 헬퍼로 추출
- 클래스 메서드 **30줄 이내**

## 네이밍

- 변수/함수: `snake_case`
- 클래스: `PascalCase`
- 상수: `UPPER_SNAKE_CASE`
- private: `_접두사`
- boolean 변수: `is_`, `has_`, `can_`, `should_` 접두사

## 코드 스타일

- **Early return** 적극 사용 — 중첩 깊이 3 이하 유지
- **Guard clause** 패턴 — 유효성 검사를 함수 상단에 배치
- 불필요한 else 제거 (if에서 return/raise 후 else 불필요)
- 매직 넘버 금지 — 상수로 추출
- 주석은 "왜(why)"만 — "무엇(what)"은 코드가 설명해야 함

## Import 정리

```
# 1. 표준 라이브러리
import os
from collections.abc import Callable

# 2. 서드파티
from fastapi import APIRouter

# 3. 프로젝트 내부
from ..models import User
```

## 타입 힌트

- 모든 함수 시그니처에 타입 힌트 필수
- `Any` 사용 최소화 — 구체적 타입 선호
- `Optional[X]` 대신 `X | None` (Python 3.10+)
- 컬렉션: `list[str]`, `dict[str, int]` (소문자, Python 3.9+)

## 금지 사항

- `print()` 디버깅 금지 → logger 사용
- `except:` (bare except) 금지 → 구체적 예외 명시
- `# type: ignore` 무분별 사용 금지 → 원인 해결
- 사용하지 않는 import/변수 방치 금지
- `TODO` 주석 새로 추가 금지 — 이슈 트래커 사용

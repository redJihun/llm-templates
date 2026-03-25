# 테스트 규칙

## 테스트 구조

```
tests/
├── conftest.py              # 공통 fixtures
├── unit/                    # 단위 테스트 (외부 의존성 없음)
│   ├── test_models.py
│   └── test_utils.py
├── integration/             # 통합 테스트 (DB, API 포함)
│   ├── test_api_auth.py
│   └── test_api_crud.py
└── e2e/                     # E2E 테스트 (선택)
```

## 네이밍 규칙

```python
# 파일명: test_{모듈명}.py
# 함수명: test_{동작}_{조건}_{기대결과}

def test_create_user_with_valid_data_returns_201():
    ...

def test_create_user_with_duplicate_email_raises_400():
    ...

def test_get_users_without_auth_returns_401():
    ...
```

## 테스트 작성 원칙

### AAA 패턴 (Arrange-Act-Assert)

```python
def test_calculate_yield_rate():
    # Arrange — 테스트 데이터 준비
    success_count = 95
    total_count = 100

    # Act — 테스트 대상 실행
    result = calculate_yield_rate(success_count, total_count)

    # Assert — 결과 검증
    assert result == 95.0
```

### 테스트 격리

- 각 테스트는 독립적으로 실행 가능해야 함
- 테스트 간 상태 공유 금지 — fixture로 매번 새로 생성
- DB 테스트는 트랜잭션 롤백 또는 테스트 DB 사용
- 외부 API 호출은 mock 처리 (단, DB는 실제 연결 권장)

### 커버리지 기준

- 새 기능 추가 시 해당 기능의 테스트 필수
- 버그 수정 시 해당 버그를 재현하는 테스트 추가
- 핵심 비즈니스 로직: 80%+ 커버리지 목표
- 유틸리티 함수: 엣지 케이스 포함 테스트

## 검증 명령

```bash
# 단일 파일 테스트
pytest tests/unit/test_models.py -v

# 특정 테스트 함수
pytest tests/unit/test_models.py::test_create_user -v

# 전체 테스트
pytest tests/ -v

# 커버리지 포함
pytest tests/ --cov=src/ --cov-report=term-missing
```

## 금지 사항

- `assert True` / `assert not False` 같은 무의미한 assertion 금지
- `time.sleep()` 으로 비동기 대기 금지 — 적절한 대기 메커니즘 사용
- 프로덕션 DB에 직접 연결하는 테스트 금지
- 테스트에서 `print()` 로 결과 확인 금지 → assert 사용

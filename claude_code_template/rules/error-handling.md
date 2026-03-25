# 에러 처리 규칙

## 기본 원칙

- **시스템 경계에서만 검증**: 외부 입력(사용자, API, 파일) 진입 시점에 검증
- **내부 코드는 신뢰**: 프레임워크 보장/내부 함수 간 호출에 방어적 코딩 불필요
- **에러는 빨리 실패**: 문제 발견 즉시 예외 발생 (silent failure 금지)
- **구체적 예외**: `except Exception` 보다 `except ValueError` 사용

## 패턴: API 라우터 에러 처리

```python
from fastapi import HTTPException

@router.get("/{uid}")
def get_item(uid: str, db: Session = Depends(get_db)):
    item = crud.get_item(db, uid)
    if not item:
        raise HTTPException(status_code=404, detail=f"Item not found: {uid}")
    return item
```

## 패턴: CRUD 레이어

```python
# CRUD는 None 반환 — HTTP 에러는 라우터에서 처리
def get_item(db: Session, uid: str) -> Model | None:
    return db.query(Model).filter(Model.uid == uid).first()

# 생성/수정은 예외 없이 결과 반환
def create_item(db: Session, data: CreateSchema) -> Model:
    item = Model(**data.dict())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item
```

## 로깅 레벨 기준

| 레벨 | 사용 시점 |
|------|----------|
| `DEBUG` | 요청 파라미터, 쿼리 결과 수 등 개발 정보 |
| `INFO` | 정상 완료된 주요 작업 (N건 조회, 생성 완료) |
| `WARNING` | 클라이언트 에러 (404, 400), 비정상 입력 |
| `ERROR` | 서버 에러 (500), 예상치 못한 예외 |
| `CRITICAL` | 시스템 중단 수준 (DB 연결 실패, 설정 누락) |

## 금지 사항

```python
# 1. bare except 금지
try:
    ...
except:  # NEVER — BaseException도 잡힘 (KeyboardInterrupt 등)
    pass

# 2. 예외 삼키기 금지
try:
    ...
except ValueError:
    pass  # NEVER — 최소 로깅은 해야 함

# 3. 과도한 try-except 금지
try:  # NEVER — 불필요한 감싸기
    x = 1 + 2
except Exception:
    ...

# 4. HTTPException을 CRUD에서 발생시키기 금지
# CRUD는 웹 프레임워크에 의존하지 않아야 함
```

# 보안 규칙

## 시크릿 관리

- **절대 커밋 금지**: `.env`, `credentials.json`, API 키, 비밀번호, 토큰
- 시크릿은 환경 변수 또는 시크릿 매니저를 통해 주입
- 하드코딩된 시크릿 발견 시 즉시 사용자에게 경고
- `.gitignore`에 시크릿 파일 패턴 반드시 포함

```gitignore
.env
.env.*
!.env.example
*.pem
*.key
credentials*.json
```

## SQL Injection 방지

```python
# 올바른 방법 — 파라미터 바인딩
db.execute(text("SELECT * FROM users WHERE id = :id"), {"id": user_id})

# 금지 — f-string SQL
db.execute(text(f"SELECT * FROM users WHERE id = {user_id}"))  # NEVER
```

- ORM 쿼리 우선 사용
- Raw SQL 필요 시 반드시 `text()` + `:parameter` 바인딩
- 사용자 입력을 SQL 문자열에 직접 삽입 금지

## XSS 방지

- 사용자 입력을 HTML/JSON 응답에 직접 삽입 금지
- 프레임워크의 자동 이스케이프 기능 활용
- `innerHTML`, `dangerouslySetInnerHTML` 사용 시 반드시 sanitize

## 인증/인가

- 비밀번호는 반드시 해시 저장 (bcrypt, argon2)
- JWT 토큰에 민감 정보 포함 금지 (비밀번호, 개인정보)
- API 엔드포인트에 적절한 인증/인가 미들웨어 적용
- CORS 설정은 허용 출처를 명시적으로 지정 (`*` 지양)

## 입력 검증

- 모든 외부 입력(사용자 입력, API 요청, 파일 업로드)에 검증 적용
- Pydantic 등 스키마 기반 검증 활용
- 파일 업로드 시 타입, 크기, 확장자 제한
- 경로 순회(Path Traversal) 방지 — `../` 포함 경로 거부

## 의존성 보안

- 알려진 취약점 있는 패키지 사용 금지
- `requirements.txt` / `package-lock.json` 에 버전 고정
- 의존성 추가 시 라이선스 및 유지보수 상태 확인

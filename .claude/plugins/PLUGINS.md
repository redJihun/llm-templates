# 설치된 플러그인 매니페스트

이 문서는 현재 프로필에 설치된 Claude Code 플러그인과 마켓플레이스를 재현 가능한 형태로 기록합니다.
새 환경(컨테이너 등)에서 동일한 플러그인 구성을 복원할 때 `install-plugins.sh`를 사용하세요.

> **스냅샷 기준일:** 2026-06-23
> **출처:** `~/.claude/plugins/installed_plugins.json`, `~/.claude/plugins/known_marketplaces.json`

---

## 마켓플레이스 (4개)

플러그인을 설치하려면 먼저 마켓플레이스를 등록해야 합니다.

| 마켓플레이스 | 소스 | 저장소 / URL |
|---|---|---|
| `claude-plugins-official` | github | `anthropics/claude-plugins-official` |
| `thedotmack` | github | `thedotmack/claude-mem` |
| `omc` | git | `https://github.com/Yeachan-Heo/oh-my-claudecode.git` |
| `claudenews` | github | `bhpark1013/claudenews` |

## 플러그인 (9개)

| 플러그인 | 마켓플레이스 | 버전 (스냅샷 시점) | 용도 |
|---|---|---|---|
| `frontend-design` | claude-plugins-official | `48aa43517886` | 고품질 프론트엔드 UI 생성 스킬 |
| `github` | claude-plugins-official | `48aa43517886` | GitHub PR/이슈 연동 |
| `playwright` | claude-plugins-official | `48aa43517886` | 브라우저 자동화 MCP (E2E 검증) |
| `superpowers` | claude-plugins-official | `5.0.7` | 스킬 오케스트레이션 (brainstorm/TDD/plan 등) |
| `claude-mem` | thedotmack | `12.1.0` | 세션 간 영속 메모리 + 검색 |
| `context7` | claude-plugins-official | `48aa43517886` | 라이브러리 최신 문서 조회 MCP |
| `oh-my-claudecode` | omc | `4.13.5` | 멀티 에이전트 오케스트레이션 레이어 (OMC) |
| `claude-md-management` | claude-plugins-official | `1.0.0` | CLAUDE.md 관리 |
| `claudenews` | claudenews | `0.17.0` | 상태표시줄 뉴스 피드 |

> 버전 컬럼은 스냅샷 시점 값입니다. 설치 시 마켓플레이스 최신본이 설치되므로,
> 정확히 동일한 버전이 필요하면 `gitCommitSha`로 고정하세요 (아래 참조).

### gitCommitSha (정확한 버전 고정용)

| 플러그인 | gitCommitSha |
|---|---|
| frontend-design | `104d39be10b7b1380b2ae23a387a11a297b599c3` |
| github | `104d39be10b7b1380b2ae23a387a11a297b599c3` |
| playwright | `104d39be10b7b1380b2ae23a387a11a297b599c3` |
| superpowers | `b7a8f76985f1e93e75dd2f2a3b424dc731bd9d37` |
| claude-mem | `cde4faae2f33f92d2092ca87537b17b837fdcfb7` |
| context7 | `48aa43517886014e90ee80a6461f9de75045369d` |
| oh-my-claudecode | `1e9f197bcc85602da87ad35b18d908a0575b8583` |
| claude-md-management | `48aa43517886014e90ee80a6461f9de75045369d` |
| claudenews | `de4e71dcde5b2472547a7092ed8f4bb028634e73` |

---

## 복원 방법

### 1. 자동 (권장)

```bash
bash install-plugins.sh
```

### 2. 수동 (claude CLI)

```bash
# 마켓플레이스 등록
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin marketplace add thedotmack/claude-mem
claude plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode.git
claude plugin marketplace add bhpark1013/claudenews

# 플러그인 설치
claude plugin install frontend-design@claude-plugins-official
claude plugin install github@claude-plugins-official
claude plugin install playwright@claude-plugins-official
claude plugin install superpowers@claude-plugins-official
claude plugin install claude-mem@thedotmack
claude plugin install context7@claude-plugins-official
claude plugin install oh-my-claudecode@omc
claude plugin install claude-md-management@claude-plugins-official
claude plugin install claudenews@claudenews
```

> **참고:** 플러그인 캐시(`~/.claude/plugins/cache/`)는 수백 MB에 달하고 git 추적에 부적합하므로
> 이 저장소에 실제 캐시 파일은 포함하지 않습니다. 위 매니페스트로 재설치하세요.

---

## MCP 서버 참고

`playwright`, `context7`, `claude-mem`, `oh-my-claudecode` 플러그인은 각자 MCP 서버를 번들로 제공합니다.
별도 MCP 서버를 직접 등록하려면 `../mcp/mcp-setup-guide.md`를 참조하세요.
설치 후 `claude` 세션에서 `/mcp`로 연결 상태를 확인할 수 있습니다.

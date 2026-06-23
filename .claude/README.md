# Claude Code Universal Templates

Claude Code 프로젝트에서 범용적으로 사용할 수 있는 컨텍스트, 룰, 메모리, 설정 템플릿 모음.

## 구조

```
.claude/
├── README.md                        # 이 파일
├── AUTHORING-GUIDE.md               # CLAUDE.md & Rules 작성 가이드 (효과적인 작성법)
├── CHEATSHEET.md                    # Claude Code 최적화 치트시트 (빠른 참조)
├── CLAUDE.template.md               # CLAUDE.md 범용 템플릿 (프로젝트 루트용)
├── plugins/                         # 설치된 플러그인 재현 (매니페스트 + 설치 스크립트)
│   ├── PLUGINS.md                   # 마켓플레이스 4개 + 플러그인 9개 매니페스트
│   └── install-plugins.sh           # 마켓플레이스 등록 + 플러그인 설치 자동화
├── rules/                           # .claude/rules/ 에 넣을 규칙 파일들 (4계층)
│   ├── critical-rules.md            # 보안·에러처리·Git·범위 (Layer 1, 항상 적용)
│   ├── communication-guide.md       # Claude 응답 스타일·프롬프팅
│   ├── workflow.md                  # 에이전트 팀 협업 워크플로우
│   ├── docs-management.md           # ADR 작성 기준·문서 인덱스 관리
│   └── docs/                        # 확장 가이드 (team-workflow-extended 등)
├── commands/                        # 커스텀 슬래시 명령어 (11개)
│   ├── task-plan.md / task-exec.md  # TASK.md 생성·실행 (Manager/Executor)
│   ├── dev-flow.md                  # 설계→구현→검증 디스패처
│   ├── command-create.md           # 새 커맨드 생성
│   ├── prompt-create.md            # 프롬프트 정제
│   ├── brainstorm.md / brainstorm-opus.md
│   ├── commit-message-suggest.md / squash-merge-suggest.md
│   └── work-log-create.md / work-log-close.md
├── skills/                          # 글로벌 커스텀 스킬 (5개) + 작성 가이드
│   ├── custom-skill-guide.md        # 커스텀 스킬 작성법
│   ├── convert-meeting-notes/       # 회의록 정리
│   ├── summarize-work-for-report/   # 비기술 독자용 작업 요약
│   ├── update-prd/                  # PRD/BACKLOG 갱신
│   ├── work-log-append/             # 주간 작업 로그 추가
│   ├── write-release-notes/         # 릴리즈 노트 작성
│   └── dev-flow/                    # dev-flow 스킬
├── agents/                          # 커스텀 에이전트
│   └── dispatcher.md                # 하네스 라우터/티어 로더
├── memory/                          # 메모리 시스템 템플릿
│   ├── MEMORY.template.md           # 메모리 인덱스 템플릿
│   └── examples/                    # 타입별 메모리 파일 예시 (4개)
├── settings/                        # 설정 파일 예시 (3개)
│   ├── global-settings.jsonc        # ~/.claude/settings.json 가이드
│   ├── project-settings.jsonc       # .claude/settings.json 가이드
│   └── keybindings.jsonc            # ~/.claude/keybindings.json 가이드
├── settings.json                    # 실제 글로벌 settings 예시
├── hooks/                           # Hook 설정 가이드 + 예시 (3개)
│   ├── hooks-guide.md               # Hook 시스템 상세 가이드
│   └── examples/                    # pre-edit-backup / post-bash-notify / post-edit-lint
├── mcp/                             # MCP 서버 설정
│   └── mcp-setup-guide.md           # MCP 연동 가이드
├── harnes_set/                      # 하네스 100케이스 셋
└── harnes_set_honesty/              # opus4.8 정직성 대응 하네스 셋
```

> **플러그인/스킬 복원:** 새 환경(컨테이너 등)에서 동일 구성을 복원하려면
> `plugins/PLUGINS.md`를 보고 `plugins/install-plugins.sh`를 실행한 뒤,
> `skills/` 디렉토리를 `~/.claude/skills/`로 복사하세요. 자세한 절차는 아래 [프로필 복원](#프로필-복원)을 참조하세요.

## 사용법

1. 필요한 파일을 자기 프로젝트에 복사
2. `{{placeholder}}` 부분을 프로젝트에 맞게 수정
3. CLAUDE.md → 프로젝트 루트, rules → `.claude/rules/`, settings → `.claude/`

## 핵심 원칙

- **토큰 경제학**: 매 턴마다 모든 컨텍스트가 로드되므로 간결하게 유지
- **구체성 > 일반론**: "코드를 잘 작성해줘"보다 "함수 500줄 이내, early return 사용" 이 효과적
- **반복 교정 방지**: 한 번 교정한 내용은 rules/feedback 메모리로 영구화
- **계층 활용**: CLAUDE.md(항상 로드) → rules(조건부) → memory(선택적)

## 프로필 복원

새 환경(컨테이너, 새 머신)에서 이 프로필을 복원하는 절차입니다.

```bash
# 1) Claude Code 설치
npm install -g @anthropic-ai/claude-code

# 2) 플러그인 + 마켓플레이스 복원 (PLUGINS.md 매니페스트 기반)
bash .claude/plugins/install-plugins.sh

# 3) 글로벌 커스텀 스킬 복원
cp -r .claude/skills/convert-meeting-notes \
      .claude/skills/summarize-work-for-report \
      .claude/skills/update-prd \
      .claude/skills/work-log-append \
      .claude/skills/write-release-notes \
      ~/.claude/skills/

# 4) (선택) 글로벌 settings·키바인딩 참고
#    settings/global-settings.jsonc, settings/keybindings.jsonc 참조하여 ~/.claude/ 에 반영

# 5) API 키만 별도 계정으로 오버라이드
export ANTHROPIC_API_KEY=sk-ant-xxx
```

> **무엇이 어디에 있나:**
> - 플러그인 설치 상태는 `~/.claude/plugins/installed_plugins.json`에 기록됩니다 → 이 저장소의 `plugins/PLUGINS.md`로 재현.
> - 글로벌 스킬은 `~/.claude/skills/<name>/SKILL.md` → 이 저장소의 `skills/`에 실제 파일 보관.
> - MCP 서버는 플러그인에 번들되거나 `~/.claude.json`의 `mcpServers`에 등록됩니다 → `mcp/mcp-setup-guide.md` 참조.
> - 플러그인 캐시(`~/.claude/plugins/cache/`)는 용량이 크고 재설치로 복원되므로 저장소에 포함하지 않습니다.

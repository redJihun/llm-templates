#!/usr/bin/env bash
# 설치된 Claude Code 플러그인 구성을 복원합니다.
# 출처 스냅샷: 2026-06-23 (PLUGINS.md 참조)
#
# 사용법:
#   bash install-plugins.sh
#
# 전제: claude CLI가 PATH에 있어야 합니다 (npm install -g @anthropic-ai/claude-code).

set -euo pipefail

echo "==> 마켓플레이스 등록"
declare -a MARKETPLACES=(
  "anthropics/claude-plugins-official"
  "thedotmack/claude-mem"
  "https://github.com/Yeachan-Heo/oh-my-claudecode.git"
  "bhpark1013/claudenews"
)
for mp in "${MARKETPLACES[@]}"; do
  echo "  - $mp"
  claude plugin marketplace add "$mp" || echo "    (이미 등록됨 또는 실패 — 건너뜀)"
done

echo "==> 플러그인 설치"
declare -a PLUGINS=(
  "frontend-design@claude-plugins-official"
  "github@claude-plugins-official"
  "playwright@claude-plugins-official"
  "superpowers@claude-plugins-official"
  "claude-mem@thedotmack"
  "context7@claude-plugins-official"
  "oh-my-claudecode@omc"
  "claude-md-management@claude-plugins-official"
  "claudenews@claudenews"
)
for p in "${PLUGINS[@]}"; do
  echo "  - $p"
  claude plugin install "$p" || echo "    (이미 설치됨 또는 실패 — 건너뜀)"
done

echo "==> 완료. 'claude plugin list'로 확인하세요."

#!/usr/bin/env bash
# Plays two bots against each other with the MIT 2026 engine.
# Usage: scripts/match.sh <bot_A_dir> <bot_B_dir> [rounds]
# Example: scripts/match.sh bots/juanbot references/ref1/python_toss_smallest 1000
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$(cd "$1" && pwd)"; B="$(cd "$2" && pwd)"; ROUNDS="${3:-1000}"
RUN="$ROOT/matches/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$RUN"
cp "$ROOT"/engine/{engine.py,pyproject.toml,uv.lock} "$RUN"/
cp -r "$A" "$RUN/A"; cp -r "$B" "$RUN/B"
sed -e 's#^PLAYER_1_PATH = .*#PLAYER_1_PATH = "./A"#' \
    -e 's#^PLAYER_2_PATH = .*#PLAYER_2_PATH = "./B"#' \
    -e "s#^NUM_ROUNDS = .*#NUM_ROUNDS = $ROUNDS#" "$ROOT/engine/config.py" > "$RUN/config.py"
[ -d "$ROOT/.venv" ] || (cd "$ROOT/engine" && UV_PROJECT_ENVIRONMENT="$ROOT/.venv" uv sync -q)
cd "$RUN" && PATH="$ROOT/.venv/bin:$PATH" python engine.py > engine.out 2>&1
grep "^Final" gamelog.txt
echo "Log: $RUN/gamelog.txt"

#!/usr/bin/env bash
# quickstart — 一日の始めにターミナルを開いたら 1 回だけ回す（alias: qs）。
#   1. ツールの更新（apt）          ← sudo
#   2. Claude Code の更新
#   3. Claude Science の更新
#   4. Google Drive（G:）を /mnt/g にマウント  ← sudo、WSL のときだけ（uva などでは飛ばす）
#   5. herdr の更新を確認（新しい版があれば聞いてから更新）して起動
# sudo のパスワードは最初に 1 回だけ聞く。途中で失敗した段があれば最後にまとめて表示し、
# herdr を起動するかを確認する（全部成功なら確認なしで起動）。
#
# 使い方: qs（dotfiles の setup.sh が ~/.local/bin/quickstart にリンクする）

set -uo pipefail

GDRIVE_MOUNT=/mnt/g          # ~/.bash_aliases の gdrive と同じ
FAILED=()

step() { printf '\n\033[1m== %s\033[0m\n' "$1"; }
ok()   { printf '\033[32m-- ok\033[0m\n'; }
ng()   { printf '\033[31m-- failed: %s\033[0m\n' "$1"; FAILED+=("$1"); }

# sudo を先に通しておき、apt の間に期限が切れないよう裏で延長する
step "sudo"
if ! sudo -v; then
  echo "sudo が通らなかったので中止します" >&2
  exit 1
fi
( while true; do sleep 60; sudo -n true 2>/dev/null || exit; done ) &
SUDO_KEEPALIVE=$!
trap 'kill "$SUDO_KEEPALIVE" 2>/dev/null' EXIT

# 1. ツールの更新
step "1. apt update / upgrade"
if sudo apt-get update && sudo apt-get -y upgrade; then ok; else ng "apt"; fi
[ -f /var/run/reboot-required ] && echo "⚠ 再起動が必要な更新があります（WSL なら PowerShell で wsl --shutdown）"

# 2. Claude Code の更新
step "2. claude update"
if claude update; then ok; else ng "claude update"; fi

# 3. Claude Science の更新（デーモンが動いていると古いコードのまま。update 自身が再起動を促す）
step "3. claude-science update"
if claude-science update; then ok; else ng "claude-science update"; fi

# 4. Google Drive のマウント
#    /mnt/g は「マウント済みに見えて ls が No such device」になることがある（2026-09-09 実測）ので、
#    mountpoint ではなく実際に読めるかで判定し、死んでいれば外してから付け直す。
step "4. Google Drive → $GDRIVE_MOUNT"
if ! grep -qi microsoft /proc/version 2>/dev/null; then
  echo "WSL ではないので飛ばす"
elif ls "$GDRIVE_MOUNT/My Drive" >/dev/null 2>&1; then
  echo "マウント済み（読める）"; ok
else
  mountpoint -q "$GDRIVE_MOUNT" && { echo "マウントはあるが読めない → 外して付け直す"; sudo umount "$GDRIVE_MOUNT"; }
  [ -d "$GDRIVE_MOUNT" ] || sudo mkdir -p "$GDRIVE_MOUNT"
  if { sudo mount -t drvfs G: "$GDRIVE_MOUNT" -o "metadata,uid=$(id -u),gid=$(id -g)" 2>/dev/null \
       || sudo mount -t drvfs G: "$GDRIVE_MOUNT"; } && ls "$GDRIVE_MOUNT/My Drive" >/dev/null 2>&1; then
    ok
  else
    ng "Google Drive（Drive for Desktop は起動している？）"
  fi
fi

kill "$SUDO_KEEPALIVE" 2>/dev/null

# 5. herdr の更新の確認 → 起動
#    herdr の中から打ったときは更新しない（herdr 自身が「デタッチしてから herdr update」と案内する）。
#    新しい版があれば確認してから `herdr update --handoff`（動いているサーバーへ引き継ぐ）。
step "5. herdr"
if [ -n "${HERDR_ENV:-}" ]; then
  echo "herdr の中から実行されているので、herdr の更新と起動は飛ばす（デタッチしてから qs）"
  [ ${#FAILED[@]} -gt 0 ] && printf '\033[31m失敗した段: %s\033[0m\n' "${FAILED[*]}"
  exit 0
fi
herdr_cur=$(herdr --version 2>/dev/null | awk '{print $2}')
herdr_latest=$(curl -fsS --max-time 10 https://herdr.dev/latest.json 2>/dev/null | jq -r '.version // empty' 2>/dev/null)
if [ -z "$herdr_latest" ]; then
  ng "herdr の更新確認（herdr.dev に届かない）"
elif [ "$herdr_cur" != "$herdr_latest" ] \
     && [ "$(printf '%s\n%s\n' "$herdr_cur" "$herdr_latest" | sort -V | tail -1)" = "$herdr_latest" ]; then
  echo "herdr $herdr_cur → $herdr_latest"
  echo "  https://github.com/herdrdev/herdr/releases/tag/v$herdr_latest"
  read -r -p "herdr を更新しますか [y/N] " ans
  case "$ans" in
    [yY]*)
      if herdr update --handoff; then
        ok
        herdr status 2>/dev/null | grep -q 'restart_needed: yes' \
          && echo "⚠ サーバーの再起動が必要です（herdr server stop → herdr。中のペーンはすべて落ちる）"
      else
        ng "herdr update"
      fi ;;
    *) echo "更新しない" ;;
  esac
else
  echo "herdr $herdr_cur（最新）"; ok
fi

if [ ${#FAILED[@]} -gt 0 ]; then
  printf '\033[31m失敗した段: %s\033[0m\n' "${FAILED[*]}"
  read -r -p "herdr を起動しますか [Y/n] " ans
  case "$ans" in [nN]*) exit 1 ;; esac
fi
exec herdr

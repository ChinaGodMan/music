#!/bin/bash

OUTPUT_LOCAL="./readme.txt"
GIT_DIR="/storage/emulated/0/Download/gitrepos/music"
OUTPUT_GIT="$GIT_DIR/readme.txt"

generate_list() {
  files=$(find . -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.aac" -o -iname "*.ogg" \) ! -path "*ringtone*")

  # 总数（顶部）
  if [ -n "$files" ]; then
    count=$(echo "$files" | wc -l)
  else
    count=0
  fi

  echo "总数: $count"
  echo "----"

  # 文件列表
  if [ "$count" -gt 0 ]; then
    echo "$files" | while IFS= read -r f; do
      basename "$f"
    done | sort
  fi
}

if [ "$1" = "git" ]; then
  echo "写入仓库并提交..."

  generate_list | tee "$OUTPUT_GIT"

  cd "$GIT_DIR" || exit

  git add -A

  if ! git diff --cached --quiet; then
    echo "🚀 检测到变化，开始提交"
    git commit -m "docs(readme): 更新歌曲"
    git push
  else
    echo "✅ 没有变化，跳过 commit"
  fi

else
  echo "仅生成本地文件..."
  generate_list | tee "$OUTPUT_LOCAL"
fi
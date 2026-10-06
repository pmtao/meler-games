#!/bin/sh
# 发布动物狂飙世界（原名鹈鹕赛车）：
#   1. 重新打包游戏
#   2. 把运行时音频（配音 voice/、音乐和音效 music/）上传到 Cloudflare Pages 项目 pelican-racing-assets
#      （域名 https://pelican-racing-assets.melerpaine.com/，游戏发布到网上时从这里加载音频）
#   3. 把打包好的 HTML 复制到本站的 pelican-racing/index.html
# 先传音频、再换 HTML：新 HTML 用到的录音在它上线前就已经在 Cloudflare 上了。
# 网站仓库里不再放音频；以前留在 pelican-racing/music、pelican-racing/voice 的文件会被删掉（提交时一起删）。
#
# 用法：sh scripts/update-pelican-racing.sh [游戏源码目录，默认 ../pelican-racing]
#       SKIP_ASSETS=1 sh scripts/update-pelican-racing.sh   # 音频没变时跳过上传
# 需要先装好并登录 wrangler（npm install -g wrangler && wrangler login）。
set -e
cd "$(dirname "$0")/.."
SRC="${1:-../pelican-racing}"
PROJECT=pelican-racing-assets

(cd "$SRC" && python3 build.py)

if [ "${SKIP_ASSETS:-0}" != "1" ]; then
  (cd "$SRC" && python3 tools/prepare-assets.py)
  # wrangler 按文件内容跳过已经上传过的文件，只传有变化的
  (cd "$SRC" && wrangler pages deploy deploy-assets --project-name "$PROJECT" --branch main --commit-dirty=true)
  # 抽查几个文件确实能从线上取到（不是 404，也不是网页）。用 curl：Cloudflare 会拦 Python 默认的请求标识（403）
  (cd "$SRC" && find deploy-assets -name '*.m4a' -o -name '*.mp3' | sed 's#^deploy-assets/##' | sort -R | head -8) | while read -r p; do
    kind=$(curl -s -o /dev/null -w '%{http_code} %{content_type}' "https://pelican-racing-assets.melerpaine.com/$p")
    case "$kind" in "200 audio/"*) ;; *) echo "线上文件不对：$p → $kind"; exit 1;; esac
  done
  echo "线上抽查 8 个音频文件通过"
fi

cp "$SRC/dist/pelican-racing.html" pelican-racing/index.html
rm -rf pelican-racing/music pelican-racing/voice
echo "已更新 pelican-racing/index.html；确认无误后 git add -A pelican-racing、commit、push 发布"

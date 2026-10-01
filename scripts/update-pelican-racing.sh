#!/bin/sh
# 把动物狂飙世界（原名鹈鹕赛车）重新打包，复制到本站的 pelican-racing/index.html
# 用法：sh scripts/update-pelican-racing.sh [游戏源码目录，默认 ../pelican-racing]
set -e
cd "$(dirname "$0")/.."
SRC="${1:-../pelican-racing}"
(cd "$SRC" && python3 build.py)
cp "$SRC/dist/pelican-racing.html" pelican-racing/index.html
echo "已更新 pelican-racing/index.html，确认无误后 git add / commit / push 即可发布"

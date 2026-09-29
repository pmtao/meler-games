# Meler Games

打开浏览器就能玩的网页小游戏合集，通过 GitHub Pages 发布：<https://melerpaine.com/meler-games/>

| 游戏 | 地址 | 源码 |
| --- | --- | --- |
| 🏎️ 鹈鹕赛车 | <https://melerpaine.com/meler-games/pelican-racing/> | 本地 `pelican-racing` 工程（`python3 build.py` 打包成单个 HTML） |

## 目录结构

```
index.html                  游戏大厅首页
pelican-racing/
  index.html                鹈鹕赛车（打包好的单文件）
  cover.jpg                 首页卡片封面 / 分享图
scripts/
  update-pelican-racing.sh  重新打包并复制鹈鹕赛车
.nojekyll                   让 GitHub Pages 直接按原样发布文件（不经过 Jekyll 处理）
```

## 更新游戏

```bash
sh scripts/update-pelican-racing.sh      # 默认从 ../pelican-racing 打包
git add -A && git commit -m "更新鹈鹕赛车" && git push
```

推送到 `main` 分支后，GitHub Pages 一两分钟内自动更新。

## 添加新游戏

1. 新建一个目录（例如 `my-game/`），放入游戏的 `index.html`（尽量打包成单文件）和一张 1200×630 的 `cover.jpg`。
2. 在首页 `index.html` 的 `<main>` 里复制一张游戏卡片，改标题、介绍和链接。
3. 提交并推送。

## 首次开启 GitHub Pages

仓库 **Settings → Pages → Build and deployment**：Source 选 **Deploy from a branch**，分支选 **main**，目录选 **/ (root)**，保存。

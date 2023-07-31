#!/usr/bin/env sh

# 确保脚本抛出遇到的错误
set -e

# 构建项目
vitepress build

# 进入生成的文件夹
cd .vitepress/dist

# 如果是发布到自定义域名
# echo 'www.example.com' > CNAME

git add .
git commit -m "deploy"

# git push 推送到仓库
git push

cd -
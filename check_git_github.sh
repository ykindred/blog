#!/bin/bash

# 1. 获取本地 origin URL
remote_url=$(git remote get-url origin 2>/dev/null)

if [ -z "$remote_url" ]; then
    echo "❌ 本地没有设置 git remote origin"
    exit 1
fi

echo "🔍 本地 remote URL: $remote_url"

# 2. 提取 GitHub 用户名和仓库名
if [[ "$remote_url" =~ git@github.com:([^/]+)/(.+)\.git ]]; then
    username="${BASH_REMATCH[1]}"
    repo="${BASH_REMATCH[2]}"
else
    echo "❌ 远程地址不是 SSH 格式（git@github.com:username/repo.git）"
    exit 1
fi

echo "📦 检测仓库: $username/$repo"

# 3. 调用 GitHub API 检查仓库是否存在
status_code=$(curl -o /dev/null -s -w "%{http_code}" "https://api.github.com/repos/$username/$repo")

if [ "$status_code" -eq 200 ]; then
    echo "✅ GitHub 仓库存在"
elif [ "$status_code" -eq 404 ]; then
    echo "❌ 仓库不存在，请检查名字拼写和大小写"
else
    echo "⚠️ 无法确认仓库状态（HTTP $status_code）"
fi

# 4. 测试 SSH 连接
echo "🔐 测试 SSH 连接..."
ssh -T git@github.com 2>&1 | grep -E "successfully authenticated|Hi " >/dev/null
if [ $? -eq 0 ]; then
    echo "✅ SSH Key 连接正常"
else
    echo "❌ SSH Key 未配置或无权限"
fi

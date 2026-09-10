FROM node:20-slim

WORKDIR /app

# 安装解压与基础网络依赖
RUN apt-get update && apt-get install -y openssl curl procps ca-certificates unzip && rm -rf /var/lib/apt/lists/*

# 创建临时运行目录
RUN mkdir -p /app/.tmp

# 1. 构建期下载并提取 Xray-core
RUN curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v24.9.30/Xray-linux-64.zip && \
    unzip -q /tmp/xray.zip xray -d /tmp && \
    mv /tmp/xray /app/.tmp/web && \
    rm -f /tmp/xray.zip

# 2. 构建期下载 cloudflared
RUN curl -L -o /app/.tmp/bot https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64

# 3. 构建期下载并提取 nezha-agent (v1)
RUN curl -L -o /tmp/nezha.zip https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip && \
    unzip -q /tmp/nezha.zip nezha-agent -d /tmp && \
    mv /tmp/nezha-agent /app/.tmp/v1 && \
    rm -f /tmp/nezha.zip

# 拷贝代码与静态文件
COPY package*.json index.js index.html ./

# 赋予权限并安装 Node 依赖
RUN chmod -R 777 /app/.tmp && chmod +x index.js && npm install

EXPOSE 3000

CMD ["node", "index.js"]

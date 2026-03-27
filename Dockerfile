# Godot 4 Headless Server
# Render.com deployment
# Ports: 10000 (WebSocket) | 8080 (Health check)

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Godot 4 headless dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libgl1 \
    libglu1-mesa \
    libxcursor1 \
    libxinerama1 \
    libxrandr2 \
    libxi6 \
    libpulse0 \
    libasound2 \
    libfontconfig1 \
    libfreetype6 \
    libssl3 \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY godot_server /app/godot_server
COPY godot_server.pck /app/godot_server.pck

RUN chmod +x /app/godot_server

# user:// maps to this path for project name "headlessrender"
RUN mkdir -p /root/.local/share/godot/app_userdata/headlessrender/packages/

EXPOSE 10000
EXPOSE 8080

ENV PORT=10000

# Set in Render dashboard:
# FEEDER_SECRET = your secret key
# RENDER_EXTERNAL_URL is injected automatically by Render

CMD ["/app/godot_server", "--headless", "--main-pack", "/app/godot_server.pck"]

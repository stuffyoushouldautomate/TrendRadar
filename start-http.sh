#!/bin/bash

echo "╔════════════════════════════════════════╗"
echo "║  TrendRadar MCP Server (HTTP mode)    ║"
echo "╚════════════════════════════════════════╝"
echo ""

# Check virtual environment
if [ ! -d ".venv" ]; then
    echo "❌ [ERROR] Virtual environment not found"
    echo "Please run ./setup-mac.sh first to complete setup."
    echo ""
    exit 1
fi

echo "[Mode]  HTTP (suitable for remote access)"
echo "[URL]   http://localhost:3333/mcp"
echo "[Hint]  Press Ctrl+C to stop the server"
echo ""

uv run python -m mcp_server.server --transport http --host 0.0.0.0 --port 3333

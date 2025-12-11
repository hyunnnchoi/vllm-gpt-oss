#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.11] Start vLLM server with default scheduler

# Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.1-8B}"
HF_TOKEN="${HF_TOKEN:-}"

echo "================================================"
echo "  vLLM Server Start"
echo "================================================"
echo "Model: ${MODEL_NAME}"
echo "================================================"
echo ""

# Stop and remove existing container
echo "🛑 Stopping existing container..."
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true
echo "✅ Container cleaned up"
echo ""

# Create directories
echo "📁 Creating directories..."
mkdir -p vllm_logs benchmark_results
chmod 777 vllm_logs benchmark_results 2>/dev/null || true
echo "✅ Directories ready"
echo ""

# Start vLLM server
echo "🚀 Starting vLLM server with default scheduler..."
sudo docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN="${HF_TOKEN}" \
  ${IMAGE_NAME} \
  vllm serve ${MODEL_NAME} \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8

echo ""
echo "⏳ Waiting for server to start..."
echo "📋 Server logs:"
echo "================================================"

# Stream logs and wait for startup
sudo docker logs -f vllm 2>&1 &
LOG_PID=$!

# Wait for "Application startup complete" message
TIMEOUT=300
ELAPSED=0
READY=false

while [ $ELAPSED -lt $TIMEOUT ]; do
    if sudo docker logs vllm 2>&1 | grep -q "Application startup complete"; then
        READY=true
        echo ""
        echo "✅ Server is ready! (took ${ELAPSED} seconds)"
        sudo kill $LOG_PID 2>/dev/null || true
        break
    fi
    sleep 2
    ELAPSED=$((ELAPSED + 2))
    
    # Show progress every 10 seconds
    if [ $((ELAPSED % 10)) -eq 0 ]; then
        echo ""
        echo "  ... still waiting (${ELAPSED}s / ${TIMEOUT}s)"
    fi
done

if [ "$READY" = false ]; then
    sudo kill $LOG_PID 2>/dev/null || true
    echo ""
    echo "❌ Server startup timeout after ${TIMEOUT} seconds"
    echo "💡 Check logs: sudo docker logs vllm"
    exit 1
fi

echo ""
echo "================================================"
echo ""

# Verify server
echo "🔍 Verifying server..."
curl -s http://localhost:8000/v1/models && echo "✅ Server API is working" || echo "⚠️ Server API not responding"

echo ""
echo "================================================"
echo "  Server Ready"
echo "================================================"
echo ""
echo "💡 Commands:"
echo "  - Run benchmark: bash vllm-bench-run.sh"
echo "  - View logs: sudo docker logs -f vllm"
echo "  - Stop server: sudo docker stop vllm"
echo ""


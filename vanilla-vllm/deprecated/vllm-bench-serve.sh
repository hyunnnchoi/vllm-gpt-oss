#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.11] Simple vLLM bench serve with default scheduler

# Usage: 1. bash vanilla_vllm.sh 2. vllm-bench-serve.sh

# Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.1-8B}"
HF_TOKEN="${HF_TOKEN:-}"
NUM_PROMPTS="${NUM_PROMPTS:-200}"

echo "================================================"
echo "  vLLM Bench Serve - Simple Version"
echo "================================================"
echo "Model: ${MODEL_NAME}"
echo "Num Prompts: ${NUM_PROMPTS}"
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

# Start vLLM server with default scheduler
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
TIMEOUT=180
ELAPSED=0
while [ $ELAPSED -lt $TIMEOUT ]; do
    if sudo docker logs vllm 2>&1 | grep -q "Application startup complete"; then
        echo ""
        echo "✅ Server is ready! (took ${ELAPSED} seconds)"
        sudo kill $LOG_PID 2>/dev/null || true
        break
    fi
    sleep 2
    ELAPSED=$((ELAPSED + 2))
done

if [ $ELAPSED -ge $TIMEOUT ]; then
    sudo kill $LOG_PID 2>/dev/null || true
    echo ""
    echo "⚠️ Timeout reached, but continuing..."
fi

echo ""
echo "================================================"

# Verify server
echo ""
echo "🔍 Verifying server..."
curl -s http://localhost:8000/v1/models && echo "✅ Server is ready" || echo "⚠️ Server not ready"
echo ""

# Run benchmark
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="benchmark_results/bench_serve_${TIMESTAMP}.log"

echo "================================================"
echo "  Running Benchmark"
echo "================================================"
echo "Log: ${LOG_FILE}"
echo ""

sudo docker exec vllm vllm bench serve \
  --endpoint /v1/completions \
  --backend openai \
  --model ${MODEL_NAME} \
  --dataset-name sonnet \
  --sonnet-input-len 512 \
  --sonnet-output-len 256 \
  --num-prompts ${NUM_PROMPTS} \
  --port 8000 \
  2>&1 | sudo tee "${LOG_FILE}"

echo ""
echo "================================================"
echo "  Completed"
echo "================================================"
echo "Results: ${LOG_FILE}"

# Fix ownership
sudo chown $USER:$USER "${LOG_FILE}" 2>/dev/null || true

echo ""
echo "💡 Commands:"
echo "  - View logs: sudo docker logs vllm"
echo "  - Stop: sudo docker stop vllm"
echo ""


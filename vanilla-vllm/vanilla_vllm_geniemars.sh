#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.08] vLLM with GenieMars image (auto-updates code on startup)

# [NOTE, hyunnnchoi, 2025.12.08] Basic configuration
IMAGE_NAME="${IMAGE_NAME:-vllm-geniemars:latest}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.2-1B}"
HF_TOKEN="${HF_TOKEN:-}"

# [NOTE, hyunnnchoi, 2025.12.08] Repository configuration (optional override)
VLLM_REPO="${VLLM_REPO:-https://github.com/hyunnnchoi/vllm.git}"
VLLM_REF="${VLLM_REF:-main}"
LMCACHE_REPO="${LMCACHE_REPO:-https://github.com/hyunnnchoi/LMCache.git}"
LMCACHE_REF="${LMCACHE_REF:-dev}"

echo "================================================"
echo "  vLLM GenieMars Deployment"
echo "================================================"
echo "Image: ${IMAGE_NAME}"
echo "Model: ${MODEL_NAME}"
echo "vLLM Repo: ${VLLM_REPO} (${VLLM_REF})"
echo "LMCache Repo: ${LMCACHE_REPO} (${LMCACHE_REF})"
echo "================================================"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Stop and remove existing container
echo "🛑 Stopping existing container..."
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true
echo "✅ Container cleaned up"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Create log and report directories
echo "📁 Creating directories..."
mkdir -p vllm_logs
mkdir -p nsys_reports
echo "✅ Directories ready"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Start vLLM server with GenieMars image
# This image will automatically clone and sync the latest code on startup
echo "🚀 Starting vLLM server with GenieMars image..."
sudo docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v /home/xsailor6/hmchoi/ELIS/data:/data \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_REPO="${VLLM_REPO}" \
  -e VLLM_REF="${VLLM_REF}" \
  -e LMCACHE_REPO="${LMCACHE_REPO}" \
  -e LMCACHE_REF="${LMCACHE_REF}" \
  -e VLLM_LOGGING_LEVEL=DEBUG \
  ${IMAGE_NAME} \
  vllm serve ${MODEL_NAME} \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8

echo ""
echo "⏳ Waiting for code update and server startup..."
sleep 10

# [NOTE, hyunnnchoi, 2025.12.08] Check code update status
echo ""
echo "🔍 Checking code update status..."
sudo docker logs vllm 2>&1 | grep -E "(vLLM updated|LMCache updated|commit)" | head -5

echo ""
echo "================================================"
echo "  Server Status"
echo "================================================"
sudo docker ps | grep vllm
echo ""

echo "💡 Useful commands:"
echo "  - View logs: sudo docker logs -f vllm"
echo "  - Check updates: sudo docker logs vllm 2>&1 | grep -E '(vLLM|LMCache) updated'"
echo "  - Test server: curl http://localhost:8000/v1/models"
echo "  - Stop server: sudo docker stop vllm"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Follow logs in real-time
read -p "📊 Follow logs in real-time? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo docker logs -f vllm
fi


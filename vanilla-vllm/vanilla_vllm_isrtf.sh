#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.07] vLLM with ISRTF scheduling and ELIS predictor

# [NOTE, hyunnnchoi, 2025.12.07] Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.1-8B}"
HF_TOKEN="${HF_TOKEN:-}"

# [NOTE, hyunnnchoi, 2025.12.07] ELIS predictor configuration
ELIS_CHECKPOINT="${ELIS_CHECKPOINT:-/ELIS/train/checkpoints/latest_model.pt}"
ELIS_BGE_MODEL="${ELIS_BGE_MODEL:-BAAI/bge-base-en-v1.5}"
ELIS_PREDICTION_INTERVAL="${ELIS_PREDICTION_INTERVAL:-50}"
ELIS_PATH="${ELIS_PATH:-/ELIS}"

echo "================================================"
echo "  vLLM with ISRTF Scheduling + ELIS Predictor"
echo "================================================"
echo "Model: ${MODEL_NAME}"
echo "ELIS Checkpoint: ${ELIS_CHECKPOINT}"
echo "BGE Model: ${ELIS_BGE_MODEL}"
echo "Prediction Interval: ${ELIS_PREDICTION_INTERVAL} tokens"
echo "================================================"
echo ""

# [NOTE, hyunnnchoi, 2025.12.07] Stop and remove existing container
echo "🛑 Stopping existing container..."
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true
echo "✅ Container cleaned up"
echo ""

# [NOTE, hyunnnchoi, 2025.12.07] Create log and report directories
echo "📁 Creating directories..."
mkdir -p vllm_logs
mkdir -p nsys_reports
echo "✅ Directories ready"
echo ""

# [NOTE, hyunnnchoi, 2025.12.07] Start vLLM server with ISRTF scheduling
echo "🚀 Starting vLLM server with ISRTF scheduling..."
sudo docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v /home/xsailor6/hmchoi/ELIS:/ELIS \
  -v /home/xsailor6/hmchoi/ELIS/data:/data \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_LOGGING_LEVEL=DEBUG \
  -e VLLM_ELIS_CHECKPOINT="${ELIS_CHECKPOINT}" \
  -e VLLM_ELIS_BGE_MODEL="${ELIS_BGE_MODEL}" \
  -e VLLM_ELIS_PREDICTION_INTERVAL="${ELIS_PREDICTION_INTERVAL}" \
  -e VLLM_ELIS_PATH="${ELIS_PATH}" \
  ${IMAGE_NAME} \
  vllm serve ${MODEL_NAME} \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8 \
  --scheduling-policy isrtf

echo ""
echo "⏳ Waiting for server to start..."
sleep 5

# [NOTE, hyunnnchoi, 2025.12.07] Check if ELIS predictor is loaded
echo ""
echo "🔍 Checking ELIS predictor initialization..."
sudo docker logs vllm 2>&1 | grep -i "ELIS" | head -10

echo ""
echo "================================================"
echo "  Server Status"
echo "================================================"
sudo docker ps | grep vllm
echo ""

echo "💡 Useful commands:"
echo "  - View logs: sudo docker logs -f vllm"
echo "  - Check ELIS logs: sudo docker logs vllm 2>&1 | grep ELIS"
echo "  - Test server: curl http://localhost:8000/v1/models"
echo "  - Stop server: sudo docker stop vllm"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Follow logs in real-time with tee to save logs
read -p "📊 Follow logs in real-time? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    LOG_FILE="vllm_logs/vllm_$(date +%Y%m%d_%H%M%S).log"
    echo "💾 Logs will be saved to: ${LOG_FILE}"
    sudo docker logs -f vllm 2>&1 | tee "${LOG_FILE}"
fi


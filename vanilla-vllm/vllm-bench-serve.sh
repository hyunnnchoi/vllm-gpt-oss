#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.11] Run vLLM benchmark (server must be running)
# Usage: 1. bash vanilla_vllm.sh 2. vllm-bench-serve.sh

# Configuration
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.1-8B}"
NUM_PROMPTS="${NUM_PROMPTS:-1000}"  # [NOTE, hyunnnchoi, 2025.12.11] Increased from 200 to 1000 for HOL blocking test
DATASET_NAME="${DATASET_NAME:-random}"  # random (default), sharegpt
REQUEST_RATE="${REQUEST_RATE:-20.0}"  # [NOTE, hyunnnchoi, 2025.12.11] Requests per second to stress test

# Dataset-specific options
RANDOM_INPUT_LEN="${RANDOM_INPUT_LEN:-1024}"  # [NOTE, hyunnnchoi, 2025.12.11] Increased from 512 to 1024
RANDOM_OUTPUT_LEN="${RANDOM_OUTPUT_LEN:-512}"  # [NOTE, hyunnnchoi, 2025.12.11] Increased from 256 to 512

SHAREGPT_PATH="${SHAREGPT_PATH:-/vllm/benchmarks/sharegpt_1024.json}"

echo "================================================"
echo "  vLLM Benchmark (HOL Blocking Stress Test)"
echo "================================================"
echo "Model: ${MODEL_NAME}"
echo "Dataset: ${DATASET_NAME}"
echo "Num Prompts: ${NUM_PROMPTS}"
echo "Request Rate: ${REQUEST_RATE} req/s"
if [ "${DATASET_NAME}" = "random" ]; then
    echo "  - Input Length: ${RANDOM_INPUT_LEN}"
    echo "  - Output Length: ${RANDOM_OUTPUT_LEN}"
elif [ "${DATASET_NAME}" = "sharegpt" ]; then
    echo "  - Dataset Path: ${SHAREGPT_PATH}"
fi
echo "================================================"
echo ""

# Check if server is running
if ! sudo docker ps | grep -q vllm; then
    echo "❌ vLLM server is not running!"
    echo "💡 Start server first: bash vllm-server-start.sh"
    exit 1
fi

# Verify server is responding
echo "🔍 Checking server status..."
if ! curl -s http://localhost:8000/v1/models > /dev/null; then
    echo "⚠️ Server is not responding"
    echo "💡 Check logs: sudo docker logs vllm"
    exit 1
fi
echo "✅ Server is ready"
echo ""

# Create benchmark results directory
mkdir -p benchmark_results

# Prepare dataset arguments
if [ "${DATASET_NAME}" = "random" ]; then
    DATASET_ARGS="--dataset-name random --random-input-len ${RANDOM_INPUT_LEN} --random-output-len ${RANDOM_OUTPUT_LEN}"
elif [ "${DATASET_NAME}" = "sharegpt" ]; then
    DATASET_ARGS="--dataset-name sharegpt --dataset-path ${SHAREGPT_PATH}"
else
    echo "❌ Unknown dataset: ${DATASET_NAME}"
    echo "Available datasets: random, sharegpt"
    exit 1
fi

# Run benchmark
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="benchmark_results/bench_serve_${DATASET_NAME}_${TIMESTAMP}.log"

echo "================================================"
echo "  Running Benchmark"
echo "================================================"
echo "Log: ${LOG_FILE}"
echo ""

sudo docker exec vllm vllm bench serve \
  --backend openai \
  --model ${MODEL_NAME} \
  ${DATASET_ARGS} \
  --num-prompts ${NUM_PROMPTS} \
  --request-rate ${REQUEST_RATE} \
  2>&1 | tee "${LOG_FILE}"

echo ""
echo "================================================"
echo "  Completed"
echo "================================================"
echo "Results: ${LOG_FILE}"
echo ""

# Fix ownership
sudo chown $USER:$USER "${LOG_FILE}" 2>/dev/null || true

echo "💡 Commands:"
echo "  - View logs: cat ${LOG_FILE}"
echo "  - Run again: bash vllm-bench-run.sh"
echo "  - Stop server: sudo docker stop vllm"
echo "  - Analyze HOL blocking: python ~/vllm/tools/analyze_hol_blocking.py ./hol_logs"
echo ""
echo "💡 Dataset options:"
echo "  - Random (default):  DATASET_NAME=random bash vllm-bench-run.sh"
echo "  - ShareGPT:          DATASET_NAME=sharegpt bash vllm-bench-run.sh"
echo ""
echo "💡 Stress test options (for HOL blocking):"
echo "  - Heavy load:    NUM_PROMPTS=1000 REQUEST_RATE=30 bash vllm-bench-run.sh"
echo "  - Extreme load:  NUM_PROMPTS=2000 REQUEST_RATE=50 RANDOM_INPUT_LEN=2048 bash vllm-bench-run.sh"
echo "  - Long requests: RANDOM_INPUT_LEN=2048 RANDOM_OUTPUT_LEN=1024 bash vllm-bench-run.sh"
echo ""


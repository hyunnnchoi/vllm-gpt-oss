#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.08] vLLM bench serve with ISRTF scheduling and ELIS predictor

# [NOTE, hyunnnchoi, 2025.12.08] Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.1-8B}"
HF_TOKEN="${HF_TOKEN:-hf_YOUR_TOKEN_HERE}"

# [NOTE, hyunnnchoi, 2025.12.08] ELIS predictor configuration
ELIS_CHECKPOINT="${ELIS_CHECKPOINT:-/ELIS/train/checkpoints/latest_model.pt}"
ELIS_BGE_MODEL="${ELIS_BGE_MODEL:-BAAI/bge-base-en-v1.5}"
ELIS_PREDICTION_INTERVAL="${ELIS_PREDICTION_INTERVAL:-50}"
ELIS_PATH="${ELIS_PATH:-/ELIS}"

# [NOTE, hyunnnchoi, 2025.12.08] Benchmark configuration
SCHEDULING_POLICY="${SCHEDULING_POLICY:-isrtf}"
DATASET_NAME="${DATASET_NAME:-sonnet}"  # sonnet (default), sharegpt, random
NUM_PROMPTS="${NUM_PROMPTS:-200}"

# [NOTE, hyunnnchoi, 2025.12.08] Dataset-specific configuration
if [ "${DATASET_NAME}" = "sharegpt" ]; then
    DATASET_PATH="${DATASET_PATH:-/vllm/benchmarks/sharegpt_1024.json}"
    DATASET_ARGS="--dataset-name sharegpt --dataset-path ${DATASET_PATH}"
elif [ "${DATASET_NAME}" = "sonnet" ]; then
    SONNET_INPUT_LEN="${SONNET_INPUT_LEN:-512}"
    SONNET_OUTPUT_LEN="${SONNET_OUTPUT_LEN:-256}"
    DATASET_ARGS="--dataset-name sonnet --sonnet-input-len ${SONNET_INPUT_LEN} --sonnet-output-len ${SONNET_OUTPUT_LEN}"
elif [ "${DATASET_NAME}" = "random" ]; then
    RANDOM_INPUT_LEN="${RANDOM_INPUT_LEN:-512}"
    RANDOM_OUTPUT_LEN="${RANDOM_OUTPUT_LEN:-256}"
    DATASET_ARGS="--dataset-name random --random-input-len ${RANDOM_INPUT_LEN} --random-output-len ${RANDOM_OUTPUT_LEN}"
else
    echo "❌ Unknown dataset: ${DATASET_NAME}"
    echo "Available datasets: sonnet, sharegpt, random"
    exit 1
fi

echo "================================================"
echo "  vLLM Bench Serve - ISRTF + ELIS"
echo "================================================"
echo "Model: ${MODEL_NAME}"
echo "Scheduling Policy: ${SCHEDULING_POLICY}"
echo "Dataset: ${DATASET_NAME}"
if [ "${DATASET_NAME}" = "sonnet" ]; then
    echo "  - Input Length: ${SONNET_INPUT_LEN}"
    echo "  - Output Length: ${SONNET_OUTPUT_LEN}"
elif [ "${DATASET_NAME}" = "random" ]; then
    echo "  - Input Length: ${RANDOM_INPUT_LEN}"
    echo "  - Output Length: ${RANDOM_OUTPUT_LEN}"
fi
echo "Num Prompts: ${NUM_PROMPTS}"
echo "ELIS Checkpoint: ${ELIS_CHECKPOINT}"
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
mkdir -p benchmark_results
# Fix permissions to allow container to write
chmod 777 vllm_logs benchmark_results 2>/dev/null || true
echo "✅ Directories ready"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Start vLLM server with ISRTF scheduling
echo "🚀 Starting vLLM server with ${SCHEDULING_POLICY} scheduling..."
sudo docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v /home/xsailor6/hmchoi/ELIS:/ELIS \
  -v /home/xsailor6/hmchoi/ELIS/data:/data \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -v $(pwd)/benchmark_results:/benchmark_results \
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
  --scheduling-policy ${SCHEDULING_POLICY}

echo ""
echo "⏳ Waiting for server to start..."
echo "📋 Server logs:"
echo "================================================"

# [NOTE, hyunnnchoi, 2025.12.08] Stream logs in real-time and wait for startup
TIMESTAMP_LOG=$(date +%Y%m%d_%H%M%S)
SERVER_LOG="vllm_logs/server_${TIMESTAMP_LOG}.log"

# Start logging in background and save to file
sudo docker logs -f vllm 2>&1 | sudo tee "${SERVER_LOG}" &
LOG_PID=$!

# Wait for "Application startup complete" message
echo ""
echo "⏳ Waiting for 'Application startup complete' message..."
TIMEOUT=300  # 5 minutes timeout
ELAPSED=0
READY=false

while [ $ELAPSED -lt $TIMEOUT ]; do
    if sudo docker logs vllm 2>&1 | grep -q "Application startup complete"; then
        READY=true
        echo "✅ Server is ready! (took ${ELAPSED} seconds)"
        break
    fi
    sleep 2
    ELAPSED=$((ELAPSED + 2))
    
    # Show progress every 10 seconds
    if [ $((ELAPSED % 10)) -eq 0 ]; then
        echo "  ... still waiting (${ELAPSED}s / ${TIMEOUT}s)"
    fi
done

# Stop the log streaming
sudo kill $LOG_PID 2>/dev/null || true

# Fix log file ownership
if [ -f "${SERVER_LOG}" ]; then
    sudo chown $USER:$USER "${SERVER_LOG}" 2>/dev/null || true
fi

if [ "$READY" = false ]; then
    echo "❌ Server startup timeout after ${TIMEOUT} seconds"
    echo "💡 Check logs: sudo docker logs vllm"
    exit 1
fi

echo ""
echo "================================================"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Verify server is responding
echo "🔍 Verifying server is responding..."
curl -s http://localhost:8000/v1/models && echo "✅ Server API is working" || echo "⚠️ Server API not responding"
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Check ELIS predictor initialization
echo "🔍 Checking ELIS predictor initialization..."
sudo docker logs vllm 2>&1 | grep -i "ELIS" | head -10
echo ""

# [NOTE, hyunnnchoi, 2025.12.08] Prepare ShareGPT dataset if needed
if [ "${DATASET_NAME}" = "sharegpt" ]; then
    echo "📥 Checking ShareGPT dataset..."
    
    # Check if dataset exists in container
    DATASET_EXISTS=$(sudo docker exec vllm test -f ${DATASET_PATH} && echo "yes" || echo "no")
    
    if [ "${DATASET_EXISTS}" = "no" ]; then
        echo "⚠️  ShareGPT dataset not found. Downloading and preprocessing..."
        echo ""
        
        # Download ShareGPT dataset (original format for bench serve)
        sudo docker exec vllm bash -c "
            cd /vllm/benchmarks
            
            # Download raw ShareGPT data (original format, not converted)
            echo '📥 Downloading ShareGPT dataset...'
            wget -q --show-progress -O sharegpt_1024.json \
                https://huggingface.co/datasets/philschmid/sharegpt-raw/resolve/main/sharegpt_20230401_clean_lang_split.json
            
            # Check result
            echo '✅ ShareGPT dataset downloaded:'
            ls -lh sharegpt_1024.json
            echo 'Note: vllm bench serve uses original ShareGPT format (not OpenAI converted)'
        "
        
        echo ""
        echo "✅ Dataset preparation completed"
    else
        echo "✅ ShareGPT dataset already exists"
    fi
    echo ""
fi

# [NOTE, hyunnnchoi, 2025.12.08] Run benchmark serve
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="benchmark_results/bench_serve_${SCHEDULING_POLICY}_${TIMESTAMP}.log"

echo "================================================"
echo "  Running Benchmark"
echo "================================================"
echo "Log will be saved to: ${LOG_FILE}"
echo ""

sudo docker exec vllm vllm bench serve \
  --endpoint /v1/completions \
  --backend openai \
  --model ${MODEL_NAME} \
  ${DATASET_ARGS} \
  --num-prompts ${NUM_PROMPTS} \
  --port 8000 \
  2>&1 | sudo tee "${LOG_FILE}"

echo ""
echo "================================================"
echo "  Benchmark Completed"
echo "================================================"
echo "Results saved to: ${LOG_FILE}"

# [NOTE, hyunnnchoi, 2025.12.08] Fix file ownership
if [ -f "${LOG_FILE}" ]; then
    sudo chown $USER:$USER "${LOG_FILE}" 2>/dev/null || true
fi
sudo chown -R $USER:$USER vllm_logs/ benchmark_results/ 2>/dev/null || true
echo ""
echo "💡 Useful commands:"
echo "  - View server logs: sudo docker logs vllm"
echo "  - Stop server: sudo docker stop vllm"
echo ""
echo "💡 Dataset options:"
echo "  - Sonnet (default):   DATASET_NAME=sonnet bash vllm-bench-serve.sh"
echo "  - ShareGPT:           DATASET_NAME=sharegpt bash vllm-bench-serve.sh"
echo "  - Random:             DATASET_NAME=random bash vllm-bench-serve.sh"
echo ""
echo "💡 Scheduling policy options:"
echo "  - ISRTF (default):    SCHEDULING_POLICY=isrtf bash vllm-bench-serve.sh"
echo "  - FCFS:               SCHEDULING_POLICY=fcfs bash vllm-bench-serve.sh"
echo ""


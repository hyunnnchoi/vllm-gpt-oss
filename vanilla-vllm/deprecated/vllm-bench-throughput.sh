#!/bin/bash
# [NOTE, hyunnnchoi, 2025.11.13] Custom vllm + LMCache image without baked model

# [NOTE, hyunnnchoi, 2025.11.13] Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
# {meta/llama-7b, meta/llama-13b, huggyllama/llama2-7b, huggyllama/llama2-13b, Facebook/opt-6.7b, Facebook/opt-13b, LMSYS/vicuna-7b, LMSYS/vicuna-13b, Facebook/OPT-1B, Facebook/OPT-3B, Facebook/OPT-7B, Facebook/OPT-13B, EleutherAI/GPT-NeoX, Google/Gemma-7B, Upstage/SOLAR-11B}
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.2-1B}" 
# MODEL_NAME="${MODEL_NAME:-facebook/opt-6.7b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-facebook/opt-2.7b}" 
# MODEL_NAME="${MODEL_NAME:-facebook/opt-13b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-2-13b-hf}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-2-7b-hf}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-lmsys/vicuna-13b-v1.5}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-lmsys/vicuna-7b-v1.5}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-huggyllama/llama-7b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-huggyllama/llama-13b}" # 완료됨
MODEL_NAME="${MODEL_NAME:-facebook/opt-1.3b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-EleutherAI/gpt-neox-20b}"
# MODEL_NAME="${MODEL_NAME:-google/gemma-7b}"
# MODEL_NAME="${MODEL_NAME:-upstage/SOLAR-10.7B-v1.0}"


HF_TOKEN="${HF_TOKEN:-}"
VLLM_REF="${VLLM_REF:-main}"
LMCACHE_REF="${LMCACHE_REF:-dev}"

# Benchmark configuration
INPUT_LEN="${INPUT_LEN:-512}"
OUTPUT_LEN="${OUTPUT_LEN:-256}"
NUM_PROMPTS="${NUM_PROMPTS:-200}"

# [NOTE, hyunnnchoi, 2025.11.13] Stop and remove existing container
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true

# [NOTE, hyunnnchoi, 2025.11.13] Create log and report directories
mkdir -p vllm_logs
mkdir -p benchmark_results

# [NOTE, hyunnnchoi] Start container without vllm serve, just keep it running
sudo docker run -d --name vllm --gpus all --ipc=host \
  -v /home/xsailor6/hmchoi/ELIS/data:/data \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -v $(pwd)/benchmark_results:/benchmark_results \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_REF=${VLLM_REF} \
  -e LMCACHE_REF=${LMCACHE_REF} \
  -e VLLM_LOGGING_LEVEL=DEBUG \
  ${IMAGE_NAME} \
  tail -f /dev/null

echo "Container started. Waiting for it to be ready..."
sleep 3

# Run benchmark throughput
echo "Running benchmark throughput for ${MODEL_NAME}..."
sudo docker exec vllm vllm bench throughput \
  --model ${MODEL_NAME} \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8 \
  --input-len ${INPUT_LEN} \
  --output-len ${OUTPUT_LEN} \
  --num-prompts ${NUM_PROMPTS} \
  2>&1 | tee benchmark_results/${MODEL_NAME//\//_}_throughput.log

echo "Benchmark completed. Results saved to benchmark_results/"

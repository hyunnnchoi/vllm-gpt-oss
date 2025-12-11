#!/bin/bash
# [NOTE, hyunnnchoi, 2025.11.13] Custom vllm + LMCache image without baked model

# [NOTE, hyunnnchoi, 2025.11.13] Basic configuration
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0-debug}"
# {meta/llama-7b, meta/llama-13b, huggyllama/llama2-7b, huggyllama/llama2-13b, Facebook/opt-6.7b, Facebook/opt-13b, LMSYS/vicuna-7b, LMSYS/vicuna-13b, Facebook/OPT-1B, Facebook/OPT-3B, Facebook/OPT-7B, Facebook/OPT-13B, EleutherAI/GPT-NeoX, Google/Gemma-7B, Upstage/SOLAR-11B}
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.2-1B}" 
# MODEL_NAME="${MODEL_NAME:-facebook/opt-6.7b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-facebook/opt-13b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-2-13b-hf}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-2-7b-hf}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-lmsys/vicuna-13b-v1.5}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-lmsys/vicuna-7b-v1.5}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-huggyllama/llama-7b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-huggyllama/llama-13b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-facebook/opt-1.3b}" # 완료됨
# MODEL_NAME="${MODEL_NAME:-facebook/opt-2.7b}" # FlexAttention이라 터짐;; 안쓰는게 나을수도
# MODEL_NAME="${MODEL_NAME:-EleutherAI/gpt-neox-20b}"
# MODEL_NAME="${MODEL_NAME:-google/gemma-7b}"
MODEL_NAME="${MODEL_NAME:-upstage/SOLAR-10.7B-v1.0}"


HF_TOKEN="${HF_TOKEN:-hf_YOUR_TOKEN_HERE}"
VLLM_REF="${VLLM_REF:-main}"
LMCACHE_REF="${LMCACHE_REF:-dev}"
ENABLE_NSYS="${ENABLE_NSYS:-false}"

# [NOTE, hyunnnchoi, 2025.11.13] Stop and remove existing container
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true

# [NOTE, hyunnnchoi, 2025.11.13] Create log and report directories
mkdir -p vllm_logs
mkdir -p nsys_reports

# [NOTE, hyunnnchoi, 2025.11.13] Start vLLM server with TP=4
# [NOTE, hyunnnchoi, 2025.11.13] Added Huggingface cache mount to avoid re-downloading models
sudo docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v /home/xsailor6/hmchoi/ELIS/data:/data \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_REF=${VLLM_REF} \
  -e LMCACHE_REF=${LMCACHE_REF} \
  -e VLLM_LOGGING_LEVEL=DEBUG \
  ${IMAGE_NAME} \
  vllm serve ${MODEL_NAME} \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8

# [NOTE, hyunnnchoi, 2025.11.16] Start vLLM server with TP=2 using GPU 2-3 only
# sudo docker run -d --name vllm --gpus '"device=2,3"' --ipc=host \
#   -p 8000:8000 \
#   -v /home/xsailor6/hmchoi/ELIS/data:/data \
#   -v ~/.cache/huggingface:/root/.cache/huggingface \
#   -e HF_TOKEN="${HF_TOKEN}" \
#   -e VLLM_REF=${VLLM_REF} \
#   -e LMCACHE_REF=${LMCACHE_REF} \
#   -e VLLM_LOGGING_LEVEL=DEBUG \
#   ${IMAGE_NAME} \
#   vllm serve ${MODEL_NAME} \
#   --tensor-parallel-size 2 \
#   --gpu-memory-utilization 0.8

# [NOTE, hyunnnchoi, 2025.11.13] Follow logs in real-time
sudo docker logs -f vllm

#!/bin/bash
# [NOTE, hyunnnchoi, 2025.11.13] Custom vllm + LMCache 이미지를 사용한 벤치마크 스크립트

set -e

IMAGE_NAME="custom-vllm:latest"
MODEL_NAME="meta-llama/Llama-3.2-1B"
VLLM_REF="${VLLM_REF:-main}"
LMCACHE_REF="${LMCACHE_REF:-dev}"

# 기존 컨테이너 정지 및 삭제
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true

# nsys 리포트 저장 디렉토리 생성
mkdir -p nsys_reports

echo "=== Building custom vllm + LMCache image ==="
echo "VLLM_REF: ${VLLM_REF}"
echo "LMCACHE_REF: ${LMCACHE_REF}"
sudo docker build \
  --build-arg VLLM_REF=${VLLM_REF} \
  --build-arg LMCACHE_REF=${LMCACHE_REF} \
  -t ${IMAGE_NAME} \
  -f Dockerfile \
  .

echo ""
echo "=== Running vllm benchmark with nsys profiling ==="
# HF_TOKEN을 환경변수로 전달 (export HF_TOKEN=your_token 또는 .env 파일 사용)
sudo docker run --rm --gpus all --ipc=host \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_REF=${VLLM_REF} \
  -e LMCACHE_REF=${LMCACHE_REF} \
  -v $(pwd)/nsys_reports:/workspace/nsys_reports \
  ${IMAGE_NAME} \
  bash -c "nsys profile \
        --trace-fork-before-exec=true \
        --cuda-graph-trace=node \
        --output=/workspace/nsys_reports/vllm_bench \
        python3 -m vllm.entrypoints.openai.cli bench latency \
          --model ${MODEL_NAME} \
          --tensor-parallel-size 4 \
          --num-iters-warmup 5 \
          --num-iters 1 \
          --batch-size 16 \
          --input-len 512 \
          --output-len 8 \
          --gpu-memory-utilization 0.95"

echo ""
echo "=== Benchmark completed. Results saved to nsys_reports/ ==="
#!/bin/bash
# [NOTE, hyunnnchoi, 2025.11.13] Custom vllm + LMCache 이미지를 사용한 벤치마크 스크립트

set -e

# [NOTE, hyunnnchoi, 2025.11.13] 기본값 설정 (필요시 환경변수로 오버라이드 가능)
IMAGE_NAME="${IMAGE_NAME:-potato4332/vanilla-vllm:v0.11.0}"
MODEL_NAME="${MODEL_NAME:-meta-llama/Llama-3.2-1B}"
HF_TOKEN="${HF_TOKEN:-}"
VLLM_REF="${VLLM_REF:-main}"
LMCACHE_REF="${LMCACHE_REF:-dev}"
SKIP_BUILD="${SKIP_BUILD:-true}"

# 기존 컨테이너 정지 및 삭제
sudo docker stop vllm 2>/dev/null || true
sudo docker rm vllm 2>/dev/null || true

# nsys 리포트 저장 디렉토리 생성
mkdir -p nsys_reports

# SKIP_BUILD가 true가 아니면 빌드 수행
if [ "${SKIP_BUILD}" != "true" ]; then
  echo "=== Building custom vllm + LMCache image ==="
  echo "IMAGE_NAME: ${IMAGE_NAME}"
  echo "VLLM_REF: ${VLLM_REF}"
  echo "LMCACHE_REF: ${LMCACHE_REF}"
  sudo docker build \
    --build-arg VLLM_REF=${VLLM_REF} \
    --build-arg LMCACHE_REF=${LMCACHE_REF} \
    -t ${IMAGE_NAME} \
    -f Dockerfile \
    .
else
  echo "=== Skipping build, using existing image: ${IMAGE_NAME} ==="
fi

echo ""
echo "=== Starting container ==="
echo "Container name: vllm"
echo "Image: ${IMAGE_NAME}"
echo "Model: ${MODEL_NAME}"
echo ""

# [NOTE, hyunnnchoi, 2025.11.13] 컨테이너를 백그라운드로 실행
sudo docker run -d --name vllm --gpus all --ipc=host \
  -e HF_TOKEN="${HF_TOKEN}" \
  -e VLLM_REF=${VLLM_REF} \
  -e LMCACHE_REF=${LMCACHE_REF} \
  -v $(pwd)/nsys_reports:/workspace/nsys_reports \
  ${IMAGE_NAME} \
  sleep infinity

echo "=== Container started successfully ==="
echo ""
echo "컨테이너에 접속하려면:"
echo "  sudo docker exec -it vllm bash"
echo ""
echo "=== 컨테이너 안에서 실행할 명령어 예시 ==="
echo ""
echo "# 1. 기본 latency 벤치마크 (nsys 프로파일링 없이)"
echo "vllm bench latency \\"
echo "  --model ${MODEL_NAME} \\"
echo "  --tensor-parallel-size 4 \\"
echo "  --num-iters-warmup 5 \\"
echo "  --num-iters 1 \\"
echo "  --batch-size 16 \\"
echo "  --input-len 512 \\"
echo "  --output-len 8 \\"
echo "  --gpu-memory-utilization 0.95"
echo ""
echo "# 2. nsys 프로파일링과 함께 벤치마크 실행"
echo "TIMESTAMP=\$(date +%Y%m%d_%H%M%S)"
echo "nsys profile \\"
echo "  --trace-fork-before-exec=true \\"
echo "  --cuda-graph-trace=node \\"
echo "  --output=/workspace/nsys_reports/vllm_bench_\${TIMESTAMP} \\"
echo "  vllm bench latency \\"
echo "    --model ${MODEL_NAME} \\"
echo "    --tensor-parallel-size 4 \\"
echo "    --num-iters-warmup 5 \\"
echo "    --num-iters 1 \\"
echo "    --batch-size 16 \\"
echo "    --input-len 512 \\"
echo "    --output-len 8 \\"
echo "    --gpu-memory-utilization 0.95"
echo ""
echo "# 3. 다른 설정으로 실험하기"
echo "# - batch-size 변경: --batch-size 32"
echo "# - input/output 길이 변경: --input-len 1024 --output-len 128"
echo "# - TP 크기 변경: --tensor-parallel-size 2"
echo "# - prefix caching 활성화: --enable-prefix-caching"
echo ""
echo "=== 컨테이너 종료 ==="
echo "sudo docker stop vllm && sudo docker rm vllm"
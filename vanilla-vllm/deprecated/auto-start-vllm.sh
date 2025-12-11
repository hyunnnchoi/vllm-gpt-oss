#!/bin/bash
# [NOTE, hyunnnchoi, 2025.12.11] Auto-start script for vLLM in CSP GUI environment
# This script should be mounted to /workspace/auto-start.sh in the container
set -e

# Default values
: ${MODEL_NAME:=meta-llama/Llama-3.1-8B-Instruct}
: ${TENSOR_PARALLEL_SIZE:=4}
: ${GPU_MEMORY_UTILIZATION:=0.8}

echo "=== Auto-starting vLLM server ==="
echo "Model: $MODEL_NAME"
echo "Tensor Parallel Size: $TENSOR_PARALLEL_SIZE"
echo "GPU Memory Utilization: $GPU_MEMORY_UTILIZATION"

# Build and execute vllm serve command
exec vllm serve $MODEL_NAME \
  --tensor-parallel-size ${TENSOR_PARALLEL_SIZE} \
  --gpu-memory-utilization ${GPU_MEMORY_UTILIZATION}


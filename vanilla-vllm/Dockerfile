# [NOTE, hyunnnchoi, 2025.11.13] Custom vllm + LMCache image without baked model
FROM vllm/vllm-openai:v0.11.0

# ====== Build arguments / environment ======
ARG VLLM_REF=main
ARG LMCACHE_REF=dev

ENV HF_HUB_ENABLE_HF_TRANSFER=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# ====== Install base tools ======
RUN apt-get update && apt-get install -y --no-install-recommends \
    git wget ca-certificates curl build-essential \
    && rm -rf /var/lib/apt/lists/*

# ====== Install nsight-systems (nsys) for profiling ======
RUN apt-get update && \
    (apt-get install -y --no-install-recommends nsight-systems-cli || \
     (wget -qO - https://developer.download.nvidia.com/devtools/repos/ubuntu2204/amd64/nvidia.pub | apt-key add - && \
      echo 'deb https://developer.download.nvidia.com/devtools/repos/ubuntu2204/amd64/ /' > /etc/apt/sources.list.d/nsight.list && \
      apt-get update && \
      apt-get install -y nsight-systems-cli)) && \
    rm -rf /var/lib/apt/lists/*

# ====== Uninstall existing vLLM and install custom vLLM ======
RUN python3 -m pip uninstall -y vllm || true
RUN git clone https://github.com/hyunnnchoi/vllm.git /vllm
WORKDIR /vllm
RUN git checkout ${VLLM_REF} && \
    python3 -m pip install --no-cache-dir -e "."

# ====== Clone and install custom LMCache ======
# [NOTE, hyunnnchoi, 2025.11.13] Set TORCH_CUDA_ARCH_LIST to support various GPU architectures
# 7.0: V100, 7.5: T4/RTX 20xx, 8.0: A100, 8.6: RTX 30xx/A10/A30/A40, 8.9: RTX 40xx/L4/L40, 9.0: H100/H200
RUN git clone https://github.com/hyunnnchoi/LMCache.git /lmcache
WORKDIR /lmcache
RUN git checkout ${LMCACHE_REF} && \
    TORCH_CUDA_ARCH_LIST="7.0;7.5;8.0;8.6;8.9;9.0" python3 -m pip install --no-cache-dir -e "."

# ====== Default working directory ======
WORKDIR /workspace

# ====== Startup script to fetch latest code ======
# [NOTE, hyunnnchoi, 2025.11.13] Simplified startup script similar to Midm version
RUN cat <<'EOF' >/start.sh
#!/bin/bash
set -e
echo "=== Updating vLLM code ==="
cd /vllm
git fetch --all
git reset --hard origin/${VLLM_REF:-main}
git checkout ${VLLM_REF:-main}
echo "=== vLLM commit: $(git rev-parse HEAD) ==="

echo "=== Updating LMCache code ==="
cd /lmcache
git fetch --all
git reset --hard origin/${LMCACHE_REF:-dev}
git checkout ${LMCACHE_REF:-dev}
echo "=== LMCache commit: $(git rev-parse HEAD) ==="

echo "=== Starting vLLM server ==="
cd /workspace
exec "$@"
EOF

RUN chmod +x /start.sh

# ====== Use custom entrypoint ======
ENTRYPOINT ["/start.sh"]
CMD ["/bin/bash"]
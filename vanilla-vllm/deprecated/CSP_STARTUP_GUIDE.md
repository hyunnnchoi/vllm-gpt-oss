# CSP GUI 환경에서 vLLM 자동 실행 가이드

기존 이미지를 수정하지 않고 vLLM을 자동으로 실행하는 방법들입니다.

## 방법 1: Volume Mount로 Startup Script 제공 (권장)

가장 깔끔한 방법입니다. CSP에서 파일 업로드/mount를 지원한다면 이 방법을 사용하세요.

### 단계:

1. **`auto-start-vllm.sh` 파일을 CSP에 업로드**

2. **CSP GUI에서 다음과 같이 설정:**
   - Volume Mount: `auto-start-vllm.sh` → `/workspace/auto-start.sh`
   - 환경 변수:
     ```
     MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct
     TENSOR_PARALLEL_SIZE=4
     GPU_MEMORY_UTILIZATION=0.8
     HF_TOKEN=hf_xxxxx
     ```
   - Command Override: `/workspace/auto-start.sh` (가능한 경우)

### Backend.AI 예시:

```bash
# Volume mount 설정
/local/path/auto-start-vllm.sh:/workspace/auto-start.sh

# 환경 변수
MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct
TENSOR_PARALLEL_SIZE=4
GPU_MEMORY_UTILIZATION=0.8
HF_TOKEN=hf_xxxxx

# Bootstrap/Startup command (지원하는 경우)
/workspace/auto-start.sh
```

---

## 방법 2: 컨테이너 시작 후 수동 실행

CSP에서 터미널 접근이 가능하다면:

### 단계:

1. **컨테이너 실행 (기본 이미지 사용)**

2. **터미널에서 다음 스크립트 생성:**

```bash
cat > /workspace/start-vllm.sh <<'EOF'
#!/bin/bash
export MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct
export TENSOR_PARALLEL_SIZE=4
export GPU_MEMORY_UTILIZATION=0.8

vllm serve $MODEL_NAME \
  --tensor-parallel-size ${TENSOR_PARALLEL_SIZE} \
  --gpu-memory-utilization ${GPU_MEMORY_UTILIZATION}
EOF

chmod +x /workspace/start-vllm.sh
```

3. **실행:**

```bash
/workspace/start-vllm.sh
```

---

## 방법 3: 환경 변수 + Wrapper Script

일부 CSP는 컨테이너 내에서 특정 경로의 스크립트를 자동 실행합니다.

### 확인 사항:

- `/root/.bashrc` 또는 `/etc/profile.d/` 활용 가능 여부
- `BASH_ENV` 환경 변수 지원 여부

### 설정 예시:

```bash
# 환경 변수로 스크립트 경로 지정
BASH_ENV=/workspace/startup.sh

# startup.sh 파일을 volume mount
```

---

## 로컬 Docker 테스트

로컬에서 테스트할 때는 다음과 같이 실행:

```bash
# auto-start-vllm.sh를 직접 실행
docker run -d --name vllm --gpus all --ipc=host \
  -p 8000:8000 \
  -v $(pwd)/auto-start-vllm.sh:/workspace/auto-start.sh \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -e MODEL_NAME=meta-llama/Llama-3.1-8B-Instruct \
  -e TENSOR_PARALLEL_SIZE=4 \
  -e GPU_MEMORY_UTILIZATION=0.8 \
  -e HF_TOKEN=${HF_TOKEN} \
  vllm-geniemars:latest \
  /workspace/auto-start.sh
```

---

## 주의사항

1. **파일 권한**: mount된 스크립트가 실행 가능한지 확인 (`chmod +x`)
2. **경로**: CSP마다 기본 working directory가 다를 수 있음
3. **로그**: 실행 로그를 확인해서 오류 디버깅

---

## 각 CSP별 추천 방법

| CSP           | 권장 방법                      | 비고                           |
|---------------|-------------------------------|-------------------------------|
| Backend.AI    | 방법 1 (Volume + Bootstrap)    | Bootstrap script 기능 활용     |
| AWS SageMaker | 방법 1 (Volume + Entrypoint)   | Container definition에서 설정  |
| GCP Vertex AI | 방법 1 (Volume + Command)      | Custom container 설정          |
| Azure ML      | 방법 1 (Volume + Command)      | Environment configuration      |
| 기타          | 방법 2 (수동 실행)             | 터미널 접근 가능한 경우        |


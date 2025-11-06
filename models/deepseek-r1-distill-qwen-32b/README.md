# DeepSeek-R1-Distill-Qwen-32B Deployment

Docker deployment for DeepSeek-R1-Distill-Qwen-32B model using custom vLLM.

## Status

🚧 **In Development**

## Model Information

- **Model ID**: deepseek-ai/DeepSeek-R1-Distill-Qwen-32B
- **Parameters**: 32B
- **Served Name**: DeepSeek-R1-Distill-Qwen-32B

## Files

- `Dockerfile`: Docker image build configuration (to be completed)

## TODO

- [ ] Complete Dockerfile configuration
- [ ] Add model details
- [ ] Add launch scripts
- [ ] Test deployment
```
sudo docker build \
  --build-arg HF_TOKEN=$HUGGING_FACE_HUB_TOKEN \
  --build-arg VLLM_REF=main \
  -t potato4332/vllm-deepseek-r1:v0.0.1-debug .
```
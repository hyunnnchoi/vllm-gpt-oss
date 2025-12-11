### Your current environment

<details>
<summary>The output of <code>python collect_env.py</code></summary>

```text
Collecting environment information...
==============================
        System Info
==============================
OS                           : Ubuntu 22.04.5 LTS (x86_64)
GCC version                  : (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0
Clang version                : Could not collect
CMake version                : version 4.1.0
Libc version                 : glibc-2.35

==============================
       PyTorch Info
==============================
PyTorch version              : 2.8.0+cu128
Is debug build               : False
CUDA used to build PyTorch   : 12.8
ROCM used to build PyTorch   : N/A

==============================
      Python Environment
==============================
Python version               : 3.12.11 (main, Jun  4 2025, 08:56:18) [GCC 11.4.0] (64-bit runtime)
Python platform              : Linux-5.15.0-160-generic-x86_64-with-glibc2.35

==============================
       CUDA / GPU Info
==============================
Is CUDA available            : True
CUDA runtime version         : 12.8.93
CUDA_MODULE_LOADING set to   : LAZY
GPU models and configuration : 
GPU 0: NVIDIA A30
GPU 1: NVIDIA A30
GPU 2: NVIDIA A30
GPU 3: NVIDIA A30

Nvidia driver version        : 535.274.02
cuDNN version                : Could not collect
HIP runtime version          : N/A
MIOpen runtime version       : N/A
Is XNNPACK available         : True

==============================
          CPU Info
==============================
Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           46 bits physical, 57 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  96
On-line CPU(s) list:                     0-95
Vendor ID:                               GenuineIntel
Model name:                              Intel(R) Xeon(R) Gold 6342 CPU @ 2.80GHz
CPU family:                              6
Model:                                   106
Thread(s) per core:                      2
Core(s) per socket:                      24
Socket(s):                               2
Stepping:                                6
CPU max MHz:                             3500.0000
CPU min MHz:                             800.0000
BogoMIPS:                                5600.00
Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq dtes64 ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch cpuid_fault epb cat_l3 invpcid_single intel_ppin ssbd mba ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid cqm rdt_a avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb intel_pt avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local split_lock_detect wbnoinvd dtherm ida arat pln pts avx512vbmi umip pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg tme avx512_vpopcntdq la57 rdpid fsrm md_clear pconfig flush_l1d arch_capabilities
Virtualization:                          VT-x
L1d cache:                               2.3 MiB (48 instances)
L1i cache:                               1.5 MiB (48 instances)
L2 cache:                                60 MiB (48 instances)
L3 cache:                                72 MiB (2 instances)
NUMA node(s):                            2
NUMA node0 CPU(s):                       0-23,48-71
NUMA node1 CPU(s):                       24-47,72-95
Vulnerability Gather data sampling:      Mitigation; Microcode
Vulnerability Indirect target selection: Mitigation; Aligned branch/return thunks
Vulnerability Itlb multihit:             Not affected
Vulnerability L1tf:                      Not affected
Vulnerability Mds:                       Not affected
Vulnerability Meltdown:                  Not affected
Vulnerability Mmio stale data:           Mitigation; Clear CPU buffers; SMT vulnerable
Vulnerability Reg file data sampling:    Not affected
Vulnerability Retbleed:                  Not affected
Vulnerability Spec rstack overflow:      Not affected
Vulnerability Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl and seccomp
Vulnerability Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
Vulnerability Spectre v2:                Mitigation; Enhanced / Automatic IBRS; IBPB conditional; PBRSB-eIBRS SW sequence; BHI SW loop, KVM SW loop
Vulnerability Srbds:                     Not affected
Vulnerability Tsa:                       Not affected
Vulnerability Tsx async abort:           Not affected

==============================
Versions of relevant libraries
==============================
[pip3] flashinfer-python==0.3.1
[pip3] numpy==2.2.0
[pip3] nvidia-cublas-cu12==12.8.4.1
[pip3] nvidia-cuda-cupti-cu12==12.8.90
[pip3] nvidia-cuda-nvrtc-cu12==12.8.93
[pip3] nvidia-cuda-runtime-cu12==12.8.90
[pip3] nvidia-cudnn-cu12==9.10.2.21
[pip3] nvidia-cudnn-frontend==1.14.1
[pip3] nvidia-cufft-cu12==11.3.3.83
[pip3] nvidia-cufile-cu12==1.13.1.3
[pip3] nvidia-curand-cu12==10.3.9.90
[pip3] nvidia-cusolver-cu12==11.7.3.90
[pip3] nvidia-cusparse-cu12==12.5.8.93
[pip3] nvidia-cusparselt-cu12==0.7.1
[pip3] nvidia-ml-py==12.575.51
[pip3] nvidia-nccl-cu12==2.27.3
[pip3] nvidia-nvjitlink-cu12==12.8.93
[pip3] nvidia-nvshmem-cu12==3.4.5
[pip3] nvidia-nvtx-cu12==12.8.90
[pip3] pynvml==12.0.0
[pip3] pyzmq==27.1.0
[pip3] torch==2.8.0+cu128
[pip3] torchaudio==2.8.0+cu128
[pip3] torchvision==0.23.0+cu128
[pip3] transformers==4.57.0
[pip3] triton==3.4.0
[conda] Could not collect

==============================
         vLLM Info
==============================
ROCM Version                 : Could not collect
vLLM Version                 : 0.11.1.dev12+g5ded9e9aa (git sha: 5ded9e9aa)
vLLM Build Flags:
  CUDA Archs: Not Set; ROCm: Disabled
GPU Topology:
        GPU0    GPU1    GPU2    GPU3    NIC0    CPU Affinity    NUMA Affinity   GPU NUMA ID
GPU0     X      NV4     SYS     SYS     SYS     0-23,48-71      0               N/A
GPU1    NV4      X      SYS     SYS     SYS     0-23,48-71      0               N/A
GPU2    SYS     SYS      X      NV4     PXB     24-47,72-95     1               N/A
GPU3    SYS     SYS     NV4      X      PIX     24-47,72-95     1               N/A
NIC0    SYS     SYS     PXB     PIX      X 

Legend:

  X    = Self
  SYS  = Connection traversing PCIe as well as the SMP interconnect between NUMA nodes (e.g., QPI/UPI)
  NODE = Connection traversing PCIe as well as the interconnect between PCIe Host Bridges within a NUMA node
  PHB  = Connection traversing PCIe as well as a PCIe Host Bridge (typically the CPU)
  PXB  = Connection traversing multiple PCIe bridges (without traversing the PCIe Host Bridge)
  PIX  = Connection traversing at most a single PCIe bridge
  NV#  = Connection traversing a bonded set of # NVLinks

NIC Legend:

  NIC0: mlx5_0

==============================
     Environment Variables
==============================
NVIDIA_VISIBLE_DEVICES=all
NVIDIA_REQUIRE_CUDA=cuda>=12.8 brand=unknown,driver>=470,driver<471 brand=grid,driver>=470,driver<471 brand=tesla,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=vapps,driver>=470,driver<471 brand=vpc,driver>=470,driver<471 brand=vcs,driver>=470,driver<471 brand=vws,driver>=470,driver<471 brand=cloudgaming,driver>=470,driver<471 brand=unknown,driver>=535,driver<536 brand=grid,driver>=535,driver<536 brand=tesla,driver>=535,driver<536 brand=nvidia,driver>=535,driver<536 brand=quadro,driver>=535,driver<536 brand=quadrortx,driver>=535,driver<536 brand=nvidiartx,driver>=535,driver<536 brand=vapps,driver>=535,driver<536 brand=vpc,driver>=535,driver<536 brand=vcs,driver>=535,driver<536 brand=vws,driver>=535,driver<536 brand=cloudgaming,driver>=535,driver<536 brand=unknown,driver>=550,driver<551 brand=grid,driver>=550,driver<551 brand=tesla,driver>=550,driver<551 brand=nvidia,driver>=550,driver<551 brand=quadro,driver>=550,driver<551 brand=quadrortx,driver>=550,driver<551 brand=nvidiartx,driver>=550,driver<551 brand=vapps,driver>=550,driver<551 brand=vpc,driver>=550,driver<551 brand=vcs,driver>=550,driver<551 brand=vws,driver>=550,driver<551 brand=cloudgaming,driver>=550,driver<551 brand=unknown,driver>=560,driver<561 brand=grid,driver>=560,driver<561 brand=tesla,driver>=560,driver<561 brand=nvidia,driver>=560,driver<561 brand=quadro,driver>=560,driver<561 brand=quadrortx,driver>=560,driver<561 brand=nvidiartx,driver>=560,driver<561 brand=vapps,driver>=560,driver<561 brand=vpc,driver>=560,driver<561 brand=vcs,driver>=560,driver<561 brand=vws,driver>=560,driver<561 brand=cloudgaming,driver>=560,driver<561 brand=unknown,driver>=565,driver<566 brand=grid,driver>=565,driver<566 brand=tesla,driver>=565,driver<566 brand=nvidia,driver>=565,driver<566 brand=quadro,driver>=565,driver<566 brand=quadrortx,driver>=565,driver<566 brand=nvidiartx,driver>=565,driver<566 brand=vapps,driver>=565,driver<566 brand=vpc,driver>=565,driver<566 brand=vcs,driver>=565,driver<566 brand=vws,driver>=565,driver<566 brand=cloudgaming,driver>=565,driver<566
NCCL_VERSION=2.25.1-1
NVIDIA_DRIVER_CAPABILITIES=compute,utility
NVIDIA_PRODUCT_NAME=CUDA
VLLM_USAGE_SOURCE=production-docker-image
CUDA_VERSION=12.8.1
LD_LIBRARY_PATH=/usr/local/cuda/lib64
CUDA_HOME=/usr/local/cuda
CUDA_HOME=/usr/local/cuda
VLLM_LOGGING_LEVEL=DEBUG
PYTORCH_NVML_BASED_CUDA_CHECK=1
TORCHINDUCTOR_COMPILE_THREADS=1
CUDA_MODULE_LOADING=LAZY
```

</details>

### 🐛 Describe the bug

### OPT-2.7B OOM while OPT-6.7B works fine with identical settings

### Describe the bug

OPT-2.7B crashes with OOM error while the larger OPT-6.7B model runs successfully under identical configuration. This counterintuitive behavior suggests a memory allocation bug specific to smaller models.

### Observed Behavior

| Model | Status | Memory Usage | Throughput |
|-------|--------|--------------|------------|
| OPT-2.7B | ❌ OOM (crash on first step) | 23.46/23.50 GiB (99.8%) | N/A |
| OPT-6.7B | ✅ Success | Normal | 6.58 req/s |

**Key Issue**: The smaller 2.7B model exhausts nearly all GPU memory across all 4 GPUs and crashes on the **first decoding step** (step_counter=0), while the larger 6.7B model handles the same workload efficiently.

### Reproduction Script

```bash
# Works fine for OPT-6.7B, OOM for OPT-2.7B
sudo docker exec vllm vllm bench throughput \
  --model facebook/opt-2.7b \
  --tensor-parallel-size 4 \
  --gpu-memory-utilization 0.8 \
  --input-len 512 \
  --output-len 256 \
  --num-prompts 200
```

## Error Logs

### OPT-2.7B (Failure)

#### Memory Profiling at Initialization
```
[Worker_TP3 pid=540] DEBUG 11-19 21:09:35 [v1/worker/gpu_worker.py:297] Memory profiling takes 19.58 seconds. Total non KV cache memory: 1.56GiB; torch peak memory increase: 0.22GiB; non-torch forward increase memory: 0.09GiB; weights memory: 1.24GiB.
[Worker_TP3 pid=540] INFO 11-19 21:09:35 [v1/worker/gpu_worker.py:298] Available KV cache memory: 17.24 GiB
[EngineCore_DP0 pid=404] INFO 11-19 21:09:35 [v1/core/kv_cache_utils.py:1087] GPU KV cache size: 226,000 tokens
```

#### Timeline of KV Cache Usage Before Crash
```
INFO 11-19 21:10:03 [v1/metrics/loggers.py:127] Engine 000: Avg prompt throughput: 1818.8 tokens/s, Avg generation throughput: 8.9 tokens/s, Running: 65 reqs, Waiting: 135 reqs, GPU KV cache usage: 15.0%, Prefix cache hit rate: 0.0%
INFO 11-19 21:10:13 [v1/metrics/loggers.py:127] Engine 000: Avg prompt throughput: 6763.1 tokens/s, Avg generation throughput: 280.2 tokens/s, Running: 200 reqs, Waiting: 0 reqs, GPU KV cache usage: 47.0%, Prefix cache hit rate: 0.5%
INFO 11-19 21:10:23 [v1/metrics/loggers.py:127] Engine 000: Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 447.0 tokens/s, Running: 200 reqs, Waiting: 0 reqs, GPU KV cache usage: 49.2%, Prefix cache hit rate: 0.5%
INFO 11-19 21:10:34 [v1/metrics/loggers.py:127] Engine 000: Avg prompt throughput: 0.0 tokens/s, Avg generation throughput: 502.0 tokens/s, Running: 200 reqs, Waiting: 0 reqs, GPU KV cache usage: 51.3%, Prefix cache hit rate: 0.5%
OOM CRASH at 21:10:38 (KV cache: 52.17%)
```

#### OOM Error Details
```
ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671] torch.OutOfMemoryError: CUDA out of memory. Tried to allocate 40.00 MiB. GPU 0 has a total capacity of 23.50 GiB of which 31.19 MiB is free. Process 1620724 has 23.46 GiB memory in use. Of the allocated memory 21.18 GiB is allocated by PyTorch, with 1.78 GiB allocated in private pools (e.g., CUDA Graphs), and 856.57 MiB is reserved by PyTorch but unallocated. If reserved but unallocated memory is large try setting PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True to avoid fragmentation.  See documentation for Memory Management  (https://pytorch.org/docs/stable/notes/cuda.html#environment-variables)

[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671] WorkerProc hit an exception.
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671] Traceback (most recent call last):
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/executor/multiproc_executor.py", line 666, in worker_busy_loop
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     output = func(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]              ^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/utils/_contextlib.py", line 120, in decorate_context
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return func(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/worker/gpu_worker.py", line 447, in execute_model
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     output = self.model_runner.execute_model(scheduler_output,
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/utils/_contextlib.py", line 120, in decorate_context
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return func(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/worker/gpu_model_runner.py", line 2367, in execute_model
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     sampler_output = self._sample(logits, spec_decode_metadata)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/worker/gpu_model_runner.py", line 2061, in _sample
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     sampler_output = self.sampler(
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]                      ^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/nn/modules/module.py", line 1773, in _wrapped_call_impl
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return self._call_impl(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/nn/modules/module.py", line 1784, in _call_impl
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return forward_call(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/sample/sampler.py", line 100, in forward
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     sampled, processed_logprobs = self.sample(logits, sampling_metadata)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/sample/sampler.py", line 180, in sample
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     random_sampled, processed_logprobs = self.topk_topp_sampler(
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]                                          ^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/nn/modules/module.py", line 1773, in _wrapped_call_impl
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return self._call_impl(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/usr/local/lib/python3.12/dist-packages/torch/nn/modules/module.py", line 1784, in _call_impl
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return forward_call(*args, **kwargs)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/sample/ops/topk_topp_sampler.py", line 115, in forward_cuda
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     return self.forward_native(logits, generators, k, p)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]   File "/vllm/vllm/v1/sample/ops/topk_topp_sampler.py", line 96, in forward_native
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]     probs = logits.softmax(dim=-1, dtype=torch.float32)
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671]             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Worker_TP3 pid=540] ERROR 11-19 21:10:38 [v1/executor/multiproc_executor.py:671] torch.OutOfMemoryError: CUDA out of memory. Tried to allocate 40.00 MiB. GPU 3 has a total capacity of 23.50 GiB of which 31.19 MiB is free. Process 1620727 has 23.46 GiB memory in use. Of the allocated memory 21.18 GiB is allocated by PyTorch, with 1.78 GiB allocated in private pools (e.g., CUDA Graphs), and 856.57 MiB is reserved by PyTorch but unallocated. If reserved but unallocated memory is large try setting PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True to avoid fragmentation.  See documentation for Memory Management  (https://pytorch.org/docs/stable/notes/cuda.html#environment-variables)

[EngineCore_DP0 pid=404] ERROR 11-19 21:10:38 [logging_utils/dump_input.py:79] Dumping scheduler stats: SchedulerStats(num_running_reqs=200, num_waiting_reqs=0, step_counter=0, current_wave=0, kv_cache_usage=0.5217360521098839, prefix_cache_stats=PrefixCacheStats(reset=False, requests=0, queries=0, hits=0), spec_decoding_stats=None, kv_connector_stats=None, num_corrupted_reqs=0)
```

**All 4 GPUs show identical memory exhaustion** (23.46 GiB / 23.50 GiB used on each).

### OPT-6.7B (Success)

```
Processed prompts: 100%|██████████| 200/200 [00:29<00:00, 6.67it/s]
Throughput: 6.58 requests/s, 5055.47 total tokens/s, 1685.22 output tokens/s
Total num prompt tokens: 102394
Total num output tokens: 51200
```

## Expected Behavior

The smaller OPT-2.7B model should:
1. Use **less** memory than OPT-6.7B
2. Run successfully with the same configuration
3. Achieve higher throughput due to smaller size

## Additional Context

### Memory Allocation Anomaly
- **Expected**: Smaller model (2.7B) should use less memory than larger model (6.7B)
- **Actual**: 2.7B exhausts 99.8% of GPU memory with only 52% KV cache usage
- **Suspicious**: 1.78 GiB in "private pools (CUDA Graphs)" seems excessive for a 2.7B model

### Impact on Real Workloads
- OPT-2.7B: ~10 seconds per iteration (severely degraded)
- OPT-6.7B: ~1.5 seconds per iteration (normal performance)

### Hypothesis
The issue appears to be related to CUDA Graph memory pre-allocation or fragmentation, which affects smaller models disproportionately. The crash occurs when attempting to allocate a mere 40 MiB for softmax operation during the first decoding step, despite having allocated 17.24 GiB for KV cache with only 52% utilization.


### Before submitting a new issue...

- [x] Make sure you already searched for relevant issues, and asked the chatbot living at the bottom right corner of the [documentation page](https://docs.vllm.ai/en/latest/), which can answer lots of frequently asked questions.

---

**Note**: OPT-1.3B runs successfully with the same configuration, suggesting this issue is specific to certain model sizes rather than all small models.
#!/bin/bash
eval "$(conda shell.bash hook)"
conda activate vllm
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
clear
echo -e "Starting vLLM server"
echo -e "===================="
echo -e "\nOpenAI compatible API on $ip port 8000"
echo -e "Grabbing 8 GPUs from 2 different hosts in the cluster..."
echo -e "\n\n\n"
python -m vllm.entrypoints.openai.api_server --model /ai/models/Meta-Llama-3-8B-Instruct/ --api-key LLM --host $ip --port 8000 --tensor-parallel-size 8 --dtype=half --tensor-parallel-size 8

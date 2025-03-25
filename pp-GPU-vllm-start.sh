#!/bin/bash
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
clear
echo -e "Starting vLLM server"
echo -e "===================="
echo -e "\nOpenAI compatible API on $ip port 8000"
echo -e "Grabbing 4 GPUs from 2 different hosts in the cluster..."
echo -e "Using tensor parallel = 2 and pipeline parallel = 2"
echo -e "\n\n\n"
python -m vllm.entrypoints.openai.api_server --model /ai/models/NousResearch/Meta-Llama-3.1-70B-Instruct/ --api-key LLM --host $ip --port 8000 --tensor-parallel-size 2 --pipeline-parallel-size 2 --dtype=half 
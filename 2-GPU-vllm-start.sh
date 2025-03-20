#!/bin/bash
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
clear
echo "Starting vLLM server with OpenAI compatible API on $ip port 8000"
echo "Going to grab 2 GPUs..."
echo -e "\n\n\n"
python -m vllm.entrypoints.openai.api_server --model /ai/models/Meta-Llama-3-8B-Instruct/ --api-key LLM --host $ip --port 8000 --tensor-parallel-size 2 --dtype=half
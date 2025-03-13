#!/bin/bash
clear
echo "Starting vLLM server with OpenAI compatible API on port 8080"
echo "Going to grab 2 GPUs..."
echo -e "\n\n\n"
python -m vllm.entrypoints.openai.api_server --model /ai/models/Meta-Llama-3-8B-Instruct/ --api-key LLM --host 64.101.169.106 --port 8000 --tensor-parallel-size 2 --dtype=half
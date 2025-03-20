!/bin/bash
ip=$(ifconfig eno5 | grep 'inet ' | awk '{print $2}')
clear
echo "Starting vLLM server with OpenAI compatible API on $ip port 8080"
echo "Going to grab 1 GPUs..."
echo -e "\n\n\n"
python -m vllm.entrypoints.openai.api_server --model  /ai/models/NousResearch/Meta-Llama-3-8B-Instruct/ --api-key LLM --host $ip --port 8000 --tensor-parallel-size 1 --dtype=half
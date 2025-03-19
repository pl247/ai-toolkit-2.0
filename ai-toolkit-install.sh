#!/bin/bash
echo -e "\nRunning commands as a root user..."

# Create software directories
echo -e "\n==================Creating software directories==========================="
sleep 3
sudo mkdir /ai
sudo mkdir /ai/software
sudo mkdir /ai/models
sudo chmod a+x /ai/models

# Get NVIDIA GPU Drivers
echo -e "\n==================Get NVIDIA GPU Drivers and CUDA========================="
sleep 3
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-4 nvidia-driver-550-open cuda-drivers-550


# Installing Docker
echo -e "\n==================Installing Docker======================================"
sleep 3
#  remove snap-docker
sudo snap remove docker --purge
# 
echo "Installing Docker"
sudo apt-get install -y uidmap
curl https://get.docker.com | sh \
  && sudo systemctl --now enable docker
/usr/bin/dockerd-rootless-setuptool.sh install
#nvidia container toolkit
# optional - add nvidia repo
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
# update
sudo apt-get update \
    && sudo sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
# configure docker/nvidia runtime in rootless mode
nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json
systemctl --user restart docker
sudo nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place

# Get AI Monitor
echo -e "\n==================Get AI Monitor========================================="
sleep 3
# Install psutil
pip install psutil
sudo git -C /ai clone https://github.com/pl247/ai-monitor
sudo chmod a+x /ai/ai-monitor
sudo chmod a+x /ai/ai-monitor/ai-monitor.py
sudo chmod a+x /ai/ai-monitor/ai-monitor-plus.py

# Install Miniconda
echo -e "\n==================Get Miniconda=========================================="
sleep 3
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /ai/software
sudo chmod -v +x /ai/software/Miniconda3-latest-Linux-x86_64.sh
sudo /ai/software/Miniconda3-latest-Linux-x86_64.sh -b -p /ai/miniconda

echo -e "\nEnd of running commands as root."

# Modify PATH
echo -e "\n==================Updating PATH=========================================="
sleep 1
eval "$(/ai/miniconda/bin/conda shell.bash hook)"
echo 'export PATH="/ai/miniconda/bin:/ai/miniconda/condabin:/usr/local/cuda/bin:$PATH"' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"' >> ~/.bashrc
source .bashrc

# Create new conda environment
echo -e "\n==================Create New Conda Environment==========================="
sleep 1
conda init bash
conda create -n vllm python=3.12 -y
conda activate vllm

# Install vLLM
echo -e "\n==================Installing vLLM======================================="
sleep 1
#Install vLLM with CUDA 12.4.
pip install vllm 

# Install Huggingface Hub
#echo -e "\n==================Installing Huggingface Hub============================"
#pip install huggingface_hub
#huggingface-cli login

# Install first LLM model
echo -e "\n==================Installing LLM Models================================="
huggingface-cli download NousResearch/Meta-Llama-3-8B-Instruct --local-dir /ai/models/

# NEED TO DOWNLOAD webUI container



# Download scripts and make executable
echo -e "\n==================Downloading Scripts=================================="
wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/2-GPU-vllm-start.sh -P ~/2-GPU-vllm-start.sh
chmod a+x ~/2-GPU-vllm-start.sh
wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/8-GPU-vllm-start.sh -P ~/8-GPU-vllm-start.sh
chmod a+x ~/8-GPU-vllm-start.sh
wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/chatgpt-load-start.sh -P ~/chatgpt-load-start.sh
chmod a+x ~/chatgpt-load-start.sh
wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/webui-vllm-start.sh -P ~/webui-vllm-start.sh
chmod a+x ~/webui-vllm-start.sh
wget https://raw.githubusercontent.com/pl247/ai-toolkit/main/webui-vllm-stop.sh -P ~/webui-vllm-stop.sh
chmod a+x ~/webui-vllm-stop.sh

# Clean up tasks
echo -e "\n\n===============Restart the system with 'sudo reboot' for GPU to work =="
sleep 3
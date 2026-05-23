set -e

# Install curl
if ! command -v curl &> /dev/null; then
    sudo apt install -y curl
fi

if ! command -v nvcc &> /dev/null || ! nvcc --version | grep -q "release 11.3"; then
    # Install conda
    if ! command -v conda &> /dev/null; then
        curl -fSLo \
            "$HOME/Miniforge3.sh" \
            "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
        bash -b -p "$HOME/Miniforge3.sh"
        source "$HOME/miniforge3/etc/profile.d/conda.sh"
    fi
    # Create conda environment with python and cudatoolkit-dev
    conda create -y -n cudatoolkit-11-3 -c conda-forge python=3.8 cudatoolkit-dev=11.3
    export CUDA_HOME="$HOME/miniforge3/envs/cuda-toolkit-11-3"
else
    export CUDA_HOME="$(dirname $(dirname $(which nvcc)))"
fi

# Install uv
if ! command -v uv &> /dev/null; then
    curl -LSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Create uv environment
uv venv --clear

# Install pytorch
uv pip install torch==1.12.0+cu113 torchvision==0.13.0+cu113 \
    --extra-index-url https://download.pytorch.org/whl/cu113

# Install pytorch-geometric packages
uv add "scipy>=1.10.1"
uv pip install \
    torch-cluster==1.6.0+pt112cu113 \
    torch-scatter==2.1.0+pt112cu113 \
    torch-sparse==0.6.16+pt112cu113 \
    -f https://data.pyg.org/whl/torch-1.12.0+cu113.html --no-index
uv add torch-geometric==1.7.2

# Install the rest of the dependencies
uv sync

# Build sptr
git submodule update --init --recursive
cd thirdparty/SparseTransformer
uv pip install . --no-build-isolation
cd ../..

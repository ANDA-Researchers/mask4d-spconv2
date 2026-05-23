set -e

if ! command -v curl &> /dev/null; then
    sudo apt update
    sudo apt install -y curl
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

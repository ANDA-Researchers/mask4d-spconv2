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
UV_HTTP_TIMEOUT=1200 \
    uv pip install torch==2.11.0+cu126 torchvision==0.26.0+cu126 \
    --index-url https://download.pytorch.org/whl/cu126

# Install pytorch-geometric packages
uv pip install scipy==1.15.3
uv pip install \
    torch-cluster==1.6.3+pt211cu126 \
    torch-scatter==2.1.2+pt211cu126 \
    torch-sparse==0.6.18+pt211cu126 \
    -f https://data.pyg.org/whl/torch-2.11.0+cu126.html
uv pip install torch-geometric==1.7.2

# Install the rest of the dependencies
uv sync

# Build sptr
git submodule update --init --recursive
cd thirdparty/SparseTransformer
uv pip install . --no-build-isolation
cd ../..

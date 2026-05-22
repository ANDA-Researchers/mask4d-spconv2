# Install uv
if ! command -v uv &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install python
uv python install

# Install mask4d
uv pip install -e .

# Install pytorch
uv pip install torch==1.12.0+cu113 torchvision==0.13.0+cu113 \
    --extra-index-url https://download.pytorch.org/whl/cu113

# Install pytorch-geometric packages
uv pip install \
    torch-cluster==1.6.0+pt112cu113 \
    torch-scatter==2.1.0+pt112cu113 \
    torch-sparse==0.6.16+pt112cu113 \
    -f https://data.pyg.org/whl/torch-1.12.0+cu113.html --no-index
uv add torch-geometric==1.7.2

# Install sptr
git submodule update --init --recursive
cd thirdparty/SparseTransformer
uv run setup.py install
cd ../..

# Install the rest of the dependencies
uv sync --inexact

# Install mask4d separately to prevent error
# with setuptools==59.5.0 (required by sptr)
uv pip install -e .

# Install pytorch (required by pytorch-geometric packages)
uv pip install torch==1.12.0+cu113 torchvision==0.13.0+cu113 \
    --extra-index-url https://download.pytorch.org/whl/cu113

# Install pytorch-geometric packages separately to prevent building from source
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

# Install the rest of the dependencies with
# --inexact flag to prevent uninstalling mask4d
uv sync --inexact

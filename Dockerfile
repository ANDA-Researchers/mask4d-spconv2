FROM nvidia/cuda:12.6.3-devel-ubuntu22.04

RUN apt update
RUN apt install -y curl git

RUN curl -LSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.local/bin:$PATH"

RUN mkdir -p "/workspace/mask4d-spconv2"

RUN git clone https://github.com/ANDA-Researchers/mask4d-spconv2.git \
    /workspace/mask4d-spconv2

WORKDIR "/workspace/mask4d-spconv2"

RUN uv venv --clear

RUN uv pip install torch==2.11.0 torchvision==0.26.0 \
    --index-url https://download.pytorch.org/whl/cu126

RUN uv pip install scipy==1.15.3
RUN uv pip install \
    torch-cluster==1.6.3+pt211cu126 \
    torch-scatter==2.1.2+pt211cu126 \
    torch-sparse==0.6.18+pt211cu126 \
    -f https://data.pyg.org/whl/torch-2.11.0+cu126.html
RUN uv pip install torch-geometric==1.7.2

RUN uv sync

RUN git submodule update --init --recursive
RUN cd "/workspace/mask4d-spconv2/thirdparty/SparseTransformer" && \
    uv pip install . --no-build-isolation

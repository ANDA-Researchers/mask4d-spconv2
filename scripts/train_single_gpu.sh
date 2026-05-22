# Manually add sptr to path since it is not installed as a package
CUDA_VISIBLE_DEVICES=0 \
PYTHONPATH=$PYTHONPATH:$(pwd)/thirdparty/SparseTransformer \
uv run mask4d/scripts/train_model.py --w weights/maskpls_spconv2.ckpt

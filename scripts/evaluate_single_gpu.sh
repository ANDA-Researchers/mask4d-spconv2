# Manually add sptr to path since it is not installed as a package
CUDA_VISIBLE_DEVICES=0 \
PYTHONPATH=$PYTHONPATH:$(pwd)/thirdparty/SparseTransformer \
uv run mask4d/scripts/evaluate_model.py --w weights/mask4d_spconv2.ckpt

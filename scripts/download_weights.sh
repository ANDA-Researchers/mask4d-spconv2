# Download and convert Mask4D pretrained model
wget -P weights https://www.ipb.uni-bonn.de/html/projects/mask_4d/mask4d.ckpt
uv run python mask4d/convert_to_spconv2.py weights/mask4d.ckpt" "weights/mask4d_spconv2.ckpt

# Download and convert MaskPLS pretrained model
wget -P weights https://www.ipb.uni-bonn.de/html/projects/mask_4d/maskpls.ckpt
uv run python mask4d/convert_to_spconv2.py weights/maskpls.ckpt weights/maskpls_spconv2.ckpt

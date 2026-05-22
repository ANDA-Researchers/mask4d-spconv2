wget -P weights https://www.ipb.uni-bonn.de/html/projects/mask_4d/mask4d.ckpt
uv run python mask_4d/convert_to_spconv2.py

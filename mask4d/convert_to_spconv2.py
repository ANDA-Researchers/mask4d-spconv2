import torch

TARGET_KEYS = {
    "backbone.unet.conv.2.weight",
    "backbone.unet.u.conv.2.weight",
    "backbone.unet.u.u.conv.2.weight",
    "backbone.unet.u.u.u.conv.2.weight",
    "backbone.unet.u.u.u.deconv.2.weight",
    "backbone.unet.u.u.deconv.2.weight",
    "backbone.unet.u.deconv.2.weight",
    "backbone.unet.deconv.2.weight",
}

checkpoint = torch.load("weights/mask4d.ckpt", map_location="cpu")

state_dict = checkpoint["state_dict"]

for key in TARGET_KEYS:
    if key not in state_dict:
        print(f"Missing key: {key}")
        continue

    value = state_dict[key]

    print(f"Converting {key}")
    print(f"Before: {value.shape}")

    # [kx, ky, kz, in_c, out_c]
    # ->
    # [in_c, kx, ky, kz, out_c]
    value = value.permute(3, 0, 1, 2, 4).contiguous()

    print(f"After:  {value.shape}")

    state_dict[key] = value

torch.save(checkpoint, "weights/mask4d_spconv2.ckpt")

print("Saved converted checkpoint.")

checkpoint = torch.load("weights/maskpls.ckpt", map_location="cpu")

state_dict = checkpoint["state_dict"]

for key in TARGET_KEYS:
    if key not in state_dict:
        print(f"Missing key: {key}")
        continue

    value = state_dict[key]

    print(f"Converting {key}")
    print(f"Before: {value.shape}")

    # [kx, ky, kz, in_c, out_c]
    # ->
    # [in_c, kx, ky, kz, out_c]
    value = value.permute(3, 0, 1, 2, 4).contiguous()

    print(f"After:  {value.shape}")

    state_dict[key] = value

torch.save(checkpoint, "weights/maskpls_spconv2.ckpt")

print("Saved converted checkpoint.")

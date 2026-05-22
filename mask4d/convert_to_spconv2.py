import argparse
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


def convert_checkpoint(in_path: str, out_path: str, target_keys=TARGET_KEYS):

    checkpoint = torch.load(in_path, map_location="cpu")
    state_dict = checkpoint["state_dict"]

    for key in target_keys:

        value = state_dict[key]
        print(f"Before: {value.shape}")

        value = value.permute(3, 0, 1, 2, 4).contiguous()

        print(f"After:  {value.shape}")
        state_dict[key] = value

    checkpoint["state_dict"] = state_dict
    torch.save(checkpoint, out_path)
    print(f"Saved converted checkpoint to {out_path}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("in_path")
    parser.add_argument("out_path")
    args = parser.parse_args()
    convert_checkpoint(args.in_path, args.out_path)

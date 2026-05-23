import torch
from argparse import ArgumentParser, Namespace


TARGET_KEYS = [
    "backbone.unet.conv.2.weight",
    "backbone.unet.u.conv.2.weight",
    "backbone.unet.u.u.conv.2.weight",
    "backbone.unet.u.u.u.conv.2.weight",
    "backbone.unet.u.u.u.deconv.2.weight",
    "backbone.unet.u.u.deconv.2.weight",
    "backbone.unet.u.deconv.2.weight",
    "backbone.unet.deconv.2.weight",
]


def main(args: Namespace) -> None:

    checkpoint = torch.load(args.in_path)
    state_dict = checkpoint["state_dict"]

    for key in TARGET_KEYS:

        value = state_dict[key]
        print(f"Before: {value.shape}")

        value = value.permute(3, 0, 1, 2, 4).contiguous()

        print(f"After:  {value.shape}")
        state_dict[key] = value

    checkpoint["state_dict"] = state_dict
    torch.save(checkpoint, args.out_path)
    print(f"Saved converted checkpoint to {args.out_path}.")


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("in_path", type=str)
    parser.add_argument("out_path", type=str)
    main(parser.parse_args())

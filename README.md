# Mask4D: End-to-End Mask-Based 4D Panoptic Segmentation for LiDAR Sequences

[Mask4D](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/marcuzzi2023ral-meem.pdf) with updated installation.

## Prerequisite
* Ubuntu 20.04
* CUDA 11.3

## Overview
* Mask4D is a method for 4D panoptic segmentation using masks. It builds on top of [MaskPLS](https://github.com/PRBonn/MaskPLS) using [SphereFormer](https://github.com/dvlab-research/SphereFormer/tree/master) as feature extractor.
* We reuse the output queries of previous steps to decode and track the same instance over time.
* It is an end-to-end approach without post-processing step like clustering.
* We propose Position-aware mask attention to provide prior positional information to the cross-attention and improve the segmentation.

![](pics/overview.jpg)

## Get started

Install this package by running in the root directory of this repo:
```bash
bash scripts/install.sh
```

## Data preparation: SemanticKITTI
Download the [SemanticKITTI](http://www.semantic-kitti.org/dataset.html#overview) dataset inside the directory `data/kitti/`. The directory structure should look like this:
```
./
└── data/
    └── kitti
        └── sequences
            ├── 00/           
            │   ├── velodyne/	
            |   |	├── 000000.bin
            |   |	├── 000001.bin
            |   |	└── ...
            │   └── labels/ 
            |       ├── 000000.label
            |       ├── 000001.label
            |       └── ...
            ├── 08/ # for validation
            ├── 11/ # 11-21 for testing
            └── 21/
                └── ...
```

## Pretrained models

* Download pretrained models ([Mask4D](https://www.ipb.uni-bonn.de/html/projects/mask_4d/mask4d.ckpt), [MaskPLS](https://www.ipb.uni-bonn.de/html/projects/mask_4d/maskpls.ckpt)) and convert them to `spconv2` format:
```bash
bash scripts/download_weights.sh
```

## Reproducing results
```bash
bash scripts/evaluate_single_gpu.sh
```

## Training

We leverage the weights of the 3D model MaskPLS with SphereFormer as backbone.

```bash
bash scripts/train_single_gpu.sh
```

## Citation
```bibtex
@article{marcuzzi2023ral-meem,
  author = {R. Marcuzzi and L. Nunes and L. Wiesmann and E. Marks and J. Behley and C. Stachniss},
  title = {{Mask4D: End-to-End Mask-Based 4D Panoptic Segmentation for LiDAR Sequences}},
  journal = ral,
  year = 2023,
  volume = {8},
  number = {11},
  pages = {7487-7494},
  doi = {10.1109/LRA.2023.3320020},
  url = {https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/marcuzzi2023ral-meem.pdf},
}
```

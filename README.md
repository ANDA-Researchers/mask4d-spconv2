# Mask4D: End-to-End Mask-Based 4D Panoptic Segmentation for LiDAR Sequences

[Mask4D](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/marcuzzi2023ral-meem.pdf) with `spconv` 2.x back-end support and updated installation instruction, maintained by researcher at [ANDA Lab](https://anda-researchers.github.io/site/).

The original [Mask4D repo](https://github.com/PRBonn/Mask4D) relies on outdated dependencies, so we provide updates that make installation and running experiments more convenient. This project has been tested on Ubuntu 20.04 with CUDA Toolkit 11.3 installed.

## TO-DO
* Add `docker` support
* Add prediction on validation set

## Overview
* Mask4D is a method for 4D panoptic segmentation using masks. It builds on top of [MaskPLS](https://github.com/PRBonn/MaskPLS) using [SphereFormer](https://github.com/dvlab-research/SphereFormer/tree/master) as feature extractor.
* We reuse the output queries of previous steps to decode and track the same instance over time.
* It is an end-to-end approach without post-processing step like clustering.
* We propose Position-aware mask attention to provide prior positional information to the cross-attention and improve the segmentation.

![](pics/overview.jpg)

## Get started
Clone the repo using your preferred method:
```bash
git clone https://github.com/ANDA-Researchers/mask4d-spconv2.git
```

Install this package by running in the root directory of this repo:
```bash
cd mask4d-spconv2
bash scripts/install.sh
```
The script will use the system CUDA Toolkit 11.3 if available, or else it will install `cudatoolkit-dev=11.3` into a `conda` environment to avoid conflict with the existing CUDA installation

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

* Download pretrained models ([Mask4D](https://www.ipb.uni-bonn.de/html/projects/mask_4d/mask4d.ckpt), [MaskPLS](https://www.ipb.uni-bonn.de/html/projects/mask_4d/maskpls.ckpt)) and convert them to `spconv` 2.x format:
```bash
bash scripts/download_weights.sh
```

## Reproducing results
```bash
bash scripts/evaluate_single_gpu.sh
```
<!--
Evaluated 4071 frames. Duplicated frame number: 0
|        |   PQ   |   RQ   |   SQ   |  IoU   |
|all     | 0.6113 | 0.7070 | 0.7623 | 0.6655 |
|nlabeled| 0.0000 | 0.0000 | 0.0000 | 0.0000 |
|car     | 0.9357 | 0.9772 | 0.9575 | 0.9651 |
|bicycle | 0.5617 | 0.6965 | 0.8065 | 0.4932 |
|torcycle| 0.6363 | 0.6983 | 0.9113 | 0.7020 |
|truck   | 0.8506 | 0.8707 | 0.9770 | 0.9521 |
|-vehicle| 0.5904 | 0.6282 | 0.9397 | 0.6491 |
|person  | 0.7825 | 0.8780 | 0.8912 | 0.7470 |
|icyclist| 0.9162 | 0.9644 | 0.9500 | 0.9019 |
|rcyclist| 0.0000 | 0.0000 | 0.0000 | 0.0000 |
|road    | 0.9464 | 0.9993 | 0.9471 | 0.9460 |
|parking | 0.3271 | 0.4440 | 0.7366 | 0.4883 |
|sidewalk| 0.7801 | 0.9196 | 0.8484 | 0.8205 |
|r-ground| 0.0000 | 0.0000 | 0.0000 | 0.0004 |
|building| 0.8750 | 0.9556 | 0.9157 | 0.9099 |
|fence   | 0.2815 | 0.3883 | 0.7251 | 0.6235 |
|getation| 0.8336 | 0.9546 | 0.8733 | 0.8815 |
|trunk   | 0.5003 | 0.6727 | 0.7437 | 0.6570 |
|terrain | 0.5863 | 0.7784 | 0.7532 | 0.7450 |
|pole    | 0.6354 | 0.8399 | 0.7566 | 0.6775 |
|fic-sign| 0.5759 | 0.7666 | 0.7512 | 0.4853 |
pq_mean:        0.6113159333821535
pq_dagger:      0.6583333596976089
sq_mean:        0.7623169077300028
rq_mean:        0.7069553532479652
iou_mean:       0.6655405828462285
pq_stuff:       0.5765136257538661
rq_stuff:       0.7017186800425905
sq_stuff:       0.7318927156648782
pq_things:      0.6591691063710488
rq_things:      0.7141557789053554
sq_things:      0.8041501718195496
-->
We verify that our project reproduces the results on validation set from [Mask4D](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/marcuzzi2023ral-meem.pdf):
```
|        |   AQ   |   IoU  |
|nlabeled| 0.0000 | 0.0000 |
|car     | 0.8609 | 0.9651 |
|bicycle | 0.2623 | 0.4932 |
|torcycle| 0.6533 | 0.7020 |
|truck   | 0.8930 | 0.9521 |
|-vehicle| 0.5863 | 0.6491 |
|person  | 0.5479 | 0.7470 |
|icyclist| 0.8036 | 0.9019 |
|rcyclist| 0.2814 | 0.0000 |
|road    | 0.0000 | 0.9460 |
|parking | 0.0000 | 0.4883 |
|sidewalk| 0.0000 | 0.8205 |
|r-ground| 0.0000 | 0.0004 |
|building| 0.0000 | 0.9099 |
|fence   | 0.0000 | 0.6235 |
|getation| 0.0000 | 0.8815 |
|trunk   | 0.0000 | 0.6570 |
|terrain | 0.0000 | 0.7450 |
|pole    | 0.0000 | 0.6775 |
|fic-sign| 0.0000 | 0.4853 |
PQ4D:   0.7079236541261416
AQ_mean:        0.7530057715309897
iou_mean:       0.6655405828462285
things_iou:     0.6762862613490205
stuff_iou:      0.6577255439351072
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

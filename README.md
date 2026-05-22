# Mask4D: End-to-End Mask-Based 4D Panoptic Segmentation for LiDAR Sequences

[Mask4D](https://www.ipb.uni-bonn.de/wp-content/papercite-data/pdf/marcuzzi2023ral-meem.pdf) with `spconv` 2.x back-end support updated installation instruction.

Like many 3D computer vision research project, the original [Mask4D repo](git@github.com:PRBonn/Mask4D.git) relies on outdated dependencies which make installation cumbersome. We provide update that make installation and running experiments more convenient. This project has been tested on Ubuntu 20.04 with CUDA Toolkit 11.3 installed.

Resolving complex dependencies involves many work-around, so please follow the instructions closely.

As of now, the instructions aren't very customizable and well-tested, so feel free to open pull requests and issues to help us refine it.

## TO-DO
* Add `cuda` installation instruction
* Add `docker` support
* Add prediction on validation set

## Overview
* Mask4D is a method for 4D panoptic segmentation using masks. It builds on top of [MaskPLS](https://github.com/PRBonn/MaskPLS) using [SphereFormer](https://github.com/dvlab-research/SphereFormer/tree/master) as feature extractor.
* We reuse the output queries of previous steps to decode and track the same instance over time.
* It is an end-to-end approach without post-processing step like clustering.
* We propose Position-aware mask attention to provide prior positional information to the cross-attention and improve the segmentation.

![](pics/overview.jpg)

## Get started

Check if CUDA Toolkit 11.3 is installed on your system:
```bash
nvcc --version
```
If not, install it from [NVIDIA website](https://developer.nvidia.com/cuda-11.3.0-download-archive?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local). We provide example installation instruction for Ubuntu 20.04:
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.3.0/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.0-465.19.01-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
sudo apt-get update
```
We reccommend specify the `cuda-toolkit` version instead using `sudo apt-get -y install cuda` instruction from NVIDIA website to avoid dependency conflict
```bash
sudo apt-get -y install cuda-toolkit-11.3
```
Since installing CUDA Toolkit 11.3 can break existing CUDA Toolkit installation on your machine, I haven't added `cuda` installation to the automatic installation script

Clone the repo using your preferred method:
```bash
git clone https://github.com/ANDA-Researchers/mask4d.git
```

Install this package by running in the root directory of this repo:
```bash
cd mask4d
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

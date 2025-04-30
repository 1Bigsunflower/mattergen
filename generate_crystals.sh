#!/bin/bash
# 用mattergen_base生成材料
# 设置模型名字和结果目录
export MODEL_NAME=mattergen_base
export RESULTS_PATH=results/  # Samples will be written to this directory

# 创建结果目录（如果不存在）
mkdir -p $RESULTS_PATH
# 包含
# generated_crystals_cif.zip：包含单个.cif每个生成的结构的文件。
# generated_crystals.extxyz，包含单独生成的结构作为框架的单个文件。
# 如果 --record-trajectories == True （默认）： generated_trajectories.zip：包含一个 ZIP 文件 .extxyz每个生成的结构的文件，其中包含每个单独结构的完整去噪轨迹。

# generate batch_size * num_batches samples
mattergen-generate $RESULTS_PATH --model_path=/home/ubuntu/cht/mattergen/checkpoints/mattergen_base --batch_size=32 --num_batches=1

echo "生成完成！所有文件保存在 $RESULTS_PATH 目录下。"

#!/bin/bash
# 需要先手动下载模型MODEL_NAME到checkpoint对应文件夹下
# 条件生成材料，指定 'energy_above_hull': 0.05
# 设置模型名字和结果目录

## 单属性条件生成
#export MODEL_NAME=dft_mag_density
#export RESULTS_PATH="results/$MODEL_NAME/"
## 目标属性值（比如磁性密度）
#TARGET_PROPERTY="{'dft_mag_density': 0.15}"

# 多属性条件生成
export MODEL_NAME=chemical_system_energy_above_hull
export RESULTS_PATH="results/single_${MODEL_NAME}/"
TARGET_PROPERTY="{'energy_above_hull': 0.05}"

# 扩散引导因子 (越大越更严格遵循目标属性，但生成的样本可能更少样性)
DIFFUSION_GUIDANCE_FACTOR=2.0

mkdir -p $RESULTS_PATH

# 开始生成
mattergen-generate $RESULTS_PATH --model_path=/home/ubuntu/cht/mattergen/checkpoints/$MODEL_NAME\
                   --batch_size=16 \
                   --properties_to_condition_on="$TARGET_PROPERTY" \
                   --diffusion_guidance_factor=$DIFFUSION_GUIDANCE_FACTOR

# 生成完成提示
echo "条件生成完成！所有文件保存在 $RESULTS_PATH 目录下。生成的文件有："
ls -lh $RESULTS_PATH

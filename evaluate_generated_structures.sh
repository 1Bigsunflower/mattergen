#!/bin/bash

# 评估生成的材料是否有"创新性"
# 先定义路径
export RESULTS_PATH=results/  # 这里换成你的生成结构目录
export METRICS_OUTPUT="$RESULTS_PATH/metrics.json"
export RELAXED_STRUCTURES_OUTPUT="$RESULTS_PATH/relaxed_structures.extxyz"

## Step 1: 拉取 reference 数据（用于评估稳定性）
#echo "下载参考数据集..."
#git lfs pull -I data-release/alex-mp/reference_MP2020correction.gz --exclude=""

# Step 2: 运行评估，使用 MatterSim 的 MLFF 自动松弛结构
echo "开始评估生成的结构..."
mattergen-evaluate \
  --structures_path="$RESULTS_PATH" \
  --relax=True \
  --structure_matcher='disordered' \
  --save_as="$METRICS_OUTPUT" \
  --structures_output_path="$RELAXED_STRUCTURES_OUTPUT"

echo "评估完成！"
echo "指标保存在: $METRICS_OUTPUT"
echo "松弛后的结构保存在: $RELAXED_STRUCTURES_OUTPUT"

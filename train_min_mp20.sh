#!/bin/bash
# 用min_dataset划分成小数据集之后，训练小的数据集
echo "Step 3: 预处理小数据集"
csv-to-dataset --csv-folder datasets/mp_20_small/ --dataset-name mp_20_small --cache-folder datasets/cache

echo "Step 4: 开始训练小数据集模型"
mattergen-train data_module=mp_20_small ~trainer.logger

echo "小规模训练启动完成 ✅"
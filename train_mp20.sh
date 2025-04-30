#!/bin/bash
# 训练mp20数据集
# 假设你已经在 MatterGen 项目的根目录下！

echo "Step 1: 解压 mp_20.zip"
unzip -o data-release/mp-20/mp_20.zip -d datasets

echo "Step 2: 数据预处理 (csv -> dataset)"
csv-to-dataset --csv-folder datasets/mp_20/ --dataset-name mp_20 --cache-folder datasets/cache

echo "Step 3: 开始训练 MatterGen base 模型"
mattergen-train data_module=mp_20 ~trainer.logger

echo "训练启动完成 ✅"

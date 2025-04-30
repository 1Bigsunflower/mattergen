#!/bin/bash
# bash split_dataset.sh 100
source .venv/bin/activate

# 读取外部参数：训练集大小
TRAIN_SIZE=$1

# 检查输入
if [ -z "$TRAIN_SIZE" ]; then
  echo "用法: bash split_dataset.sh 小训练集的数据量"
  echo "请在命令行中提供训练集大小！"
  exit 1
fi

# 设置数据路径
DATASET_NAME="mp_20"
SOURCE_DIR="datasets/${DATASET_NAME}"
TARGET_DIR="datasets/${DATASET_NAME}_${TRAIN_SIZE}"

# 创建目标目录
mkdir -p ${TARGET_DIR}

# 运行Python脚本拆分数据
python3 << EOF
import pandas as pd
import os
import math
import sys

# 路径设置
source_dir = '${SOURCE_DIR}'
target_dir = '${TARGET_DIR}'

# 读原始数据
df_train = pd.read_csv(os.path.join(source_dir, 'train.csv'))
df_val = pd.read_csv(os.path.join(source_dir, 'val.csv'))
df_test = pd.read_csv(os.path.join(source_dir, 'test.csv'))

# 打印原始数据大小
print(f"原始训练集大小: {len(df_train)}")
print(f"原始验证集大小: {len(df_val)}")
print(f"原始测试集大小: {len(df_test)}")

# 取小数据集 8:1:1
train_size = int(${TRAIN_SIZE})
val_size = math.ceil(train_size / 8)
test_size = math.ceil(train_size / 8)


# 检查是否超出原始数据量
if train_size > len(df_train):
    print(f"错误：想要的训练集大小 {train_size} 超过了原始训练集数量 {len(df_train)}！")
    sys.exit(1)

# 随机采样
df_train_small = df_train.sample(n=train_size, random_state=42)
df_val_small = df_val.sample(n=val_size, random_state=42)
df_test_small = df_test.sample(n=test_size, random_state=42)

# 保存到新的目录
os.makedirs(target_dir, exist_ok=True)
df_train_small.to_csv(os.path.join(target_dir, 'train.csv'), index=False)
df_val_small.to_csv(os.path.join(target_dir, 'val.csv'), index=False)
df_test_small.to_csv(os.path.join(target_dir, 'test.csv'), index=False)

print(f"新数据集已保存到 {target_dir}/")
EOF

echo "数据拆分完成 ✅"

# 第二步：复制yaml文件，并修改内容
CONF_DIR="mattergen/conf/data_module"
SRC_YAML="${CONF_DIR}/mp_20.yaml"
DEST_YAML="${CONF_DIR}/mp_20_${TRAIN_SIZE}.yaml"

# 复制原文件
cp ${SRC_YAML} ${DEST_YAML}

# 替换里面的 "mp_20" 为 "mp_20_${TRAIN_SIZE}"
sed -i "s/mp_20/mp_20_${TRAIN_SIZE}/g" ${DEST_YAML}

echo "✅ 配置文件已复制并替换完成：${DEST_YAML}"

# 用min_dataset划分成小数据集之后，训练小的数据集
echo "Step 3: 预处理小数据集"
csv-to-dataset --csv-folder datasets/mp_20_${TRAIN_SIZE}/ --dataset-name mp_20_${TRAIN_SIZE} --cache-folder datasets/cache

echo "Step 4: 开始训练小数据集模型"
mattergen-train data_module=mp_20_${TRAIN_SIZE} ~trainer.logger


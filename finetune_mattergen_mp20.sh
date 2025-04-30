#!/bin/bash

# 1. 定义需要微调的属性
export PROPERTY=dft_mag_density

# 2. 开始微调训练
mattergen-finetune \
  adapter.pretrained_name=mattergen_base \
  data_module=mp_20 \
  +lightning_module/diffusion_module/model/property_embeddings@adapter.adapter.property_embeddings_adapt.$PROPERTY=$PROPERTY \
  ~trainer.logger \
  data_module.properties=["$PROPERTY"]

echo "✅ 微调启动完成，正在训练中！"

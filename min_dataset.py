import pandas as pd

# 拆分原始大的数据集，保留8个训练 1个验证 1个测试，并保存
# 读原始大csv
df_train = pd.read_csv('datasets/mp_20/train.csv')
df_val = pd.read_csv('datasets/mp_20/val.csv')
df_test = pd.read_csv('datasets/mp_20/test.csv')

# 取前20条真正的样本
df_train_small = df_train.head(8)
df_val_small = df_val.head(1)
df_test_small = df_test.head(1)

# 保存成新的小csv
df_train_small.to_csv('datasets/mp_20_8/train.csv', index=False)
df_val_small.to_csv('datasets/mp_20_8/val.csv', index=False)
df_test_small.to_csv('datasets/mp_20_8/test.csv', index=False)

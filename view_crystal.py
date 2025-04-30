import numpy as np
from ase.visualize import view
from ase.io import read, write
import os
from collections import Counter
import imageio
from ase.visualize.plot import plot_atoms
from matplotlib import pyplot as plt
from PIL import Image


# 可视化预测出来的材料结构和去噪过程

model_name1 = 'single_chemical_system_energy_above_hull'
model_name2 = "chemical_system_energy_above_hull"
# 设置路径
structure_path = f'results/{model_name2}/generated_crystals.extxyz'
trajectory_folder = f'results/{model_name2}/generated_trajectories/'

# 创建保存图片的文件夹
os.makedirs(f'{model_name2}/pngs', exist_ok=True)
os.makedirs(f'{model_name2}/gifs', exist_ok=True)

# 读取所有生成的晶体结构
structures = read(structure_path, index=':')
# for structure in structures:
#     view(structure)

# 保存每个晶体为高清png，并加化学式标题
for idx, structure in enumerate(structures):
    # 获取元素信息
    elements = structure.get_chemical_symbols()
    formula = structure.get_chemical_formula(mode='reduce')

    # 创建绘图
    fig, ax = plt.subplots(figsize=(6, 6))  # 可以调节图大小
    plot_atoms(structure, ax, radii=0.3)  # radii调整原子大小

    # 加标题（化学式）
    ax.set_title(formula, fontsize=16, pad=10)  # pad是标题和图的间距

    # 去掉坐标轴
    ax.set_axis_off()

    # 保存高清png
    png_filename = f'{model_name2}/pngs/structure_{idx}_{formula}.png'
    plt.savefig(png_filename, dpi=300, bbox_inches='tight')  # dpi越高越清晰
    plt.close()

print("\nPNG保存完成！")

# 处理轨迹文件，保存为gif

# # 读取某一个轨迹
# trajectory = read('results/single_chemical_system_energy_above_hull/generated_trajectories/gen_0.extxyz', index=':')
# # 动画播放整个去噪过程
# view(trajectory)

# 轨迹目录
trajectory_folder = f'results/{model_name2}/generated_trajectories/'

for traj_filename in os.listdir(trajectory_folder):
    if traj_filename.endswith('.extxyz'):
        traj_path = os.path.join(trajectory_folder, traj_filename)

        trajectory = read(traj_path, index=':')

        images = []

        frame_skip = 3  # 每隔3步保存一张
        for i, frame in enumerate(trajectory):
            if i % frame_skip == 0:
                # 每一帧新建一张图，干净！
                fig, ax = plt.subplots(figsize=(4, 4))  # 小一点加速
                plot_atoms(frame, ax, radii=0.3)  # 简单快速渲染
                ax.set_axis_off()

                fig.canvas.draw()
                img = np.frombuffer(fig.canvas.tostring_rgb(), dtype='uint8')
                img = img.reshape(fig.canvas.get_width_height()[::-1] + (3,))
                images.append(img)

                plt.close(fig)  # 关闭，释放内存

        gif_filename = f"{model_name2}/gifs/{traj_filename.replace('.extxyz', '.gif')}"
        imageio.mimsave(gif_filename, images, duration=0.2)
        print(f"Saved clean GIF: {gif_filename}")

print("所有轨迹GIF保存完成！")


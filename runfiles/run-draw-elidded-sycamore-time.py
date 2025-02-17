import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
import seaborn as sns
import os

# 1. Read Data
try:
    print("Current Working Directory:", os.getcwd())
    df = pd.read_csv("quantum_data.csv")
    print(df.head())
except FileNotFoundError:
    print("Error: File not found. Please make sure the file path is correct.")
    exit()
except pd.errors.ParserError:
    print("Error: Parsing error. Check the file format and delimiter.")
    exit()

# 2. Determine Grid Dimensions
unique_widths = sorted(df['width'].unique())
unique_depths = sorted(df['depth'].unique())

width_mapping = {width: i for i, width in enumerate(unique_widths)}
depth_mapping = {depth: i for i, depth in enumerate(unique_depths)}

# 3. Create a Grid
grid = np.zeros((len(unique_depths), len(unique_widths)))

# 4. Populate the Grid
for index, row in df.iterrows():
    width_index = width_mapping[row['width']]
    depth_index = depth_mapping[row['depth']]
    grid[depth_index, width_index] = row['time']

# 5. Generate Heatmap (with inverted depth axis)
plt.figure(figsize=(10, 8))

# Create a logarithmic normalization
norm = mcolors.LogNorm(vmin=df['time'].min(), vmax=df['time'].max())

# Flip the grid vertically to invert the depth axis
grid = np.flipud(grid)  # Invert the depth data

# Using Seaborn for the heatmap with inverted depth and logarithmic color bar
sns.heatmap(grid, cmap="YlGnBu",
            xticklabels=unique_widths, yticklabels=unique_depths[::-1],  # Reverse labels to match data
            norm=norm)

plt.xlabel("Width")
plt.ylabel("Depth")
plt.title("Heatmap of Time based on Width and Depth (Logarithmic Scale, Inverted Depth)")
plt.show()

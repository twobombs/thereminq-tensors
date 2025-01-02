# 105+ version generated by gemini 2 exp adv
# based on nemotron70q6 initial version
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

# Check if widths and depths exceed 256
if max(unique_widths) > 256 or max(unique_depths) > 256:
    print("Warning: Data contains widths or depths greater than 256. "
          "The code will handle these values, but consider if your data is correct.")

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
plt.figure(figsize=(12, 10))  # Adjusted figure size for larger dimensions

# Create a logarithmic normalization
norm = mcolors.LogNorm(vmin=df['time'].min(), vmax=df['time'].max())

# Flip the grid vertically to invert the depth axis
grid = np.flipud(grid)

# Using Seaborn for the heatmap with inverted depth and logarithmic color bar
sns.heatmap(grid, cmap="YlGnBu",
            # xticklabels=unique_widths, yticklabels=unique_depths[::-1],  # Removed to prevent label crowding
            norm=norm)

# Set tick locations and labels explicitly for better control
if len(unique_widths) <= 50: # only display width ticks if it's a reasonable number
    plt.xticks(np.arange(len(unique_widths)), unique_widths)
if len(unique_depths) <= 50: # only display depth ticks if it's a reasonable number
    plt.yticks(np.arange(len(unique_depths)), unique_depths[::-1]) # Reverse depth labels
    
# Add labels for every tick if the number of unique values is small
# Otherwise, add labels at intervals that make sense for the data range
else:
    if len(unique_widths) <= 5 :
      plt.xticks(np.arange(len(unique_widths)), unique_widths)
    else:
      plt.xticks(np.arange(0, len(unique_widths), (len(unique_widths)//20 or 1)),  # Adjusted ticks for large grids
                 [unique_widths[i] for i in range(0, len(unique_widths), (len(unique_widths)//20 or 1))])
    if len(unique_depths) <= 5:
      plt.yticks(np.arange(len(unique_depths)), unique_depths[::-1])
    else:
      plt.yticks(np.arange(0, len(unique_depths), (len(unique_depths)//20 or 1)),
                 [unique_depths[::-1][i] for i in range(0, len(unique_depths), (len(unique_depths)//20 or 1))])

plt.xlabel("Width")
plt.ylabel("Depth")
plt.title("Heatmap of Time based on Width and Depth (Logarithmic Scale, Inverted Depth)")
plt.show()

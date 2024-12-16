import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data into a Pandas DataFrame
# **PLEASE REPLACE 'data.txt' WITH YOUR ACTUAL DATA FILE NAME**
# Assuming your data is in a plain text file, one dictionary per line
data = []
with open('data.txt', 'r') as file:
    for line in file:
        data.append(eval(line))

df = pd.DataFrame(data)

# **Basic Data Overview**
print("Data Shape:", df.shape)
print("Columns:", df.columns)
print("Missing Values:", df.isnull().sum())

# **Visualization and Analysis**

### 1. **Qubits vs. Time**
plt.figure(figsize=(10,6))
sns.lineplot(x='qubits', y='seconds', hue='depth', data=df)
plt.title('Computation Time by Qubits and Depth')
plt.show()

### 2. **XEB Fidelity by Qubits and Depth**
plt.figure(figsize=(10,6))
sns.lineplot(x='depth', y='xeb', hue='qubits', data=df)
plt.title('XEB Fidelity Across Depths for Different Qubits')
plt.show()

### 3. **hog_prob Distribution**
plt.figure(figsize=(8,6))
sns.histplot(df['hog_prob'], bins=50, kde=True)
plt.title('Distribution of Heavy Output Generation Probability')
plt.show()

### 4. **qv_pass Rates by Qubits and Depth**
qv_pass_rates = df.groupby(['qubits', 'depth'])['qv_pass'].mean().unstack('depth')
plt.figure(figsize=(10,6))
sns.heatmap(qv_pass_rates, cmap='coolwarm', annot=True, fmt=".2f")
plt.title('qv_pass Rates (%) by Qubits and Depth')
plt.show()

### 5. **eplg (Simplified Analysis - Considering only real part for complex numbers)**
df['eplg_real'] = df['eplg'].apply(lambda x: x.real if isinstance(x, complex) else x)
plt.figure(figsize=(10,6))
sns.scatterplot(x='qubits', y='eplg_real', hue='depth', data=df)
plt.title('Expected Probability of Large Gradient (Real Part) by Qubits and Depth')
plt.show()

### 6. **XEB Fidelity vs. HOG Probability**
plt.figure(figsize=(8,6))
sns.scatterplot(x='xeb', y='hog_prob', hue='qubits', data=df)
plt.title('XEB Fidelity vs. Heavy Output Generation Probability')
plt.xlabel('XEB Fidelity')
plt.ylabel('HOG Probability')
plt.show()

### 7. **Depth-Influenced XEB vs. HOG (Faceted Plot)**
plt.figure(figsize=(12,8))
sns.set_style("whitegrid")
sns.lmplot(x='xeb', y='hog_prob', hue='qubits', col='depth', 
            data=df, col_wrap=4, height=4, aspect=.8)
plt.suptitle('XEB Fidelity vs. HOG Probability, Faceted by Depth')
plt.show()


# generated with gemini 2

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from scipy.optimize import curve_fit

# --- Load the Data ---
# Replace 'quantum_data.csv' with the actual path to your CSV file
data = pd.read_csv('quantum_data.csv', header=None, skiprows=1, names=['width', 'depth', 'time'],
                   dtype={'width': float, 'depth': float, 'time': float})

# --- Prediction Functions ---

# Method 1: Linear Regression (for each depth value)
def predict_time_linear_regression(target_width, target_depth, data):
    model = LinearRegression()
    closest_depth = min(data['depth'].unique(), key=lambda x: abs(x - target_depth))
    depth_data = data[data['depth'] == closest_depth]
    X = depth_data[['width']]
    y = depth_data['time']
    model.fit(X, y)
    predicted_time = model.predict(np.array([[target_width]]))[0]
    return predicted_time

# Method 2: Polynomial Regression (for each depth value)
def predict_time_polynomial_regression(target_width, target_depth, data, degree=2):
    model = LinearRegression()
    closest_depth = min(data['depth'].unique(), key=lambda x: abs(x - target_depth))
    depth_data = data[data['depth'] == closest_depth]
    poly = PolynomialFeatures(degree=degree)
    X = poly.fit_transform(depth_data[['width']])
    y = depth_data['time']
    model.fit(X, y)
    X_predict = poly.fit_transform(np.array([[target_width]]))
    predicted_time = model.predict(X_predict)[0]
    return predicted_time

# Method 3: Exponential Regression (for each depth value)
def exponential_func(x, a, b, c):
    return a * np.exp(b * x) + c

def predict_time_exponential_regression(target_width, target_depth, data):
    closest_depth = min(data['depth'].unique(), key=lambda x: abs(x - target_depth))
    depth_data = data[data['depth'] == closest_depth]
    X = depth_data['width']
    y = depth_data['time']
    try:
        popt, _ = curve_fit(exponential_func, X, y, maxfev=10000)
        predicted_time = exponential_func(target_width, *popt)
    except RuntimeError:
        print(f"Error: Exponential curve_fit failed to converge for depth {closest_depth}. Returning NaN.")
        predicted_time = np.nan
    return predicted_time

# Method 4: 2D Polynomial Regression
def predict_time_2d_polynomial_regression(target_width, target_depth, data, degree=2):
    model = LinearRegression()
    poly = PolynomialFeatures(degree=degree)
    X = poly.fit_transform(data[['width', 'depth']])
    y = data['time']
    model.fit(X, y)
    X_predict = poly.fit_transform(np.array([[target_width, target_depth]]))
    predicted_time = model.predict(X_predict)[0]
    return predicted_time

# --- Parameters for Plotting ---
target_widths = np.arange(106, 151)  # Width values for prediction
depth_values = [1, 2, 10, 50, 100]  # Depths to analyze
# depth_values = data['depth'].unique() # All depths

# --- Generate and Plot Data for Each Depth ---

plt.figure(figsize=(14, 10))

for depth in depth_values:
    # Store predictions for each method for the current depth
    linear_predictions = []
    polynomial_predictions = []
    exponential_predictions = []
    poly2d_predictions = []

    for w in target_widths:
        linear_predictions.append(predict_time_linear_regression(w, depth, data))
        polynomial_predictions.append(predict_time_polynomial_regression(w, depth, data, degree=2))
        exponential_predictions.append(predict_time_exponential_regression(w, depth, data))
        poly2d_predictions.append(predict_time_2d_polynomial_regression(w, depth, data, degree=2))

    # Plot original data for the current depth
    depth_data = data[data['depth'] == depth]
    plt.scatter(depth_data['width'], depth_data['time'], s=10, alpha=0.5, label=f'Depth={depth} (Original Data)' if depth == depth_values[0] else "")

    # Plot prediction lines for the current depth
    plt.plot(target_widths, linear_predictions, linestyle='-', marker='o', markersize=3, label=f'Linear (Depth={depth})', alpha=0.7)
    plt.plot(target_widths, polynomial_predictions, linestyle='-', marker='x', markersize=3, label=f'Polynomial (Depth={depth})', alpha=0.7)
    plt.plot(target_widths, exponential_predictions, linestyle='-', marker='s', markersize=3, label=f'Exponential (Depth={depth})', alpha=0.7)
    plt.plot(target_widths, poly2d_predictions, linestyle='-', marker='^', markersize=3, label=f'2D Polynomial (Depth={depth})', alpha=0.7)

# Mark the end of the original data
plt.axvline(x=105, color='gray', linestyle='--', label='End of Original Data')

plt.xlabel('Width (Number of Qubits)')
plt.ylabel('Time')
plt.title('Scaling Predictions and Original Data for Various Depths')
plt.legend(fontsize='small')
plt.grid(True)
plt.yscale('log')
plt.tight_layout()
plt.show()

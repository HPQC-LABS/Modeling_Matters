

#WS2
import matplotlib.pyplot as plt

# Define x and y values
x_values = [16, 20, 24, 28, 32,36,40,44,48]
y_values = [-16563.39297069,
-16565.25985797,
-16565.67511273,
-16565.75860051,
-16565.80097926,
-16565.83841885,
-16565.85518414,
-16565.85935349,
-16565.86126045]
# Plot the graph
plt.plot(x_values, y_values, marker='o', linestyle='-')

# Add labels and title
plt.xlabel('ecutwfc')
plt.ylabel('Total energy')
plt.title('Sample Graph')

# Display the graph
plt.show()

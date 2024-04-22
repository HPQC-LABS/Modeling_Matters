

#WS2
import matplotlib.pyplot as plt

data = [(160, -16565.85488851),
(240, -16565.85528603),
(320, -16565.85518413),
(400, -16565.85500244),
(480, -16565.85490831)]

x_values = [d[0] for d in data]
y_values = [d[1] for d in data]

print(x_values)

# Define x and y values
#x_values = [160, 240, 320, 400, 480]
#y_values = [-16563.39297069,
#-16565.25985797,
#-16565.67511273,
#-16565.75860051,
#-16565.80097926,
#-16565.83841885,
#-16565.85518414,
#-16565.85935349,
#-16565.86126045]
# Plot the graph
plt.plot(x_values, y_values, marker='o', linestyle='-')

plt.ylim([-16565, -16566])
# Add labels and title
plt.xlabel('ecutrho')
plt.ylabel('Total energy')
plt.title('Convergence')

# Display the graph
plt.show()

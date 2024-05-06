# NBA Player Salary vs. 2023-2024 VORP Analysis

This project visualizes the relationship between NBA player salaries and their Value Over Replacement Player (VORP) for the 2023-2024 season. The interactive visualization is built with `ggplot2` and `plotly` in R.

## Features

- **Team-Specific Color Coding**: Each NBA team is uniquely color-coded to distinguish its players in the scatter plot.
- **Hover Interactivity**: When hovering over a data point, the corresponding team's players remain visible while others fade out. The hovered player's specific VORP and salary is also presented.
- **Best-Fit Lines**: A dashed line of best fit provides a visual trend for understanding the correlation between salary and VORP for each team

## Visualization Preview

![Visualization Preview](jamesbrainard.github.io/nba-salary-analysis)

> *A sample preview of the NBA Salary vs. VORP scatter plot.*

## Installation

1. Ensure that you have R and the required packages installed:
    ```r
    install.packages(c("ggplot2", "plotly", "htmlwidgets"))
    ```
2. Clone the repository:
    ```bash
    git clone https://github.com/your-username/your-repository.git
    ```
## Contributing

Contributions are welcome! Please submit issues or pull requests to improve this project.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

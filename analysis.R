library(ggplot2)
library(plotly)
library(htmlwidgets)

# Defines colors for each NBA team
team_colors <- c(
  "ATL" = "#E03A3E",
  "BOS" = "#007A33",
  "BRK" = "#000000",
  "CHO" = "#00788C",
  "CHI" = "#CE1141",
  "CLE" = "#860038",
  "DAL" = "#00538C",
  "DEN" = "#0E2240",
  "DET" = "#C8102E",
  "GSW" = "#1D428A",
  "HOU" = "#CE1141",
  "IND" = "#002D62",
  "LAC" = "#C8102E",
  "LAL" = "#552583",
  "MEM" = "#5D76A9",
  "MIA" = "#98002E",
  "MIL" = "#00471B",
  "MIN" = "#0C2340",
  "NOP" = "#0C2340",
  "NYK" = "#F58426",
  "OKC" = "#007AC1",
  "ORL" = "#0077C0",
  "PHI" = "#006BB6",
  "PHO" = "#1D1160",
  "POR" = "#E03A3E",
  "SAC" = "#5A2D81",
  "SAS" = "#C4CED4",
  "TOT" = "#CE1141",
  "UTA" = "#002B5C",
  "WAS" = "#002B5C"
)

# Create the ggplot object with a line of best fit
p <- ggplot(stats, aes(x = Salary, y = VORP, color = Team, label = Player)) +
  geom_point() +  # Add scatter plot points
  geom_smooth(method = "lm", se = FALSE, linetype = "dashed", size = 0.1, alpha = 0.05) +
  labs(title = "NBA Player Salary vs. VORP", x = "Salary", y = "VORP") +
  scale_color_manual(values = team_colors) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(override.aes = list(size = 3)))

# Convert ggplot object to plotly
p <- ggplotly(p, tooltip = c("Player", "Team"))

# Sets up the regression lines
num_teams <- length(unique(stats$Team))
visible_state <- c(rep(TRUE, num_teams * 2))
for (i in seq_len(num_teams)) {
  visible_state[num_teams + i] <- FALSE
}

# Adds a button to toggle the visibility of the regression lines
p <- layout(p, updatemenus = list(
  list(
    type = "buttons",
    direction = "left",
    x = 0.1,
    xanchor = "left",
    y = 1.1,
    yanchor = "top",
    buttons = list(
      list(
        args = list("visible", visible_state),
        label = "Hide Fit Lines",
        method = "restyle"
      ),
      list(
        args = list("visible", rep(TRUE, num_teams * 2)), 
        label = "Show Fit Lines",
        method = "restyle"
      )
    )
  )
))

# Custom JavaScript for hover event
p <- htmlwidgets::onRender(
  p,
  "
  function(el, x) {
    var myPlot = document.getElementById(el.id);
    myPlot.on('plotly_hover', function(data){
      var hoveredTeam = data.points[0].fullData.name;
      var update = {
        'marker.opacity': Array(x.data.length).fill(0.1)
      };
      for(var i = 0; i < x.data.length; i++) {
        if(x.data[i].name === hoveredTeam) {
          update['marker.opacity'][i] = 1; 
        }
      }
      Plotly.restyle(myPlot, update);
    })
    .on('plotly_unhover', function(data){
      Plotly.restyle(myPlot, {'marker.opacity': 1});
    });
  }
  "
)

p

saveWidget(p, "index.html", selfcontained = TRUE)
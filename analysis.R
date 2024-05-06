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

# Creates the ggplot object with a line of best fit
p <- ggplot(stats, aes(x = Salary, y = VORP, color = Team, label = Player, text = paste("Team:", Team))) +
  geom_point(aes(text = paste("Player:", Player, "<br>Team:", Team, "<br>VORP:", VORP, "<br>Salary:", scales::dollar(Salary)))) +
  geom_smooth(aes(text = paste("Team:", Team)), method = "lm", se = FALSE, linetype = "dashed", size = 0.1, alpha = 0.05) +
  labs(title = "NBA Player Salary vs. 2023-2024 VORP", x = "Salary", y = "VORP") +
  scale_color_manual(values = team_colors) +
  scale_y_continuous(limits = c(0, 12), breaks = seq(0, 12, by = 2)) +
  scale_x_continuous(labels = scales::dollar) +  
  theme_minimal() +
  theme(
    legend.position = "bottom",
    plot.title = element_text(size = 20, face = "bold")
  ) +
  guides(color = guide_legend(override.aes = list(size = 3)))

# Converts ggplot object to plotly with separate tooltips for lines and points
p <- ggplotly(p, tooltip = "text")


# Sets up hover interaction
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
      for (var i = 0; i < x.data.length; i++) {
        if (x.data[i].name === hoveredTeam) {
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


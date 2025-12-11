# plotting_utils.R
# Shared plotting utilities for Palmer Penguins blog post

#' Setup default plot theme
#' @export
setup_plot_theme <- function() {
  theme_set(theme_minimal(base_size = 12))
}

#' Get penguin color palette
#' @return Named vector of penguin species colors
#' @export
get_penguin_colors <- function() {
  c("Adelie" = "#FF6B6B", "Chinstrap" = "#9B59B6", "Gentoo" = "#2E86AB")
}

#' Create consistent figure caption format
#' @param filename Name of the figure file
#' @param caption Figure description
#' @return Markdown-formatted figure caption
#' @export
format_figure_caption <- function(filename, caption) {
  sprintf("![%s](%s){.img-fluid}", caption, filename)
}

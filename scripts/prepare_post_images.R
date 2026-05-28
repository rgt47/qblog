#' Prepare hero + 3 ambiance images for a blog post
#'
#' Resizes, strips EXIF, renames to the convention used by post-39 and
#' post-47 templates, and appends attribution stubs to media/images/README.md.
#'
#' Each image source is either:
#'   - a local file path (own screenshot, AI-generated PNG, R-generated plot)
#'   - an Unsplash spec: list(unsplash_id = '...', photographer = '...',
#'     url = 'https://unsplash.com/photos/...')
#'
#' Usage:
#'   source('scripts/prepare_post_images.R')
#'   prepare_post_images(
#'     post_dir = 'posts/47-templatesetup/templatesetup',
#'     hero     = list(unsplash_id = 'abc123',
#'                     photographer = 'Christopher Gower',
#'                     url = 'https://unsplash.com/photos/abc123'),
#'     ambiance = list(
#'       '~/Desktop/desk-raw.jpg',
#'       '~/Desktop/screen-term.png',
#'       '~/Desktop/screen-editor.png'
#'     ),
#'     attributions = c(
#'       'Own screenshot, iTerm2 + Fira Code 14pt',
#'       'Own screencap, VS Code + ellmer chat pane'
#'     )
#'   )

library(magick)
library(fs)

prepare_post_images <- function(post_dir,
                                hero,
                                ambiance,
                                attributions = NULL,
                                hero_width = 1600,
                                ambiance_width = 1920) {

  stopifnot(length(ambiance) == 3L)
  images_dir <- path(post_dir, 'media', 'images')
  dir_create(images_dir)

  hero_entry <- process_one(hero, images_dir, 'hero.jpg', hero_width)

  amb_entries <- vapply(seq_along(ambiance), function(i) {
    name <- sprintf('ambiance-%02d.jpg', i)
    extra <- if (!is.null(attributions) && i <= length(attributions)) {
      attributions[[i]]
    } else NULL
    process_one(ambiance[[i]], images_dir, name, ambiance_width, extra)
  }, character(1))

  append_readme(images_dir, c(hero_entry, amb_entries))
  message('Wrote 4 images to ', images_dir)
  invisible(images_dir)
}

process_one <- function(src, images_dir, out_name, width, extra_attr = NULL) {

  is_unsplash <- is.list(src) && !is.null(src$unsplash_id)

  raw_path <- if (is_unsplash) {
    download_unsplash(src$unsplash_id, images_dir)
  } else {
    path_expand(src)
  }

  out_path <- path(images_dir, out_name)
  img <- image_read(raw_path) |>
    image_resize(geometry_size_pixels(width = width)) |>
    image_strip()
  image_write(img, out_path, format = 'jpeg', quality = 88)

  if (is_unsplash) file_delete(raw_path)

  attr_text <- if (is_unsplash) {
    sprintf('Photo by %s on Unsplash, %s', src$photographer, src$url)
  } else if (!is.null(extra_attr)) {
    extra_attr
  } else {
    sprintf('Local source: %s', basename(path_expand(src)))
  }

  sprintf('- %-20s — %s', out_name, attr_text)
}

download_unsplash <- function(photo_id, images_dir) {
  url <- sprintf('https://unsplash.com/photos/%s/download?force=true',
                 photo_id)
  tmp <- path(images_dir, sprintf('.tmp-unsplash-%s', photo_id))
  utils::download.file(url, tmp, mode = 'wb', quiet = TRUE)
  tmp
}

append_readme <- function(images_dir, entries) {
  readme <- path(images_dir, 'README.md')
  block <- if (!file_exists(readme)) {
    c('# Image attributions', '',
      sprintf('Generated %s by prepare_post_images.R', Sys.Date()), '',
      entries, '')
  } else {
    c('', sprintf('## Added %s', Sys.Date()), '', entries, '')
  }
  cat(paste(block, collapse = '\n'), file = readme, append = file_exists(readme))
}

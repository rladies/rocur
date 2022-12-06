# I tried this - it didn't work.
# Made gif manually.


library(tidyverse)
library(magick)
library(fs)
library(image.libfacedetection)

# download folder of curator infographics
# save relevant graphics in /img

# follow this post for image processing
# https://www.garrickadenbuie.com/blog/process-profile-picture-magick/


# shamelessly copy functions from blog post ------------------------------------
find_face_center <- function(image) {
  detections <- image.libfacedetection::image_detect_faces(image)$detections
  best_face <- which(detections$confidence == max(detections$confidence))
  dims <- as.list(detections[best_face[[1]], ])
  list(
    x = dims$x + dims$width / 2,
    y = dims$y + dims$height / 2
  )
}



resize_fit <- function(image, size = 600) {
  info <- image_info(image)
  size <- min(size, info$width, info$height)
  image_resize(
    image,
    geometry_size_pixels(
      height = if (info$width >= info$height) size,
      width = if (info$height > info$width) size
    )
  )
}

crop_offset <- function(point, range, width) {
  # 4. Catch the edge case first
  if (width >= range) return(0)
  
  if ((point - width / 2) < 0) {
    # 1. must start at left edge
    return(0)
  }
  if ((point + width / 2) > range) {
    # 2. must start at right edge
    return(range - width)
  }
  # 3. enough space on both sides to center width in range
  point - width / 2
}

offset <- crop_offset(
  point = 579,
  range = 900,
  width = 600
)


resize_crop_to_face <- function(image, size = 600) {
  image <- resize_fit(image, size)
  info <- image_info(image)
  
  # size may have changed after refit
  size <- min(info$height, info$width)
  
  is_image_square <- info$width == info$height
  if (is_image_square) {
    return(image)
  }
  
  face <- find_face_center(image)
  
  image_crop(
    image,
    geometry = geometry_area(
      width = size,
      height = size,
      x_off = crop_offset(face$x, info$width, size),
      y_off = crop_offset(face$y, info$height, size)
    )
  )
}
# end functions ----------------------------------------------------------------

pic_files <- fs::dir_ls("img") 
pics <- map(pic_files, image_read)
profiles <- map(pics, resize_crop_to_face)

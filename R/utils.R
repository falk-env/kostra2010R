#' Check whether "INDEX_RC" provided is present in KOSTRA-2010R data set
#'
#' @param idx A string representing the grid cell index.
#'
#' @return A boolean.
#' @export
#'
#' @examples
#' \dontrun{
#' idx_exists("49011")
#' }
idx_exists <- function(idx = NULL) {

  # input validation -----------------------------------------------------------

  checkmate::assert_character(idx, len = 1, min.chars = 1, max.chars = 6)

  # main -----------------------------------------------------------------------

  # get file names
  files <- list.files(system.file(package = "kostra2010R"),
    pattern = "*.shp",
    full.names = TRUE,
    recursive = TRUE
  )

  # read shapefile as sf
  shp <- sf::st_read(files[1], quiet = TRUE)

  # return boolean
  idx %in% shp[["INDEX_RC"]]
}



#' Construct "INDEX_RC" based on given X and Y information
#'
#' @param col Integer {1:79}
#' @param row Integer {1:107}
#'
#' @return A string containing the unique representation of the relevant
#'   "INDEX_RC" field.
#' @export
#'
#' @examples
#' \dontrun{
#' idx_build(11, 49)
#' }
idx_build <- function(col = NULL, row = NULL) {

  # debugging ------------------------------------------------------------------

  # col <- 11
  # row <- 49

  # input validation -----------------------------------------------------------

  checkmate::assert_numeric(col, len = 1, lower = 0, upper = 78)
  checkmate::assert_numeric(row, len = 1, lower = 0, upper = 106)

  # main -----------------------------------------------------------------------

  # line number multiplied by 1000 plus column number
  as.character(row * 1000 + col)
}


#' Construct an sf object of type point using coordinates or specific polygons
#'
#' @param input Vector of length 2 containing numeric representing coordinates,
#'   string of length 1 representing the name of a municipality,
#'   or string of length 5 representing a postal zip code.
#' @param crs (optional) Coordinate reference system definition.
#'
#' @return An object of type `sfc_POINT`.
#' @export
#'
#' @examples
#' \dontrun{
#' p1 <- get_centroid(input = c(367773, 5703579))
#' p2 <- get_centroid(input = c(6.09, 50.46), crs = 4326)
#' p3 <- get_centroid(input = "Essen")
#' p4 <- get_centroid(input = "45145")
#' }
get_centroid <- function(input,
                         crs = 25832) {

  # vector of length 2 containing numeric representing coordinates
  if (inherits(input, "numeric") && length(input) == 2) {

    sf::st_point(input) |> sf::st_sfc(crs = crs)


	# string of length 1 representing the name of a municipality
  } else if (inherits(input, "character") && length(input) == 1 && is.na(as.numeric(input))) {

    # TODO


	# string of length 5 representing a postal zip code
  } else if (inherits(input, "character") && length(input) == 1 && is.numeric(as.numeric(input))) {

    # TODO
  }
}



#' Get index of KOSTRA-2010R cell by means of intersection with given location
#'
#' @param location An object of type `sfc_POINT`.
#'
#' @return A string containing the unique representation of the relevant
#'   "INDEX_RC" field.
#' @export
#'
#' @examples
#' \dontrun{
#' idx_get(p)
#' }
idx_get <- function(location = NULL) {

  # input validation -----------------------------------------------------------

  checkmate::assert_class(location, "sfc_POINT")

  # main -----------------------------------------------------------------------

  # get file names
  files <- list.files(system.file(package = "kostra2010R"),
                      pattern = "*.shp",
                      full.names = TRUE,
                      recursive = TRUE
  )

  # reproject sf point to target crs of the data set
  location <- sf::st_transform(location, 3034)

  # read shapefile
  shp <- sf::st_read(files[1], quiet = TRUE)

  # determine index based on topology relation: intersect
  ind <- lengths(sf::st_intersects(shp, location)) > 0

  # returns index of relevant grid
  shp[["INDEX_RC"]][ind] |> as.character()
}



#' Convert precipitation height in precipitation yield as a function of duration.
#'
#' @param hn Precipitation height in mm.
#' @param d Duration in minutes.
#'
#' @return Precipitation yield in l / (s*ha).
#' @export
#'
#' @examples as_yield(hn = 45.7, d = 60)
as_yield <- function(hn = NULL,
                     d = NULL) {

  # debugging ------------------------------------------------------------------

  # hn <- 45.7
  # d <- 60

  # input validation -----------------------------------------------------------

  checkmate::assert_numeric(hn, len = 1)
  checkmate::assert_numeric(d, len = 1)

  # main -----------------------------------------------------------------------

  (hn * 10000 / 60 / d) |> round(2)
}



#' Convert precipitation yield in precipitation height as a function of duration.
#'
#' @param rh Precipitation yield in l / (s*ha).
#' @param d Duration in minutes.
#'
#' @return Precipitation height in mm.
#' @export
#'
#' @examples as_yield(rh = 126.94, d = 60)
as_height <- function(rh = NULL,
                     d = NULL) {

  # debugging ------------------------------------------------------------------

  # rh <- 126.94
  # d <- 60

  # input validation -----------------------------------------------------------

  checkmate::assert_numeric(rh, len = 1)
  checkmate::assert_numeric(d, len = 1)

  # main -----------------------------------------------------------------------

  (rh / 10000 * 60 * d) |> round(2)
}


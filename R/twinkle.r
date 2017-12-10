#' Twinkle twinkle little start
#'
#' How I wonder what you are... Creates a nice plot with
#'
#' @param n Integer scalar. Number of stars to generate.
#' @param cols Vector of colors. Passed to [grDevices::colorRamp].
#' @param tail Integer scalar. Length of the tails.
#' @param stepsize Numeric scalar.
#' @param deg_from,deg_to Numeric scalar. A value in radians (0 to 2`pi`).
#' @param col_decay_rate Integer scalar. The higher the value the longer the light
#' of the star lasts.
#' @param size_decay_rate Numeric scalar. Multiplied by the size of the star at each step
#' (change of size).
#' @param stargen A function. The star generator. Should receive an integer `n`,
#' number of stars, and return a vector of that length with values greater than 0.
#' @param xlim,ylim Limits of the plotting device. This works together with `stargen`.
#' @param bg Character scalar. Passed to [graphics::par].
#'
#' @return NULL (invisible)
#' @export
#' @author Mateo and George G. Vega
#'
#' @examples
#'
#' set.seed(12)
#' twinkle(100)
#' @importFrom grDevices colorRamp rgb
#' @import graphics
#' @importFrom stats runif rbeta
#' @aliases littlestar estrellita
twinkle <- function(
  n          = 500,
  cols       = c("white","yellow", "gold"),
  tail       = 100,
  stepsize   = .002,
  deg_from   = -pi/8,
  deg_to     = pi/8,
  col_decay_rate = 2,
  size_decay_rate = .99,
  stargen   = function(n) {
    stats::rbeta(n, 2, 5)/10
  },
  xlim       = c(-2, 2),
  ylim       = c(-2, 2),
  bg         = "#041836FF"
) {

  # Setting the device
  oldpar <- graphics::par(no.readonly = TRUE)
  graphics::par(mai = rep(0, 4), bg=bg)
  on.exit(graphics::par(oldpar))
  graphics::plot.new()
  graphics::plot.window(c(-1, 1), c(-1, 1))

  # Generating the stars
  dat <- stargen(n)
  dat <- cbind(dat, dat/2, dat, dat/2, dat, dat/2, dat, dat/2, dat, dat/2)

  # Generating colors
  cols <- grDevices::colorRamp(cols, alpha = TRUE)(stats::runif(n))
  x     <- stats::runif(n, xlim[1], xlim[2])
  y     <- stats::runif(n, ylim[1], ylim[2])
  theta <- stats::runif(n, 0, 2*pi)

  for (i in col_decay_rate:(tail + col_decay_rate)) {

    # Updating color
    colss <- grDevices::rgb(
      cols[,1], cols[,2], cols[,3],
      alpha = cols[,4]/i*col_decay_rate,
      maxColorValue = 255
      )

    theta <- theta + stats::runif(n, -deg_from, deg_to)/i
    x <- x + cos(theta)*stepsize
    y <- y + sin(theta)*stepsize

    graphics::symbols(x, y,
            star   = (dat <- dat*size_decay_rate),
            fg     = colss,
            bg     = colss,
            inches = FALSE,
            add    = TRUE
    )
  }

  invisible(NULL)
}


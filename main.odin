/*

# Statistics lib in Odin
    A simple statistics lib made the Odin programming language

## Description
    This is the beginnings of a simple statistics library made in Odin.

## The following functions have been implmented
    1.  mean
    2.  trimmed_mean( pt=0.2 )
    4.  weighted_mean
    5.  median
    6.  trimmed_median( pt=0.2 )
    7.  weighted_median
    8.  percentile( p=25.0 )
    9.  mode
    10. mean_absolute_deviation( MAD )
    11. variance
    12. standard deviation
    13. median_absolute_deviation( median AD )
    14. min_max_values
    15. range
    16. interquartile range ( IQR )
    17. quantiles( 25 %, 50 %, 75 % )
    18. quartiles( 5 %, 25 %, 50 %, 75 %, 95 % )
    19. deciles( 10 %, 20 %, ..., 50 % ..., 90 % )
    20. frequency_table( num_of_bins = 3 )
    21. histogram( num_of_bins = 3 )
    22. histogram_cumulative_density( num_of_bins = 3 )

License:
    MIT Open License

*/

package main

import "core:fmt"
import "core:math"
import "core:slice"
import "core:os"

import stat "./statistics"

main :: proc ( ) {
    fmt.printfln( "Start statistics in Odin..." )

    stat.test_statistics( )

    fmt.printfln( "...end statistics in Odin." )
}
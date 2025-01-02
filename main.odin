/*

# Statistics lib in Odin
    A simple statistics lib made the Odin programming language

## Description
    This is the beginnings of a simple statistics library made in Odin.

## The following functions have been implmented
    1.  mean
    2.  trimmed_mean( pt=0.2 )
    3.  weighted_mean
    4.  median
    5.  trimmed_median( pt=0.2 )
    6.  weighted_median
    7.  percentile( p=25.0 )
    8.  mode
    9.  mean_absolute_deviation( MAD )
    10. variance
    11. standard deviation
    12. median_absolute_deviation( median AD )
    13. min_max_values
    14. range
    15. interquartile range ( IQR )
    16. quantiles( 25 %, 50 %, 75 % )
    17. quartiles( 5 %, 25 %, 50 %, 75 %, 95 % )
    18. deciles( 10 %, 20 %, ..., 50 % ..., 90 % )
    19. frequency_table( num_of_bins = 3 )
    20. histogram( num_of_bins = 3 )
    21. histogram_cumulative_density( num_of_bins = 3 )

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
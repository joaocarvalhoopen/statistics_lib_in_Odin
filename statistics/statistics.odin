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


package statistics

import "core:fmt"
import "core:math"
import "core:slice"
import "core:os"
import "core:compress"
import "vendor:directx/dxc"
import "core:strings"

Vec :: [ ]f64

//  NOTES:
//        Wikipedia Central tendency
//        https://en.wikipedia.org/wiki/Central_tendency

// The mean is the sum of elements divided by num of elements.
mean :: proc ( vec : Vec ) ->
               f64 {

    if len( vec ) == 0 {
        return 0.0
    }
    sum : f64 = 0
    for & elem in vec {
        sum += elem
    }
    return sum / f64( len( vec ) )
}

// The trimmrd_mean of all element after removing the percent of elements
// between 0 and 0.5 from the beginning and from the end.
// Validates if there is at least 1 ( one ) element to calculate
// the mean after the removal of the beginning and end elements.
trimmed_mean :: proc ( vec                             : Vec,
                       perc_elem_to_trim_on_all_dataset : f64 ) ->
                     ( trimmed_mean : f64,
                       msg          : string,
                       ok           : bool    ) {

    num_elem_to_trim_on_each_side :=  int( f64( len( vec ) ) * perc_elem_to_trim_on_all_dataset ) / 2
    if num_elem_to_trim_on_each_side * 2 >= len( vec ) - 1 {
        trimmed_mean = 0
        msg          = "ERROR: trimmed_mean - the percent of number of elements to remove at each side is bigger then 2 * len( vec ) - 1, " +
                       "there is not one single element that stays on the internal copy of vec after this trim."
        ok           = false
        return trimmed_mean, msg, ok
    }

    p := num_elem_to_trim_on_each_side
    trimmed_mean = #force_inline mean( vec[ p : len( vec ) - p ] )
    msg          = ""
    ok           = true
    return trimmed_mean, msg, ok
}

// It's the sum of all elements multiplied by each element weight and
// devided by the number of elements.
// The len( vec ) must be equal to len( vec_weights ) .
weighted_mean :: proc ( vec         : Vec,
                        vec_weights : Vec  ) ->
                      ( weighted_mean : f64,
                        msg           : string,
                        ok            : bool ) {

    if len( vec ) != len( vec_weights ) {
        weighted_mean = 0
        msg           = "ERROR: weighted_mean - the function parameters has a different number of elements " +
                        "len( vec ) != len( vec_weights ) ."
        ok            = false
        return weighted_mean, msg, ok
    }
    if len( vec ) == 0 {
        weighted_mean = 0
        msg           = "The vec has zero elements."
        ok            = true
        return weighted_mean, msg, ok
    }

    for elem in vec_weights {
        if elem < 0 {
            weighted_mean = 0
            msg             = "ERROR: weighted_mean - the weights must be 0 or positive values."
            ok              = false
            return weighted_mean, msg, ok
        }
    }

    sum : f64 = 0
    for i in 0 ..< len( vec ) {
        sum += vec[ i ] * vec_weights[ i ]
    }

    weighted_mean = sum / f64( len( vec ) )
    msg           = ""
    ok            = true
    return weighted_mean, msg, ok
}

// Calculation of the median
// 1. Sort the data in ascending order.
// 2. If the number of data points is odd, return the middle element.
// 3. If even, return the average of the two middle elements.
median :: proc ( vec : Vec ) ->
               ( median : f64 ) {

    n := len( vec )
    if n == 0 {
        median = 0
        return median
    }
    sorted_data := slice.clone( vec )
    slice.sort( sorted_data )
    mid := n / 2

    if n % 2 == 1 {
        median = sorted_data[ mid ]
        return median
    } else {
        median = ( sorted_data[ mid - 1 ] + sorted_data[ mid ] ) / 2
        return median
    }
}

// Calculation of the trimmed_median
// trim_fraction: A f64 between 0 and 0.5 representing the fraction to trim from each end.
// 1. Sort the data in ascending order.
// 2. Determine the number of elements to trim from each end based on the trim_fraction.
// 3. Remove the lowest and highest trim_fraction of data.
// 4. Calculate the median of the trimmed data.
trimmed_median :: proc ( vec          : Vec,
                         trim_percent : f64 ) ->     // 0 <= trimmed_percent < 0.5
                       ( trimmed_median : f64,
                         msg    : string,
                         ok     : bool    ) {

    if trim_percent <= 0  || trim_percent > 0.5 {
        trimmed_median = 0
        msg            = "ERROR: trimmed_median - the trim_percent is not between 0 and 0.5 inclusive!"
        ok             = false
        return trimmed_median, msg, ok
    }

    n := len( vec )
    if n == 0 {
        trimmed_median = 0
        msg            = ""
        ok             = true
        return trimmed_median, msg, ok
    }
    sorted_data := slice.clone( vec )
    slice.sort( sorted_data )

    trim_count := int( f64( n ) * trim_percent ) / 2

    if trim_count * 2 >= n {
        trimmed_median = 0
        msg            = "ERROR: trimmed_median - the trim_percent is to large and no data is left after trimming!"
        ok             = false
        return trimmed_median, msg, ok
    }

    trimmed_data := sorted_data[ trim_count : n - trim_count ]

    new_n := len( trimmed_data )
    mid   := new_n / 2

    if new_n % 2 == 1 {
        trimmed_median = sorted_data[ mid ]
    } else {
        trimmed_median = ( sorted_data[ mid - 1 ] + sorted_data[ mid ] ) / 2
    }

    msg            = ""
    ok             = true
    return trimmed_median, msg, ok
}

// Calculation of the weighted_median.
// 1. Pair each data point with its weight.
// 2. Sort the pairs based on the data values in ascending order.
// 3. Compute the cumulative sum of weights.
// 4. The weighted median is the data point where the cumulative weight reaches at least half of the total weight.
weighted_median :: proc ( vec         : Vec,
                          vec_weights : Vec  ) ->
                        ( weighted_median : f64,
                          msg             : string,
                          ok              : bool    ) {

    if len( vec ) != len( vec_weights ) {
        weighted_median = 0
        msg             = "ERROR: weighted_median - the function parameters has a different number of elements " +
                          "len( vec ) != len( vec_weights ) ."
        ok              = false
        return weighted_median, msg, ok
    }

    if len( vec ) == 0 {
        weighted_median = 0
        msg             = "The weighted median has no elements"
        ok              = true
        return weighted_median, msg, ok
    }
    for elem in vec_weights {
        if elem < 0 {
            weighted_median = 0
            msg             = "ERROR: weighted_median - the weights must be 0 or positive values."
            ok              = false
            return weighted_median, msg, ok
        }
    }

    Pair :: struct {
        value  : f64,
        weight : f64,
    }

    pair_compare_func :: proc ( a: Pair, b: Pair ) ->
                      bool {
        if a.value > b.value {
            return true
        } else {
            return false
        }
    }

    sorted_data := make( [ ]Pair, len( vec ) )
    defer delete( sorted_data )

    total_weight : f64 = 0
    for i in 0 ..< len( vec ) {
        sorted_data[ i ] = Pair{
                               value  = vec[ i ],
                               weight = vec_weights[ i ]
                              }
        total_weight += vec_weights[ i ]
    }

    slice.sort_by( sorted_data, pair_compare_func )

    cumulative_weight : f64 = 0
    for pair in sorted_data {

        cumulative_weight += pair.weight
        if cumulative_weight >= total_weight / 2 {

            weighted_median = pair.value
            msg             = ""
            ok              = true
            return weighted_median, msg, ok
        }
    }

    // If an error occurred because of floating point accuracy, return the last value
    weighted_median = sorted_data[ len( sorted_data ) - 1 ].value
    msg             = ""
    ok              = true
    return weighted_median, msg, ok
}


// IMPORTANT NOTE: This algorithm can be heavy for large datasets. There is a better
//                 algorithm ( aproximation ) for large datasets that is less computationally
//                 expensive see the paper from : Zhang and Wang 2007.
//
// Calculate the value at the percentile of vec.
// The pecentile parameter is betwen 0 and 100.
// 1. Sort the data in ascending order.
// 2. Compute the rank using the formula: rank = ( P / 100 ) * ( N + 1 )
//    where N is the number of data points.
// 3. If the rank is an integer, the percentile is the value at that rank.
// 4. If the rank is not an integer, interpolate between the surrounding ranks.
percentile :: proc ( vec        : Vec,
                     percentile : f64  ) ->    //  0 <= P <= 100
                   ( value_at_percentile : f64,
                     msg                 : string,
                     ok                  : bool    ) {

    if len( vec ) == 0 {
        value_at_percentile = 0
        msg                 = "ERROR: percentile - the function parameter vec has 0 ( zero ) elements."
        ok                  = false
        return value_at_percentile, msg, ok
    }
    if percentile < 0 || percentile > 100 {
        value_at_percentile = 0
        msg                 = "ERROR: percentile - the function parameter percentile must be 0 <= percentile <= 100 ."
        ok                  = false
        return value_at_percentile, msg, ok
    }
    if percentile == 0 {
        value_at_percentile = 0
        msg                 = ""
        ok                  = true
        return value_at_percentile, msg, ok
    }

    sorted_data := slice.clone( vec )
    slice.sort( sorted_data )

    len_vec := len( sorted_data )
    rank := ( percentile / 100 ) * ( f64( len_vec ) + 1 )

    if rank < 1 {

        value_at_percentile = sorted_data[ 0 ]
        msg                 = ""
        ok                  = true
        return value_at_percentile, msg, ok
    } else {
        if rank > f64( len_vec ) {

            value_at_percentile = sorted_data[ len( sorted_data ) - 1 ]
            msg                 = ""
            ok                  = true
            return value_at_percentile, msg, ok
        } else {

            lower_index := int( rank ) - 1
            fractional  := rank - f64( int( rank ) )
            if fractional == 0 {

                value_at_percentile = sorted_data[ lower_index ]
                msg                 = ""
                ok                  = true
                return value_at_percentile, msg, ok
            } else {

                upper_index := lower_index + 1
                // Handle the case where upper_index might be out of bounds
                if upper_index >= len_vec {

                    value_at_percentile = sorted_data[ lower_index ]
                    msg                 = ""
                    ok                  = true
                    return value_at_percentile, msg, ok
                }
                lower_value := sorted_data[ lower_index ]
                upper_value := sorted_data[ upper_index ]
                value := lower_value + fractional * ( upper_value - lower_value )

                value_at_percentile = value
                msg                 = ""
                ok                  = true
                return value_at_percentile, msg, ok
            }
        }
    }

}

// Calculate the mode value or values, the values that have the maximum occurencies in vec.
// 1. Iterate through the data and count the frequency of each value.
// 2. Identify the value(s) with the highest frequency.
// 3. If multiple values have the same highest frequency, return all of them.
//    Otherwise, return the single mode.
mode :: proc ( vec        : Vec ) ->
             ( mode_values : [ dynamic ]f64,
               max_count   : int,
               msg         : string,
               ok          : bool    ) {

    if len( vec ) == 0 {
        clear_dynamic_array( & mode_values )
        max_count           = 0
        msg                 = "ERROR: mode - the vec has no elements."
        ok                  = false
        return mode_values, max_count, msg, ok
    }

    frequency := make( map[f64]int )
    defer delete( frequency )

    for elem in vec {
        if elem in frequency {
            frequency[ elem ] += 1
        } else {
            frequency[ elem ] = 1
        }
    }

    // Find max_val
    max_count = min( int )
    for key, val in frequency {
        max_count = max( max_count, val )
    }

    // Collect all elements that have the max value.
    for key, val in frequency {
        if val == max_count {
            append_elem( & mode_values, key )
        }
    }

    slice.sort( mode_values[ : ] )

    // max_count
    msg                 = ""
    ok                  = true
    return mode_values, max_count,  msg, ok
}



// -------------------------------
// Extimates of Variability

// The Mean Absolute Deviation ( MAD ) is the average of the absolute differences
// between each data point and the mean of the dataset.
mean_absolute_deviation :: proc ( vec : Vec ) ->
                                ( mean_abs_dev : f64,
                                  msg          : string,
                                  ok           : bool    ) {

    if len( vec ) == 0 {
        mean_abs_dev = 0
        msg          = "ERROR: mean_absolute_deviation - the vec has no elements."
        ok           = false
        return mean_abs_dev, msg, ok
    }

    mean_val := #force_inline mean( vec )

    abs_dev_sum : f64 = 0
    for elem in vec {
        abs_dev_sum += abs( elem - mean_val )
    }
    mean_abs_dev = abs_dev_sum / f64( len( vec ) )

    msg = ""
    ok  = true
    return mean_abs_dev, msg, ok
}

// Variance measures the average of the squared differences between each data point
// and the mean of the dataset. It quantifies the spread of the data points.
variance :: proc ( vec : Vec ) ->
                 ( variance_val : f64,
                   msg          : string,
                   ok           : bool    ) {

    if len( vec ) == 0 {
        variance_val = 0
        msg           = "ERROR: variance - the vec has no elements."
        ok            = false
        return variance_val, msg, ok
    }

    mean_val := #force_inline mean( vec )

    square_diff_sum : f64 = 0
    for elem in vec {
        square_diff_sum += ( elem - mean_val ) * ( elem - mean_val )
    }
    variance_val = square_diff_sum / f64( len( vec ) )

    msg = ""
    ok  = true
    return variance_val, msg, ok
}

// Standard Deviation is the square root of the variance.
// It provides a measure of the average distance between each data point and the mean.
standard_deviation :: proc ( vec : Vec ) ->
                           ( std_dev : f64,
                             msg     : string,
                             ok      : bool    ) {

    if len( vec ) == 0 {
        std_dev = 0
        msg     = "ERROR: standard_deviation - the vec has no elements."
        ok      = false
        return std_dev, msg, ok
    }

    variance, msg_2, ok_2 := #force_inline variance( vec )
    if ! ok_2 {
        std_dev = 0
        msg     = msg_2
        ok      = false
        return std_dev, msg, ok
    }

    std_dev = math.sqrt_f64( variance )
    msg     = ""
    ok      = true
    return std_dev, msg, ok
}



// The Median Absolute Deviation ( Median AD) is the median of the absolute
// differences between each data point and the median of the dataset.
// It is a robust measure of statistical dispersion.
median_absolute_deviation :: proc ( vec : Vec ) ->
                                  ( median_abs_dev : f64,
                                    msg            : string,
                                    ok             : bool    ) {

    if len( vec ) == 0 {
        median_abs_dev = 0
        msg     = "ERROR: median_absolute_deviation - the vec has no elements."
        ok      = false
        return median_abs_dev, msg, ok
    }

    // Calculate the median of the vec.
    median_val := #force_inline median( vec )

    abs_deviation_vec := make( [ ]f64, len( vec ) )
    defer delete( abs_deviation_vec )

    for i in 0 ..< len( vec ) {
        abs_deviation_vec[ i ] = abs( vec[ i ] - median_val )
    }

    // Calculate the median of the absolute deviation vec.
    median_abs_dev = #force_inline median( abs_deviation_vec )
    msg     = ""
    ok      = true
    return median_abs_dev, msg, ok
}

// min max values - The minimum and the maximum values of the dataset.
min_max_values :: proc ( vec : Vec ) ->
                       ( min_val : f64,
                         max_val : f64,
                         msg     : string,
                         ok      : bool    ) {

    if len( vec ) == 0 {
        min_val = 0
        max_val = 0
        msg     = "ERROR: min_max_values - the vec has no elements."
        ok      = false
        return min_val, max_val, msg, ok
    }

    min_val = max( f64 )
    max_val = min( f64 )
    for elem in vec {
        min_val = min( min_val, elem )
        max_val = max( max_val, elem )
    }

    msg     = ""
    ok      = true
    return min_val, max_val, msg, ok
}

// Range - The difference between the largest and smallest
//         numbers in the dataset.
range :: proc ( vec : Vec ) ->
              ( range_val : f64 ) {

    if len( vec ) == 0 {
        range_val = 0
        return range_val
    }

    min_val, max_val, _, _ := #force_inline min_max_values( vec )

    range_val = max_val - min_val
    return range_val
}

// Interquartile Range ( IQR ) - The difference between the 75th percentile
// and the 25th percentile.
interquartile_range :: proc ( vec : Vec ) ->
                            ( iqr : f64,
                              msg : string,
                              ok  : bool    ) {

    if len( vec ) == 0 {
        iqr = 0
        msg     = "ERROR: interquartile_range - the vec has no elements."
        ok      = false
        return iqr, msg, ok
    }

    percentile_25, msg_1, ok_1 := percentile( vec, percentile=25 )
    if ! ok_1 {
        iqr = 0
        msg = msg_1
        ok  = false
        return iqr, msg, ok
    }

    percentile_75, msg_2, ok_2 := percentile( vec, percentile=75 )
    if ! ok_2 {
        iqr = 0
        msg = msg_2
        ok  = false
        return iqr, msg, ok
    }

    iqr = percentile_75 - percentile_25
    msg = ""
    ok  = true
    return iqr, msg, ok
}

// quantiles - percentile( vec, [ slice of percentiles ] )
// The percentiles_vec has to have values between 0 and 100 inclusive.
// The user of the lib is responsible for dealocating the returned vec.
quantiles :: proc ( vec             : Vec,
                    percentiles_vec : Vec   ) ->
                  ( quantiles_vec : Vec,
                    msg           : string,
                    ok            : bool    ) {

    if len( vec ) == 0 || len( percentiles_vec ) == 0 {
        quantiles_vec = [ ]f64{ } // Empty slice.
        msg           = "ERROR: quantiles - the vec or the pecentile_vec has no elements."
        ok            = false
        return quantiles_vec, msg, ok
    }

    if len( percentiles_vec ) == 0 {
        quantiles_vec = [ ]f64{ } // Empty slice.
        msg           = "ERROR: quantiles - the pecentile_vec has to have at least one element."
        ok            = false
        return quantiles_vec, msg, ok
    }

    quantiles_vec = make( [ ]f64, len( percentiles_vec ) )

    for perc_index in 0 ..< len( percentiles_vec ) {
        percentile_x, msg_1, ok_1 := percentile( vec, percentile=percentiles_vec[ perc_index ] )
        if ! ok_1 {
            delete( quantiles_vec )
            quantiles_vec = [ ]f64{ } // Empty slice.
            msg           = msg_1
            ok            = false
            return quantiles_vec, msg, ok
        }

        quantiles_vec[ perc_index ] = percentile_x
   }

    msg = ""
    ok  = true
    return quantiles_vec, msg, ok
}

// quartiles - quantiles( vec, [ 5, 25, 50, 75, 95 ] )
quartiles :: proc ( vec : Vec ) ->
                  ( quartiles_vec : Vec,
                    msg           : string,
                    ok            : bool    ) {

    if len( vec ) == 0 {
        quartiles_vec = [ ]f64{ } // Empty slice.
        msg           = "ERROR: quartiles - the vec has no elements."
        ok            = false
        return quartiles_vec, msg, ok
    }

    percentiles_vec := [ ? ]f64 { 5, 25, 50, 75, 95 }

    quartiles_vec_tmp, msg_1, ok_1 := quantiles( vec, percentiles_vec[ : ] )
    quartiles_vec = quartiles_vec_tmp
    if ! ok_1 {
        msg = msg_1
        ok  = false
        return quartiles_vec, msg, ok
    }

    msg = ""
    ok = true
    return quartiles_vec, msg, ok
}

// deciles - quantiles( vec, [ 10, 20, 30, 40, 50, 60, 70, 80, 90 ] )
deciles :: proc ( vec : Vec ) ->
                ( deciles_vec : Vec,
                  msg         : string,
                  ok          : bool    ) {

    if len( vec ) == 0 {
        deciles_vec = [ ]f64{ } // Empty slice.
        msg         = "ERROR: deciles - the vec has no elements."
        ok          = false
        return deciles_vec, msg, ok
    }

    percentiles_vec := [ ? ]f64 { 10, 20, 30, 40, 50, 60, 70, 80, 90 }

    deciles_vec_tmp, msg_1, ok_1 := quantiles( vec, percentiles_vec[ : ] )
    deciles_vec = deciles_vec_tmp
    if ! ok_1 {
        msg = msg_1
        ok  = false
        return deciles_vec, msg, ok
    }

    msg = ""
    ok  = true
    return deciles_vec, msg, ok
}

// Frequency Table - bin_number, bin_range_min, bin_range_max, count
Freq_Data :: struct {

    bin_number    : uint,
    bin_range_min : f64,
    bin_range_max : f64,
    count         : uint,
}

// Creates and fills the frequency table.
// The user is responsible for deallocating the returned freq_table if in the case of a ok == true return.
frequency_table :: proc ( vec         : Vec,
                          num_of_bins : uint ) ->
                        ( freq_table : [ ]Freq_Data,
                          msg         : string,
                          ok          : bool    ) {

    if len( vec ) == 0 {
        freq_table = [ ]Freq_Data{ } // Empty slice.
        msg         = "ERROR: frequency_table - the vec has no elements."
        ok          = false
        return freq_table, msg, ok
    }

    if num_of_bins == 0 {
        freq_table = [ ]Freq_Data{ } // Empty slice.
        msg         = "ERROR: frequency_table - The number of bins can't be zero, it has to be one or more bins."
        ok          = false
        return freq_table, msg, ok
    }

    min_val, max_val, msg_1, ok_1 := min_max_values( vec )
    if ! ok_1 {
        freq_table = [ ]Freq_Data{ } // Empty slice.
        msg         = msg_1
        ok          = false
        return freq_table, msg, ok
    }
    range := max_val - min_val
    delta := range / f64( num_of_bins )

    freq_table_tmp := make( [ dynamic ]Freq_Data, 0, num_of_bins )

    start_value := min_val
    end_value   := min_val + delta
    for i in 0 ..< num_of_bins {
        end_value = start_value + delta

        count : uint = 0
        for elem in vec {

            if elem >= start_value && elem < end_value {
                count += 1
            }
            // If we are in the last bin and we are adding the last element, we must include that value,
            // to make things write.
            if ( num_of_bins - 1 == i ) && abs( elem - max_val ) < 0.000_001 {
                count += 1
            }
        }

        freq_data := Freq_Data{
                    bin_number    = i + 1,
                    bin_range_min = start_value,
                    bin_range_max = end_value,
                    count         = count,
                }

        start_value += delta

        append_elem( & freq_table_tmp, freq_data )
    }

    // freq_table
    freq_table = freq_table_tmp[ : ]
    msg        = ""
    ok         = true
    return freq_table, msg, ok
}

// Return a ordered slice of histogram bins that in parte cery equal to the frequency table
// but with two outputs.
// The user is responsible for deallocating the freq_table and the histo (histogram),
// that are returned.
histogram :: proc ( vec         : Vec,
                    num_of_bins : uint ) ->
                  ( freq_table  : [ ]Freq_Data,
                    histo_vec   : [ ]uint,
                    msg         : string,
                    ok          : bool    ) {

    if len( vec ) == 0 {
        freq_table = [ ]Freq_Data{ }  // Empty slice.
        histo_vec  = [ ]uint{ }       // Emptu slice.
        msg        = "ERROR: histogram - the vec has no elements."
        ok         = false
        return freq_table, histo_vec, msg, ok
    }

    if num_of_bins == 0 {
        freq_table = [ ]Freq_Data{ }  // Empty slice.
        histo_vec  = [ ]uint{ }       // Empty slice.
        msg        = "ERROR: histogram - The number of bins can't be zero, it has to be one or more bins."
        ok         = false
        return freq_table, histo_vec, msg, ok
    }

    histo_vec = [ ]uint{ }    // Empty histogram
    freq_table_tmp, msg_1, ok_1 := frequency_table( vec, num_of_bins )
    if ok_1 {
        histo_vec = make( [ ]uint, len( freq_table_tmp ) )
        for i in 0 ..< len( freq_table_tmp ) {
            histo_vec[ i ] = freq_table_tmp[ i ].count
        }
    }

    freq_table = freq_table_tmp
    // histo
    msg        = msg_1
    ok         = ok_1
    return freq_table, histo_vec, msg, ok
}

// Returns a the histogram_cumulative_debnsity value in absolute value and normallized between 0 and 1.0 .
histogram_cumulative_density :: proc ( histo_vec : [ ]uint ) ->
                                     ( histo_cumulative_density            : [ ]uint,
                                       histo_cumulative_density_normalized : [ ]f64,
                                       msg                                 : string,
                                       ok                                  : bool    ) {

    if len( histo_vec ) == 0 {
        histo_cumulative_density            = [ ]uint{ }  // Empty slice.
        histo_cumulative_density_normalized = [ ]f64{ }   // Empty slice.
        msg                                 = "ERROR: histogram_cumulative_density - the histo_vec has no elements."
        ok                                  = false
        return histo_cumulative_density, histo_cumulative_density_normalized, msg, ok
    }

    histo_cumulative_density            = make( [ ]uint, len( histo_vec ) )
    histo_cumulative_density_normalized = make( [ ]f64, len( histo_vec ) )

    // Cumulative density
    accumulator : uint = 0
    for i in 0 ..< len( histo_vec ) {
        accumulator += histo_vec[ i ]
        histo_cumulative_density[ i ] = accumulator
    }

    // Normalized
    // NOTE: The accumulator has the max accumulated value.
    accumulator_normalized : f64 = 0
    for i in 0 ..< len( histo_vec ) {
        accumulator_normalized += f64( histo_vec[ i ] ) / f64( accumulator )
        histo_cumulative_density_normalized[ i ] = accumulator_normalized
    }
    // This is here to remove possible floating point accumulated rounding errors.
    max_index := len( histo_cumulative_density_normalized ) - 1
    if histo_cumulative_density_normalized[ max_index ] > 1.0 {
        histo_cumulative_density_normalized[ max_index ] = 1.0
    }

    // histo_cumulative_density
    // histo_cumulative_density_normalized
    msg = ""
    ok  = true
    return histo_cumulative_density, histo_cumulative_density_normalized, msg, ok
}

// -----------
// Utils

// Print the slice.
print_slice :: proc ( vec_name : string,
                      vec      : Vec     ) {

    fmt.printf( "%s\n   ", vec_name )
    for elem, i in vec {

        fmt.printf( "%f", elem )
        if i != len( vec ) - 1 {
            fmt.printf( ", " )
        }
    }
    fmt.printfln( "" )
}

/*
vec_to_string :: proc ( vec : Vec ) ->
                      ( str_vec : string ) {

    str_builder : strings.Builder = strings.builder_make( 100 )

    fmt.sbprintf( & str_builder, "[" )
    for elem, i in vec {

        fmt.sbprintf( & str_builder, "%0.3f", elem )
        if i != len( vec ) - 1 {
            fmt.sbprintf( & str_builder, ", " )
        }
    }
    fmt.sbprintf( & str_builder, "]" )

    return strings.to_string( str_builder )
}
*/

vec_to_string :: proc ( vec : [ ]$T ) ->
                      ( str_vec : string ) {

    str_builder : strings.Builder = strings.builder_make( 100 )

    fmt.sbprintf( & str_builder, "[" )
    for elem, i in vec {

        switch  typeid_of( T ) {

            case f64 :
                fmt.sbprintf( & str_builder, "%0.3f", elem )

            case int :
                fmt.sbprintf( & str_builder, "%d", elem )

            case uint :
                fmt.sbprintf( & str_builder, "%v", elem )

            case :
                fmt.printfln( "ERROR : vec_to_string( ) - Unsuported type of vec element! " )
                os.exit( - 1 )
        }
        // fmt.sbprintf( & str_builder, "%0.3f", elem )
        if i != len( vec ) - 1 {
            fmt.sbprintf( & str_builder, ", " )
        }
    }
    fmt.sbprintf( & str_builder, "]" )

    return strings.to_string( str_builder )
}

test_statistics :: proc ( ) {

    fmt.printfln( "Start test_statistics..." )

    vec_1         := [ 10 ]f64{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
    vec_1_weights := [ 10 ]f64{ 1, 2, 1, 2, 1, 2, 1, 2, 1, 2 }
//    vec_1_weights := [ 10 ]f64{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 }
    vec_2         := [ 10 ]f64{ 1, 2, 2, 4, 5, 6, 7, 8, 10, 10 }



    print_slice( "vec_1 : ",         vec_1[ : ] )
    print_slice( "vec_1_weights : ", vec_1_weights[ : ] )
    fmt.print( "\n" )

    // mean
    res_mean := mean( vec_1[ : ] )
    fmt.printfln( " mean                              : %v", res_mean )

    // trimmed_mean
    perc_of_elems_to_trim := 0.2
    res_trimmed_mean, msg_1,  ok_1 := trimmed_mean( vec_1[ : ], perc_of_elems_to_trim )
    if ! ok_1 {
        fmt.printfln( "%s", msg_1 )
    } else {
        fmt.printfln( " trimmed_mean( pt=%.1f )            : %v",
                      perc_of_elems_to_trim,
                      res_trimmed_mean )
    }

    // weighted_mean
    res_weighted_mean, msg_2, ok_2 := weighted_mean( vec_1[ : ], vec_1_weights[ : ] )
    if ! ok_2 {
        fmt.printfln( "%s", msg_2 )
    } else {
        fmt.printfln( " weighted_mean                     : %v", res_weighted_mean )
    }

    // median
    res_median := median( vec_1[ : ] )
    fmt.printfln( " median                            : %v", res_median )

    // trimmed_median
    perc_of_elems_to_trim = 0.2
    res_trimmed_median, msg_3, ok_3 := trimmed_median( vec_1[ : ], perc_of_elems_to_trim )
    if ! ok_3 {
        fmt.printfln( "%s", msg_3 )
    } else {
        fmt.printfln( " trimmed_median( pt=%.1f )          : %v",
                      perc_of_elems_to_trim,
                      res_trimmed_median )
    }

    // weighted_median
    res_weighted_median, msg_4, ok_4 := weighted_median( vec_1[ : ], vec_1_weights[ : ] )
    if ! ok_4 {
        fmt.printfln( "%s", msg_4 )
    } else {
        fmt.printfln( " weighted_median                   : %v    NOTE: This is correct!", res_weighted_median )
    }

    // percentile
    percentile_val : f64 = 0    // 0 %
    res_percentile_0, msg_5, ok_5 := percentile( vec_1[ : ], percentile_val )
    if ! ok_5 {
        fmt.printfln( "%s", msg_5 )
    } else {
        fmt.printfln( " percentile( p=%.1f )               : %v",
                      percentile_val,
                      res_percentile_0 )
    }

    percentile_val = 25    // 25 %
    res_percentile_25, _, _ := percentile( vec_1[ : ], percentile_val )
    fmt.printfln( " percentile( p=%.1f )              : %v",  percentile_val, res_percentile_25 )

    percentile_val = 50    // 50 %
    res_percentile_50, _, _ := percentile( vec_1[ : ], percentile_val )
    fmt.printfln( " percentile( p=%.1f )              : %v",  percentile_val, res_percentile_50 )

    percentile_val = 75    // 75 %
    res_percentile_75, _, _ := percentile( vec_1[ : ], percentile_val )
    fmt.printfln( " percentile( p=%.1f )              : %v",  percentile_val, res_percentile_75 )

    percentile_val = 100    // 100 %
    res_percentile_100, _, _ := percentile( vec_1[ : ], percentile_val )
    fmt.printfln( " percentile( p=%.1f )             : %v",  percentile_val, res_percentile_100 )

    // mode
    res_mode_vec_1, res_max_count_vec_1, msg_6, ok_6 := mode( vec_1[ : ] )
    if ! ok_6 {
        fmt.printfln( "%s", msg_6 )
    } else {
        fmt.printfln( " mode vec_1                        : %v  count %d", res_mode_vec_1, res_max_count_vec_1 )
    }

    print_slice( "vec_2: ", vec_2[ : ] )

    res_mode_vec_2, res_max_count_vec_2, _, _ := mode( vec_2[ : ] )
    fmt.printfln( " mode vec_2                        : %v  count %d", res_mode_vec_2, res_max_count_vec_2 )

    // Mean Absolute Deviation ( MAD )
    res_mean_abs_dev, msg_7, ok_7 := mean_absolute_deviation( vec_1[ : ] )
    if ! ok_7 {
        fmt.printfln( "%s", msg_7 )
    } else {
        fmt.printfln( " mean_absolute_deviation( MAD )    : %v", res_mean_abs_dev )
    }

    // Variance
    res_variance, msg_8, ok_8 := variance( vec_1[ : ] )
    if ! ok_8 {
        fmt.printfln( "%s", msg_8 )
    } else {
        fmt.printfln( " variance                          : %v", res_variance )
    }

    // Standard Deviation
    res_std_dev, msg_9, ok_9 := standard_deviation( vec_1[ : ] )
    if ! ok_9 {
        fmt.printfln( "%s", msg_9 )
    } else {
        fmt.printfln( " standard deviation                : %v", res_std_dev )
    }

    // Median of the absolute deviations.
    res_median_abs_dev, msg_10, ok_10 := median_absolute_deviation( vec_1[ : ] )
    if ! ok_10 {
        fmt.printfln( "%s", msg_10 )
    } else {
        fmt.printfln( " median_absolute_deviation( median AD ) : %v", res_median_abs_dev )
    }

    // Min Max values
    res_min_val, res_max_val, msg_11, ok_11 := min_max_values( vec_1[ : ] )
    if ! ok_11 {
        fmt.printfln( "%s", msg_11 )
    } else {
        fmt.printfln( " min_max_values                    : [%v, %v]", res_min_val, res_max_val )
    }

    // Range
    res_range := range( vec_1[ : ] )
    fmt.printfln( " range                             : %v", res_range )

    // Inter-Quartile Range ( IQR )
    res_interquartile_range, msg_12, ok_12 := interquartile_range( vec_1[ : ] )
    if ! ok_12 {
        fmt.printfln( "%s", msg_12 )
    } else {
        fmt.printfln( " interquartile range ( IQR )       : %v", res_interquartile_range )
    }

    // Quantiles
    percentiles_vec := [ ? ]f64 { 25, 50, 75 }
    res_quantiles_vec, msg_13, ok_13 := quantiles( vec_1[ : ], percentiles_vec[ : ] )
    if ! ok_13 {
        fmt.printfln( "%s", msg_13 )
    } else {
        fmt.printfln( " quantiles( 25 %%, 50 %%, 75 %% )     : %v", vec_to_string( res_quantiles_vec ) )
    }

    // Quartiles
    res_quartiles_vec, msg_14, ok_14 := quartiles( vec_1[ : ] )
    if ! ok_14 {
        fmt.printfln( "%s", msg_14 )
    } else {
        fmt.printfln( " quartiles( 5 %%, 25 %%, 50 %%, 75 %%, 95 %% ) : %v", vec_to_string( res_quartiles_vec ) )
    }

    // Deciles
    res_deciles_vec, msg_15, ok_15 := deciles( vec_1[ : ] )
    if ! ok_15 {
        fmt.printfln( "%s", msg_15 )
    } else {
        fmt.printfln( " deciles( 10 %%, 20 %%, ..., 50 %% ..., 90 %% ) : %v", vec_to_string( res_deciles_vec ) )
    }

    // Frequency_table
    num_of_bins : uint = 3  // 10
    res_freq_table, msg_16, ok_16 := frequency_table( vec_1[ : ], num_of_bins )
    if ! ok_16 {
        fmt.printfln( "%s", msg_16 )
    } else {
        fmt.printfln( " frequency_table( num_of_bins = 3 ): %#v", res_freq_table )
    }

    // histogram
    num_of_bins = 3  // 10
    res_freq_table_2, res_histogram, msg_17, ok_17 := histogram( vec_1[ : ], num_of_bins )
    if ! ok_17 {
        fmt.printfln( "%s", msg_17 )
    } else {
        fmt.printfln( " histogram( num_of_bins = 3 ): %v", vec_to_string( res_histogram ) )
    }

    // histogram_cumulative_density
    res_histo_cumul_dens,
    res_histo_cumul_dens_norm,
    msg_18,
    ok_18 :=  histogram_cumulative_density( res_histogram )
    if ! ok_18 {
        fmt.printfln( "%s", msg_18 )
    } else {
        fmt.printfln( " histogram_cumulative_density( num_of_bins = 3 ): %v <-> %v",
                      vec_to_string( res_histo_cumul_dens ),
                      vec_to_string( res_histo_cumul_dens_norm )  )
    }

    // TODO : Continnue implementing more statistics functions.


    fmt.print( "\n" )
    fmt.printfln( "...end test_statistics." )
}


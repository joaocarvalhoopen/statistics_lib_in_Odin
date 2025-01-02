# Statistics lib in Odin
A simple statistics lib made in the Odin programming language

## Description
This is the beginnings of a simple statistics library made in Odin.

## The following functions have been implmented
1. mean
2. trimmed_mean( pt=0.2 )
4. weighted_mean
5. median
6. trimmed_median( pt=0.2 )
7. weighted_median
8. percentile( p=25.0 )
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

## Example output
```
./bin/statistics.exe
Start statistics in Odin...
Start test_statistics...
vec_1 : 
   1.000, 2.000, 3.000, 4.000, 5.000, 6.000, 7.000, 8.000, 9.000, 10.000
vec_1_weights : 
   1.000, 2.000, 1.000, 2.000, 1.000, 2.000, 1.000, 2.000, 1.000, 2.000

 mean                              : 5.5
 trimmed_mean( pt=0.2 )            : 5.5
 weighted_mean                     : 8.5
 median                            : 5.5
 trimmed_median( pt=0.2 )          : 4.5
 weighted_median                   : 6    NOTE: This is correct!
 percentile( p=0.0 )               : 0
 percentile( p=25.0 )              : 2.75
 percentile( p=50.0 )              : 5.5
 percentile( p=75.0 )              : 8.25
 percentile( p=100.0 )             : 10
 mode vec_1                        : [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  count 1
vec_2: 
   1.000, 2.000, 2.000, 4.000, 5.000, 6.000, 7.000, 8.000, 10.000, 10.000
 mode vec_2                        : [2, 10]  count 2
 mean_absolute_deviation( MAD )    : 2.5
 variance                          : 8.25
 standard deviation                : 2.8722813232690143
 median_absolute_deviation( median AD ) : 2.5
 min_max_values                    : [1, 10]
 range                             : 9
 interquartile range ( IQR )       : 5.5
 quantiles( 25 %, 50 %, 75 % )     : [2.750, 5.500, 8.250]
 quartiles( 5 %, 25 %, 50 %, 75 %, 95 % ) : [1.000, 2.750, 5.500, 8.250, 10.000]
 deciles( 10 %, 20 %, ..., 50 % ..., 90 % ) : [1.100, 2.200, 3.300, 4.400, 5.500, 6.600, 7.700, 8.800, 9.900]
 frequency_table( num_of_bins = 3 ): [
	Freq_Data{
		bin_number = 1,
		bin_range_min = 1,
		bin_range_max = 4,
		count = 3,
	},
	Freq_Data{
		bin_number = 2,
		bin_range_min = 4,
		bin_range_max = 7,
		count = 3,
	},
	Freq_Data{
		bin_number = 3,
		bin_range_min = 7,
		bin_range_max = 10,
		count = 4,
	},
]
 histogram( num_of_bins = 3 ): [3, 3, 4]
 histogram_cumulative_density( num_of_bins = 3 ): [3, 6, 10] <-> [0.300, 0.600, 1.000]

...end test_statistics.
...end statistics in Odin.

```

## License
MIT Open Source License

## Have fun!
Best regards, <br>
Joao Carvalho

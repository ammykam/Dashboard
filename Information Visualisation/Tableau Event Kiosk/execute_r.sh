#!/bin/bash

# Run the R scripts one by one
Rscript transportation_map.R &
Rscript event_map.R &
Rscript city_work.R &
Rscript random.R &

wait
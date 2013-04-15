#!/usr/bin/env bash

#./generate.rb --max_x 20 --max_y 20 --each_x_num 10 --alpha -5 --beta 0.5 --sigma 1 > data.csv
#R --vanilla < plot.R
#qlmanage -p data.jpg
#./estimate.rb --max_y 20 --sampling_num 10000 --burn_in 0 --th_in 1 --alpha_init -4.0 --beta_init 0.0 --sigma_init 2.0 --mcmc_step 0.1  < data.csv  > param.csv
head -10000 param.csv | tail -9900 | perl -ne 'print if $. % 300 == 1;' > param_small.csv
./predict.rb --param_file param_small.csv --max_x 30 --max_y 30 > predict.csv
R --vanilla < plot_predict.R
qlmanage -p predict.jpg
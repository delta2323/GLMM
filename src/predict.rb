#!/usr/bin/env ruby

$LOAD_PATH << "./"
require 'util.rb'
require 'optparse'
require 'rubygems'

def predict(x, params, prg, n)
  alpha = params[0]
  beta = params[1]
  sigma = params[2]
  rs = 10.times.map{|i|
    r = ndist(0, sigma, prg)
    z = alpha + beta * x.to_f + r
    q = logistic(z)
    y = binomial(q, n, prg)
    puts "#{x},#{y}"
  }
end

def read_params(param_file)
  params_samples = []
  File.open(param_file){|f|
#    header = f.gets
    while line = f.gets
      params_samples << line.strip.split(",").map{|x| x.to_f}
    end
  }
  params_samples
end

def main(option)
  prg = Random.new(2)
  params_samples = read_params(option[:param_file])
  data = []
  puts "x,y"
  (1..option[:max_x]).to_a.each{|x|
    params_samples.each{|params|
      predict(x, params, prg, option[:max_y])
    }
  }
end

def parse(argv)
  option = {}
  OptionParser.new{|opt|
    opt.on("-p M", "--param_file M") {|v| option[:param_file] = v || "param.csv"}
    opt.on("-X M", "--max_x M") {|v| option[:max_x] = v.to_i || 20}
    opt.on("-Y M", "--max_y M") {|v| option[:max_y] = v.to_i || 20}
    opt.parse!(argv)
  }
  option
end

if __FILE__ == $0
  option = parse(ARGV)
  warn option
  main option
end

#!/usr/bin/env ruby

$LOAD_PATH << "./"
require 'util.rb'

def generate(x, coeffs, sigma, max_y, prg)
  r = ndist(0, sigma, prg)
  z = coeffs[0] + coeffs[1] * x + r
  q = logistic(z)
  binomial(q, max_y, prg)
end

def main(option)
  prg = Random.new(0)
  coeffs = [option[:alpha], option[:beta]]
  xs = []
  (1..option[:max_x]).to_a.each{|x|
    option[:each_x_num].times{|i| xs << x}
  }
  xs = xs.sort_by{prg.rand}
  puts "x,y"
  xs.each{|x|
    puts "#{x},#{generate(x, coeffs, option[:sigma], option[:max_y], prg)}"
  }
end

require 'optparse'
def parse(argv)
  option = {}
  OptionParser.new{|opt|
    opt.on("-X M", "--max_x M") {|v| option[:max_x] = v.to_i || 20}
    opt.on("-Y M", "--max_y M") {|v| option[:max_y] = v.to_i || 20}
    opt.on("-e E", "--each_x_num E") {|v| option[:each_x_num] = v.to_i || 10}
    opt.on("-a A", "--alpha A") {|v| option[:alpha] = v.to_f || -5.0}
    opt.on("-b B", "--beta B") {|v| option[:beta] = v.to_f || 1.0}
    opt.on("-s S", "--sigma S") {|v| option[:sigma] = v.to_f || 1.0}
    opt.parse!(argv)
  }
  option
end

if __FILE__ == $0
  option = parse(ARGV)
  warn option
  main option
end

#!/usr/bin/env ruby 

$LOAD_PATH << "./"
require 'util.rb'
require 'optparse'
require 'rubygems'

def make_dist(alpha, beta, sigma, x, y, n)
  dist = lambda{|r|
    z = alpha + beta*x.to_f + r
    q = logistic(z)
    b = binomial_prob(q, n, y)
    nd = ndist_prob(0, sigma, r)
    b * nd
  }
  dist
end

def print(params, dist, from, to, step)
  p params
  x = from
  while x+step < to
    puts "#{x} => #{dist.call(x)}"
    x += step
  end
end

def calc_likelyhood(data, params, n)
  likelihood = 0.0
  step = 0.1
  point_num = 30
  data.each{|x, y|
    sigma = params[2] == 0.0 ? 0.01 : params[2]
    dist = make_dist(params[0], params[1], sigma, x, y, n)
    from = -point_num*step/2
    to = -from
#    print(params, dist, from, to, step)
    likelihood += integrate(dist, from, to, step)
  }
  likelihood
end

def check_accept(likelihood_old, likelihood_new, prg)
  (likelihood_old < likelihood_new) || (prg.rand * likelihood_old < likelihood_new)
end

def update(data, params, n, idx, mcmc_step, prg)
  likelihood_old = calc_likelyhood(data, params, n)
  dir = prg.rand(2) % 2 == 0 ? -1 : 1
  params[idx] += dir * mcmc_step
  likelihood_new = calc_likelyhood(data, params, n)
#  puts "#{likelihood_old}, #{likelihood_new}"
  unless check_accept(likelihood_old, likelihood_new, prg)
    params[idx] -= dir * mcmc_step
  end
  params
end

def estimate(data, params_init, option, prg)
  params = params_init
  iteration = option[:burn_in] + option[:sampling_num] * option[:th_in]
  iteration.times{|iter|
    warn "#{iter}/#{iteration}" if iter % 50 == 0
    params.length.times{|idx|
      params = update(data, params, option[:max_y], idx, option[:mcmc_step], prg)
    }
    next if iter < option[:burn_in]
    puts params.join(",") if iter % option[:th_in] == 0
    $stdout.flush
  }
end

def main(option)
  prg = Random.new(1)
  header = gets
  data = []
  while line = gets
    data << line.strip.split(",").map{|x| x.to_i}
  end
  params_init = [option[:alpha_init], option[:beta_init], option[:sigma_init]]
  puts "alpha,beta,sigma"
  params = estimate(data, params_init, option, prg)
end

def parse(argv)
  option = {}
  OptionParser.new{|opt|
    opt.on("-Y M", "--max_y M") {|v| option[:max_y] = v.to_i || 20}
    opt.on("-S S", "--sampling_num S") {|v| option[:sampling_num] = v.to_i || 1000}
    opt.on("-B B", "--burn_in H") {|v| option[:burn_in] = v.to_i || 100}
    opt.on("-t T", "--th_in T") {|v| option[:th_in] = v.to_i || 3}
    opt.on("-a A", "--alpha_init A") {|v| option[:alpha_init] = v.to_f || 0.0}
    opt.on("-b B", "--beta_init B") {|v| option[:beta_init] = v.to_f || 0.0}
    opt.on("-s S", "--sigma_init S") {|v| option[:sigma_init] = v.to_f || 0.0}
    opt.on("-m M", "--mcmc_step M") {|v| option[:mcmc_step] = v.to_f || 0.1}
    opt.parse!(argv)
  }
  option
end

if __FILE__ == $0
  option = parse(ARGV)
  warn option
  main option
end

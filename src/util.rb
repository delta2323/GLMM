#!/usr/bin/env ruby 

def logistic(x)
  1/(1.0+Math.exp(-x))
end

def binomial(q, n, prg)
  ret = n.times.inject(0){|cnt, i| 
    cnt + (q > prg.rand ? 1 : 0)
  }
  ret
end

def comb(x, y)
  y = [y, x-y].max
  ret = 1
  ((x-y+1)..x).to_a.each{|s|
    ret *= s
  }
  (1..y).to_a.each{|s|
    ret /= s
  }
  ret
end

def binomial_prob(q, n, x)
  ret = 1.0
  ret *= comb(n, x)
  x.times{ret *= q}
  (n-x).times{ret *= (1-q)}
  ret
end

def ndist(mu, sigma, prg)
  x = Math.sqrt(-2*Math.log(prg.rand))*Math.cos(2*Math::PI*prg.rand)
  x*sigma+mu
end

def ndist_prob(mu, sigma, x)
  Math.exp(-x*x/sigma/sigma/2.0) / sigma / Math.sqrt(2.0*Math::PI)
end

def integrate(f, from, to, step)
  ret = 0.0
  x = from
  while x+step < to
    ret += (f.call(x)+f.call(x+step))*step/2
    x += step
  end
  ret
end

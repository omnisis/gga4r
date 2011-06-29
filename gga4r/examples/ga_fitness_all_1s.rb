require File.dirname(__FILE__) + '/../lib/gga4r'
require 'logger'

class AssertionFailure < StandardError
end

def assert(bool, msg = 'assertion failure')
  if $DEBUG
    raise AssertionFailure.new(msg) unless bool
  end
end

class StringPopulation < Array
    def fitness
      self.select { |pos| pos == 1 }.size.to_f / self.size.to_f
    end

    def split(split_idx)
      [ self[0..split_idx], self[split_idx..self.length-1] ]
    end

    def recombine(c2)
      max_size = (c2.size >= self.size ) ? self.size : c2.size
      cross_point = (rand * max_size).to_i
      puts "mysize: #{self.size}, c2.size: #{c2.size}, cross_point: #{cross_point}"
      c1_a, c1_b = self.split(cross_point) 
      c2_a, c2_b = c2.split(cross_point) 
      assert c2.class == self.class, "C2 class is not of String Population!"
      assert c1_a != nil, "c1_a cannot be null"
      assert c1_b != nil, "c1_b cannot be null"
      assert c2_a != nil, "c2_a cannot be null"
      assert c2_b != nil, "c2_a cannot be null"
      StringPopulation.new( [StringPopulation.new(c1_a + c2_b), StringPopulation.new(c2_a + c1_b)] )
    end

    def mutate
      mutate_point = (rand * self.size).to_i
      self[mutate_point] = 1
    end

end

  def create_population_with_fit_all_1s(s_long = 10, num = 10)
    population = []
    num.times  do
      chromosome = StringPopulation.new(Array.new(s_long).collect { (rand > 0.2) ? 0:1 })
      population << chromosome
    end
    population
  end

initial_population = create_population_with_fit_all_1s
ga = GeneticAlgorithm.new(initial_population, {:use_threads => true })
#ga = GeneticAlgorithm.new(initial_population, {:use_threads => false, :logger => Logger.new(STDOUT) })


50.times { |i|
  ga.evolve
  #p ga.generations[-1]
  puts i
  best_fit = ga.best_fit
  puts "Num population: #{ga.generations[-1].size} - Generation: #{ga.num_generations}"
  puts "best fitness: #{best_fit[0].fitness} num fits: #{best_fit.size}"
  #p ga.generations[-1]
  puts "best fitness ..."
  p best_fit[0]
  puts "mean fitness #{ga.mean_fitness} --> #{ga.mean_fitness(ga.num_generations)}"

  #p ga.generations[-1]
sum_fitness = 0
  ga.generations[-1].each { |chromosome| 
    sum_fitness += chromosome.fitness
  }

  tmp = sum_fitness.to_f / ga.generations[-1].size.to_f
  puts "mean fitness recalc #{tmp}"

  puts "*"*30
}

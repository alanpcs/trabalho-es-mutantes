#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva
def delete_alives_from_csv(csv)
  # Get the index of the alive mutants
  alives_idx = csv.map.with_index { |e,i| i if (csv[i][1..csv[i].length-2])
    .map(&:to_i).reduce(:+)==0 }.compact
  # Remove from alive mutants from csv
  alives_idx.reverse.each{|index| csv.delete_at(index)}
  puts "--"+ alives_idx.count.to_s + " alive mutants removed before selection" 
end
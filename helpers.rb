#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva
def delete_alives_from_csv(csv)
  # Get the index of the alive mutants
  alives_idx = csv.map.with_index { |e,i| i if (csv[i][1..csv[i].length-2])
    .map(&:to_i).reduce(:+)==0 }.compact
  # Remove from alive mutants from csv
  alives_idx.reverse.each{|index| csv.delete_at(index)}
  # puts "--"+ alives_idx.count.to_s + " alive mutants removed before selection" 
end
def get_score(test_set,csv,foms_header)
  # Convert to an array the test_set string
  test_cases = test_set.split(',')
  
  # Get the indexes of the test cases in the FOM csv source
  test_cases_idxs = test_cases.map{|e| foms_header.index(e)}
  
  results = []
  # Transpose de csv matrix (to avoid cache miss) 
  csv_t = csv.transpose.map{|e|e.map(&:to_i)}
  results = Array.new(csv.length,0)
  test_cases_idxs.map { |i|
    results = [results,csv_t[i]].transpose.map {|x| x.reduce(:+)}
  }
  total = results.count
  alive = results.count(0)
  dead = total - alive
  score = dead.to_f/total
  return score
end

def summarize(hash)
  hash.keys.each do |problem|
    hash[problem].keys.each do |method|
      keys = hash[problem][method].keys
      if keys.count > 1
        hash[problem][method].keys.each do |file|
          key = file.gsub(/testcases_|\.csv/,"")
          hash[problem][key]={}
          hash[problem][key]["average_score"] = hash[problem][method][file]["average_score"]
        end
        hash[problem].delete(method)
      else
        key = hash[problem][method].keys.first
        hash[problem][method]["average_score"] = hash[problem][method][key]["average_score"]
        hash[problem][method].delete(key)
      end
    end
  end
end
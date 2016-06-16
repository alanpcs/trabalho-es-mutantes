#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'csv'
require 'json'
require_relative 'helpers'

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

if ARGV[0].nil?
  puts  "Usage: ./get_scores.rb sources/"
  exit
end

problem_root=ARGV[0]
# Get the name of the problems from the source given in the ARGV
problems = Dir[problem_root+"*"].map{|e|e.split("/").last}.sort
# Create hash to store results
result = Hash.new
# For each problem runs this strategy
problems.each do |problem|
  # Get the methods of the problems from the source given in the ARGV
  methods = Dir[problem_root+problem+"/*"].map{|e|e.split("/").last}.uniq-["Foms"]
  # Create a hash which keys are the problem's name
  result[problem]=Hash.new
  # Load Foms CSV to be compared with others strategys
  foms_path = problem_root+[problem,"Foms","result_list.csv"].join("/")
  foms_input = File.open(foms_path, "r") 
  foms_csv = CSV.new(foms_input,{:col_sep => ";"}).to_a
  foms_header = foms_csv.shift # Remove the first line and stores whitin header
  
  # Calls method that delete alive mutants from FOMs csv
  delete_alives_from_csv(foms_csv)
  
  # For each mutant generator method
  methods.each do |method|
    # Compose the path to the testcases files
    test_cases_paths = Dir[problem_root+problem+"/"+method+"/*"].grep(/.*testcases.*/)
    # Create the hash key 
    result[problem][method]=Hash.new
    
    test_cases_paths.each do |test_case| 
      file = File.open(test_case,'r')
      file_name = test_case.split('/').last
      result[problem][method][file_name]={}
      test_sets = file.readlines.map{|line| line.split.sort.join(",")}.uniq
      test_sets.each do |test_set|
        result[problem][method][file_name][test_set] = get_score(test_set,foms_csv,foms_header)
      end
      scores = result[problem][method][file_name].values
      if scores.size > 0
        average_score = scores.reduce(:+).to_f / scores.size 
        result[problem][method][file_name]["average_score"] = average_score
      end
    end
  end
end 
puts JSON.pretty_generate(result)
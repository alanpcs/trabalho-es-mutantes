#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'csv'
require 'json'
require_relative 'helpers'

if ARGV[0].nil?
  puts  "Usage: ./get_scores.rb sources/ [--summary]"
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
      test_sets = file.readlines.map{|line| line.split(" ").sort.join(",")}
      test_sets_uniqs = Hash[test_sets.uniq.map{ |ts| [ts, test_sets.count(ts)] }].sort_by(&:last)
      test_sets_uniqs.each do |test_set, amount|
        result[problem][method][file_name][test_set] = [get_score(test_set,foms_csv,foms_header), amount]
      end
      scores = result[problem][method][file_name].values
      if scores.size > 0
        scores_sum = scores.map{|score,amount| score*amount}.reduce(:+).to_f
        average_score = scores_sum / scores.map{|e| e[1]}.reduce(:+)
        result[problem][method][file_name]["average_score"] = average_score
        result[problem][method][file_name]["size"] = test_sets[0].split(',').count
      end
    end
  end
end 
if !ARGV[1].nil? and ARGV[1] == "--summary"
  summarize(result)
end
puts JSON.pretty_generate(result)
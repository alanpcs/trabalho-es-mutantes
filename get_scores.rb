#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'csv'
require_relative 'helpers'



def get_score(test_set,foms_path)
  
  input = File.open(foms_path, "r") 
  csv = CSV.new(input,{:col_sep => ";"}).to_a
  header = csv.shift # Remove the first line and stores whitin header

  # Convert to an array the test_set string
  test_cases = test_set.split(',')
  
  # Calls method that delete alive mutants from csv
  delete_alives_from_csv(csv)
  # Get the indexes of the test cases in the FOM csv source
  test_cases_idxs = test_cases.map{|e| header.index(e)}
  
  results = []
  # Transpose de csv matrix (to avoid cache miss) 
  csv_t = csv.transpose.map{|e|e.map(&:to_i)}
  results = Array.new(csv.length,0)
  test_cases_idxs.map { |i|
    results = [results,csv_t[i]].transpose.map {|x| x.reduce(:+)}
  }
  puts test_cases, test_cases_idxs
  puts results.inspect

  return 1
end

if ARGV[0].nil?
  puts  "Usage: ./get_scores.rb sources/"
  exit
end

problem_root=ARGV[0]
# Get the name of the problems from the source given in the ARGV
problems = Dir[problem_root+"*"].map{|e|e.split("/").last}.sort
hash={}
# For each problem runs this strategy
problems = problems.first(2)
problems.each do |problem|
  # Get the methods of the problems from the source given in the ARGV
  methods = Dir[problem_root+problem+"/*"].map{|e|e.split("/").last}.uniq-["Foms"]
  hash[problem]={}
  methods.each do |method|
    test_sets = Dir[problem_root+problem+"/"+method+"/*"].grep(/.*testcases.*/)
    hash[problem][method]={}
    
    test_sets.each do |test_set| 
      file = File.open(test_set,'r')
      # puts test_set
      hash[problem][method][test_set]={}
      test_cases = file.readlines.map{|line| line.split.sort.join(",")}.uniq
      test_cases.each do |testcase|
        path = problem_root+[problem,"Foms","result_list.csv"].join("/")
        hash[problem][method][test_set][testcase] = get_score(testcase,path)
      end
    end
  end
end

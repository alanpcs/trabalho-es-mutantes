#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016

if ARGV[0].nil?
  printf  "Usage: ./selective.rb sources/ [x1,x2,...,xn]\n"
  exit
end
def get_score(testset,foms_path)
  return 1
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
    testsets = Dir[problem_root+problem+"/"+method+"/*"].grep(/.*testcases.*/)
    hash[problem][method]={}
    
    testsets.each do |testset| 
      file = File.open(testset,'r')
      puts testset
      hash[problem][method][testset]={}
      testcases = file.readlines.map{|line| line.split.sort.join(",")}.uniq
      testcases.each do |testcase|
        path = problem_root+[problem,"Foms","result_list.csv"].join("/")
        hash[problem][method][testset][testcase] = get_score(testcase,path)
      end
    end
  end
end

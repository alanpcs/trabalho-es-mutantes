#!/usr/bin/env ruby
# Usage: ./selective.rb sources/program/strategy/source_matrix_name.csv
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'fileutils'
require 'csv'
X = [2,5,10] # Desired number of operators to remove
input = File.open(ARGV[0], "r") # Open, read and close the source matix csv file
csv = CSV.new(input,{:col_sep => ";"}).to_a

header = csv.shift # Remove the first line and stores whitin header
# Transpose de csv and stores the first column as an array (to avoid cache miss) 
mutants = csv.transpose.first 
# Remove '_' and numbers from mutants' names, getting the operator per line
ops = mutants.map{|m|m.gsub(/[0-9_]/, "")} 
# Counts up the mutants per operator, and sort ASC by counting stores on a hash
amounts = Hash[ops.uniq.map{ |o| [o, ops.count(o)] }].sort_by(&:last)
puts "Mutants by operator: " + amounts.to_h.to_s
# Creates a string representing the directory to store the results
result_directory = "selective_results/"+ARGV[0].split("/")[1]+"/" 
FileUtils::mkdir_p(result_directory) # Create the directory if it does not exist

# For each X calls a loop passing x as argument
X.each do |x|
  # Get the last x operators, those that generated more mutants
  chosen_ops = amounts.last(x).map(&:first)
  # Open a CSV file to write the results according to x
  File.open(result_directory+"MS_"+x.to_s+".csv", "w") do |out|
    out << header.join(";") << "\n" # Writes the header of the source matrix
    # For each line from CSV, joins the values by ';' delimiter, IF the content
    #   of the current line from CSV does not contains one of the operators
    #   chosen to be removed. At the end, remove NULL lines and writes to file
    csv.map.with_index{|l,i| out << l.join(";") << "\n" if not chosen_ops
      .include?(ops[i])}.compact
  end
end
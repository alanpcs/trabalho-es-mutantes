#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'fileutils'
require 'csv'
if ARGV[0].nil?
  printf  "Usage: ./selective.rb sources/<program>/Foms/result_list.csv [x1,x2,...,xn]\n"
  exit
end
# Desired number of operators to remove, if not given, calculates to 2,5 and 10

X = (ARGV[1] || "2,5,10").split(',').map(&:to_i)
input = File.open(ARGV[0], "r") # Open, read and close the source matrix csv
csv = CSV.new(input,{:col_sep => ";"}).to_a

header = csv.shift # Remove the first line and stores whitin header
# Get the index of the alive mutants
alives_idx = csv.map.with_index { |e,i| i if (csv[i][1..csv[i].length-2]).map(&:to_i).reduce(:+)==0 }.compact
# Remove from alive mutants from csv
alives_idx.reverse.each{|index| csv.delete_at(index)}
puts "--"+ alives_idx.count.to_s + " alive mutants removed before selection" 
# Transpose de csv and store the first column as an array (to avoid cache miss) 
mutants = csv.transpose.first

# Remove '_' and numbers from mutants' names, getting the operator per line
ops = mutants.map{|m|m.gsub(/[0-9_]/, "")} 
# Counts up the mutants per operator, and sort ASC by counting stores on a hash
amounts = Hash[ops.uniq.map{ |o| [o, ops.count(o)] }].sort_by(&:last)
puts "Killable mutants by operator: " + amounts.to_h.to_s
# Creates a string representing the directory to store the results
result_directory = "sources/"+ARGV[0].split("/")[1]+"/MS/" 
FileUtils::mkdir_p(result_directory) # Create the directory if it does not exist
FileUtils::mkdir_p(result_directory+"removed/") # Create the directory if it does not exist

# For each X calls a loop passing x as argument
X.each do |x|
  # Get the last x operators, those that generated more mutants
  chosen_ops = amounts.last(x).map(&:first)
  removed = ""
  # Open a CSV file to write the results according to x
  File.open(result_directory+"MS_"+x.to_s+".csv", "w") do |out|
    out << header.join(";") << "\n" # Writes the header of the source matrix
    # For each line from CSV, joins the values by ';' delimiter, IF the content
    #   of the current line from CSV does not contains one of the operators 
    #   chosen to be removed nor is alive. 
    #   At the end, remove NULL lines and writes to file
    csv.each.with_index{|l,i| 
      # If the content of the current line from CSV does not contains one of 
      #   the operators chosen to be removed nor is alive, append it to result
      if not chosen_ops.include?(ops[i])
        out << l.join(";") << "\n" 
      else
        # Else append the joined line to the list of removed mutants
        removed << l.join(";") << "\n" 
      end
    }.compact
  end
  File.open(result_directory+"removed/MS_"+x.to_s+"_removed.csv", "w") do |rm|
    rm << header.join(";") << "\n" # Writes the header of the source matrix
    rm << removed
  end
end
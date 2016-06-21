#!/usr/bin/env ruby
# Author: Alan Peterson Carvalho Silva                                29/05/2016
require 'fileutils'
require 'csv'
require_relative 'helpers'

if ARGV[0].nil?
  printf  "Usage: ./selective.rb sources/ [x1,x2,...,xn]\n"
  exit
end

# Desired number of operators to remove, if not given, calculates to 2,5 and 10
X = (ARGV[1] || "2,5,10").split(',').map(&:to_i)
# Get the path of the problems from the source given in the ARGV
problems_paths = Dir[ARGV[0]+"*"]
# For each problem runs this stratgy
problems_paths.each do |problem_path|
  puts "===="+problem_path.split("/").last
  # Open, read and close the source matrix csv
  input = File.open(problem_path+"/Foms/result_list.csv", "r") 
  csv = CSV.new(input,{:col_sep => ";"}).to_a
  header = csv.shift # Remove the first line and stores whitin header

  # Calls method that delete alive mutants from csv
  delete_alives_from_csv(csv)
  # Transpose de csv and store the first column as an array (to avoid cache miss) 
  mutants = csv.transpose.first

  # Remove '_' and numbers from mutants' names, getting the operator per line
  ops = mutants.map{|m|m.gsub(/[0-9_]/, "")} 
  # Counts up the mutants per operator, and sort ASC by counting stores on a hash
  amounts = Hash[ops.uniq.map{ |o| [o, ops.count(o)] }].sort_by(&:last)
  puts "Killable mutants by operator: " + amounts.to_h.to_s
  # Creates a string representing the directory to store the results
  FileUtils::mkdir_p(problem_path+"/MS/") # Create the directory if it does not exist
  # For each X calls a loop passing x as argument
  X.each do |x|
    # Get the last x operators, those that generated more mutants
    chosen_ops = amounts.last(x).map(&:first)
    removed = ""
    # Open a CSV file to write the results according to x
    File.open(problem_path+"/MS/MS_"+x.to_s+".csv", "w") do |out|
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
    File.open(problem_path+"/MS/MS_"+x.to_s+"_removed.csv", "w") do |rm|
      rm << header.join(";") << "\n" # Writes the header of the source matrix
      rm << removed
    end
  end
  puts
end
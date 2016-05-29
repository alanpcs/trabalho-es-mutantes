#!/usr/bin/env ruby
require 'csv'
input = File.open(File.dirname(__FILE__) + "/"+ARGV[0], "r")
csv = CSV.new(input,{:col_sep => ";"}).to_a
header = csv.shift
puts header
mutants = csv.transpose.first
puts mutants




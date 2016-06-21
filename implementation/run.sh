#!/bin/bash
find ./ -name 'testcases_*' -delete
find ./ -name 'MS*' -delete
if [[ $1 != 'clean' ]]
    then
    ./selective.rb sources/
    ./run_test_case_selection 
    ./get_scores.rb sources/ -- summary > results.hash
fi
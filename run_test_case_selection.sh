#!/bin/bash
export TestRoot=`pwd`/TestCaseSetSelection/
echo $TestRoot
export ProblemsRoot=`pwd`/sources/
for problem in `ls $ProblemsRoot`
do
    echo $problem
    for method in `ls $ProblemsRoot/$problem`
    do
        echo ${ProblemsRoot}${problem}result_list.csv
        java -jar ${TestRoot}compiled/TestCaseSetSelection.jar \
        ${ProblemsRoot}${problem}${method}result_list.csv ';' \
        true 10 | grep "Test Cases:" | cut -d':' -f2
    done
done
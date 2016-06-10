#!/bin/bash
export TestRoot=`pwd`/TestCaseSetSelection/
export ProblemsRoot=`pwd`/sources/
for problem in `ls $ProblemsRoot`
do
  for method in `ls $ProblemsRoot/$problem`
  do
    for result in `ls $ProblemsRoot/$problem/$method`
    do
      echo ${ProblemsRoot}${problem}/${method}/${result}
      java -jar ${TestRoot}compiled/TestCaseSetSelection.jar \
      ${ProblemsRoot}${problem}/${method}/${result} ';' \
      true 10 | grep "Test Cases:" | cut -d':' -f2 > testcases.txt
    done
  done
done
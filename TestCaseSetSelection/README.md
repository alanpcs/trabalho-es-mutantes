# TestCaseSetSelection

## Usage:

Invoke br.ufpr.inf.cbiogres.Execute.

First parameter is the path to the problem file (e.g. sampleProblem.txt).

Second parameter is the data separator.

Third parameter is a boolean (true/false) to skip or not header items: Mutant, Total, State.

Fourth parameter is the number of runs to average the results. (optional)

## Examples:

java -cp TestCaseSetSelection.jar br.ufpr.inf.cbiogres.Execute sampleProblem.txt ';' false 10

java -cp TestCaseSetSelection.jar br.ufpr.inf.cbiogres.Execute jacksonMatrix.txt ';' true 10

### Or:

java -jar TestCaseSetSelection.jar sampleProblem.txt ';' false 10

java -jar TestCaseSetSelection.jar jacksonMatrix.txt ';' true 10

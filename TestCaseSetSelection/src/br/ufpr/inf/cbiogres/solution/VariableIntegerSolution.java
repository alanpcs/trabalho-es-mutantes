package br.ufpr.inf.cbiogres.solution;

import br.ufpr.inf.cbiogres.problem.AbstractVariableIntegerProblem;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class VariableIntegerSolution extends AbstractVariableSolution<Integer, AbstractVariableIntegerProblem> {

    public VariableIntegerSolution(AbstractVariableIntegerProblem problem) {
        super(problem);

        int numberOfVariables = randomGenerator.nextInt(1, problem.getNumberOfVariables());

        List<Integer> possibleValues = new ArrayList<>();
        for (int i = problem.getLowerLimit(0); i <= problem.getUpperLimit(0); i++) {
            possibleValues.add(i);
        }

        for (int i = 0; i < numberOfVariables; i++) {
            int indexToGet = randomGenerator.nextInt(0, possibleValues.size() - 1);
            Integer value = possibleValues.get(indexToGet);
            addVariable(value);
            possibleValues.remove(indexToGet);
        }

        initializeObjectiveValues();
    }

    public VariableIntegerSolution(VariableIntegerSolution solution) {
        super(solution.problem);

        for (int i = 0; i < solution.getNumberOfVariables(); i++) {
            addVariable(solution.getVariableValue(i));
        }

        for (int i = 0; i < solution.getNumberOfObjectives(); i++) {
            setObjective(i, solution.getObjective(i));
        }

        overallConstraintViolationDegree = solution.overallConstraintViolationDegree;
        numberOfViolatedConstraints = solution.numberOfViolatedConstraints;

        attributes = new HashMap<>(solution.attributes);
    }

    public int getLowerLimit() {
        return problem.getLowerLimit(0);
    }

    public int getUpperLimit() {
        return problem.getUpperLimit(0);
    }

    @Override
    public VariableIntegerSolution copy() {
        return new VariableIntegerSolution(this);
    }

    @Override
    public String getVariableValueString(int index) {
        return getVariableValue(index).toString();
    }
}

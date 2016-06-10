package br.ufpr.inf.cbiogres.problem;

import br.ufpr.inf.cbiogres.solution.VariableIntegerSolution;
import java.util.List;
import org.uma.jmetal.problem.impl.AbstractGenericProblem;

public abstract class AbstractVariableIntegerProblem extends AbstractGenericProblem<VariableIntegerSolution> {

    private List<Integer> lowerLimit;
    private List<Integer> upperLimit;

    public Integer getUpperLimit(int index) {
        return upperLimit.get(index);
    }

    public Integer getLowerLimit(int index) {
        return lowerLimit.get(index);
    }

    protected void setLowerLimit(List<Integer> lowerLimit) {
        this.lowerLimit = lowerLimit;
    }

    protected void setUpperLimit(List<Integer> upperLimit) {
        this.upperLimit = upperLimit;
    }

    @Override
    public VariableIntegerSolution createSolution() {
        return new VariableIntegerSolution(this);
    }
}

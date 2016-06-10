package br.ufpr.inf.cbiogres.solution;

import org.uma.jmetal.problem.Problem;
import org.uma.jmetal.solution.Solution;

import java.util.*;
import org.uma.jmetal.util.pseudorandom.JMetalRandom;

public abstract class AbstractVariableSolution<T, P extends Problem<?>> implements Solution<T> {

    private double[] objectives;
    private List<T> variables;
    protected P problem;
    protected double overallConstraintViolationDegree;
    protected int numberOfViolatedConstraints;
    protected Map<Object, Object> attributes;
    protected final JMetalRandom randomGenerator;

    protected AbstractVariableSolution(P problem) {
        this.problem = problem;
        attributes = new HashMap<>();
        randomGenerator = JMetalRandom.getInstance();
        
        overallConstraintViolationDegree = 0.0;
        numberOfViolatedConstraints = 0;

        objectives = new double[problem.getNumberOfObjectives()];
        variables = new ArrayList<>();
    }

    @Override
    public void setAttribute(Object id, Object value) {
        attributes.put(id, value);
    }

    @Override
    public Object getAttribute(Object id) {
        return attributes.get(id);
    }

    @Override
    public void setObjective(int index, double value) {
        objectives[index] = value;
    }

    @Override
    public double getObjective(int index) {
        return objectives[index];
    }

    @Override
    public T getVariableValue(int index) {
        return variables.get(index);
    }

    @Override
    public void setVariableValue(int index, T value) {
        variables.set(index, value);
    }

    @Override
    public int getNumberOfVariables() {
        return variables.size();
    }

    public boolean addVariable(T e) {
        return variables.add(e);
    }

    public boolean removeVariable(T o) {
        return variables.remove(o);
    }

    public boolean addAllVariables(Collection<? extends T> c) {
        return variables.addAll(c);
    }

    public boolean removeAllVariables(Collection<?> c) {
        return variables.removeAll(c);
    }

    public void clearVariables() {
        variables.clear();
    }

    public List<T> getVariables() {
        return variables;
    }

    public T removeVariable(int index) {
        return variables.remove(index);
    }

    @Override
    public int getNumberOfObjectives() {
        return objectives.length;
    }

    @Override
    public double getOverallConstraintViolationDegree() {
        return overallConstraintViolationDegree;
    }

    @Override
    public void setOverallConstraintViolationDegree(double violationDegree) {
        overallConstraintViolationDegree = violationDegree;
    }

    @Override
    public int getNumberOfViolatedConstraints() {
        return numberOfViolatedConstraints;
    }

    @Override
    public void setNumberOfViolatedConstraints(int numberOfViolatedConstraints) {
        this.numberOfViolatedConstraints = numberOfViolatedConstraints;
    }

    protected void initializeObjectiveValues() {
        for (int i = 0; i < problem.getNumberOfObjectives(); i++) {
            objectives[i] = 0.0;
        }
    }

    @Override
    public String toString() {
        String result = "Variables: ";
        for (T var : variables) {
            result += "" + var + " ";
        }
        result += "Objectives: ";
        for (Double obj : objectives) {
            result += "" + obj + " ";
        }
        result += "\t";
        result += "AlgorithmAttributes: " + attributes + "\n";

        return result;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        AbstractVariableSolution<?, ?> that = (AbstractVariableSolution<?, ?>) o;

        if (!attributes.equals(that.attributes)) {
            return false;
        }
        if (!Arrays.equals(objectives, that.objectives)) {
            return false;
        }
        return variables.equals(that.variables);
    }

    @Override
    public int hashCode() {
        int result = Arrays.hashCode(objectives);
        result = 31 * result + variables.hashCode();
        result = 31 * result + attributes.hashCode();
        return result;
    }

    public void prune(int pruneIndex) {
        if (pruneIndex < variables.size()) {
            variables = variables.subList(0, pruneIndex);
        }
    }
}

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
package br.ufpr.inf.cbiogres.operator.mutation;

import br.ufpr.inf.cbiogres.solution.VariableIntegerSolution;
import java.util.ArrayList;
import java.util.List;
import org.uma.jmetal.operator.MutationOperator;
import org.uma.jmetal.util.JMetalException;
import org.uma.jmetal.util.pseudorandom.JMetalRandom;

public class PermutationIntegerMutation implements MutationOperator<VariableIntegerSolution> {

    private double mutationProbability;
    private JMetalRandom randomGenerator;

    public PermutationIntegerMutation(double mutationProbability) {
        if (mutationProbability < 0) {
            throw new JMetalException("Mutation probability is negative: " + mutationProbability);
        }
        this.mutationProbability = mutationProbability;
        randomGenerator = JMetalRandom.getInstance();
    }

    public double getMutationProbability() {
        return mutationProbability;
    }

    @Override
    public VariableIntegerSolution execute(VariableIntegerSolution solution) {
        if (null == solution) {
            throw new JMetalException("Null parameter");
        }

        doMutation(mutationProbability, solution);
        return solution;
    }

    public void doMutation(double probability, VariableIntegerSolution solution) {
        final Integer lowerLimit = solution.getLowerLimit();
        final Integer upperLimit = solution.getUpperLimit();
        for (int i = 0; i < solution.getNumberOfVariables(); i++) {
            if (!addVariableMutation(probability, solution, lowerLimit, upperLimit)) {
                if (!changeVariableMutation(probability, solution, lowerLimit, upperLimit)) {
                    removeVariableMutation(probability, solution);
                }
            }
        }
    }

    private boolean addVariableMutation(double probability, VariableIntegerSolution solution, Integer lowerLimit, Integer upperLimit) {
        if (randomGenerator.nextDouble() < probability) {
            final List<Integer> variables = solution.getVariables();
            if (variables.size() < upperLimit) {
                List<Integer> possibleValues = new ArrayList<>();
                for (int i = lowerLimit; i < upperLimit; i++) {
                    possibleValues.add(i);
                }
                possibleValues.removeAll(variables);
                variables.add(possibleValues.get(randomGenerator.nextInt(0, possibleValues.size() - 1)));
                return true;
            }
        }
        return false;
    }

    private boolean changeVariableMutation(double probability, VariableIntegerSolution solution, Integer lowerLimit, Integer upperLimit) {
        if (randomGenerator.nextDouble() < probability) {
            final List<Integer> variables = solution.getVariables();
            if (variables.size() < upperLimit) {
                List<Integer> possibleValues = new ArrayList<>();
                for (int i = lowerLimit; i < upperLimit; i++) {
                    possibleValues.add(i);
                }
                possibleValues.removeAll(variables);
                variables.set(randomGenerator.nextInt(0, variables.size() - 1), possibleValues.get(randomGenerator.nextInt(0, possibleValues.size() - 1)));
                return true;
            }
        }
        return false;
    }

    private boolean removeVariableMutation(double probability, VariableIntegerSolution solution) {
        if (randomGenerator.nextDouble() < probability) {
            final List<Integer> variables = solution.getVariables();
            if (variables.size() > 1) {
                variables.remove(randomGenerator.nextInt(0, variables.size() - 1));
                return true;
            }
        }
        return false;
    }
}

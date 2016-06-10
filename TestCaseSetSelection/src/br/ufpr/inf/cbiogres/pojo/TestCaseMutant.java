package br.ufpr.inf.cbiogres.pojo;

import java.util.Objects;

public class TestCaseMutant {

    private TestCase testCase;
    private Mutant mutant;
    private boolean killed;

    public TestCaseMutant(TestCase testCase, Mutant mutant, boolean killed) {
        this.testCase = testCase;
        this.mutant = mutant;
        this.killed = killed;
    }

    public TestCase getTestCase() {
        return testCase;
    }

    public void setTestCase(TestCase testCase) {
        this.testCase = testCase;
    }

    public Mutant getMutant() {
        return mutant;
    }

    public void setMutant(Mutant mutant) {
        this.mutant = mutant;
    }

    public boolean isKilled() {
        return killed;
    }

    public void setKilled(boolean killed) {
        this.killed = killed;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 17 * hash + Objects.hashCode(this.mutant);
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final TestCaseMutant other = (TestCaseMutant) obj;
        if (!Objects.equals(this.mutant, other.mutant)) {
            return false;
        }
        return true;
    }
}

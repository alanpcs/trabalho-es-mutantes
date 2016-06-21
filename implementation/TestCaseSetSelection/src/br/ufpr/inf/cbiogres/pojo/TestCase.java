package br.ufpr.inf.cbiogres.pojo;

import java.util.ArrayList;
import java.util.List;

public class TestCase {

    private long id = Long.MAX_VALUE;
    private String description;
    private List<TestCaseMutant> testCaseMutantList = new ArrayList<>();

    public TestCase(TestCase testCase) {
        this.id = testCase.getId();
        testCaseMutantList.addAll(testCase.getTestCaseMutantList());
    }

    public TestCase() {
    }

    public TestCase(long id) {
        this.id = id;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<TestCaseMutant> getTestCaseMutantList() {
        return testCaseMutantList;
    }

    public void setTestCaseMutantList(List<TestCaseMutant> testCaseMutantList) {
        this.testCaseMutantList = testCaseMutantList;
    }

    public int getKillCount() {
        int count = 0;
        for (TestCaseMutant testCaseMutant : testCaseMutantList) {
            if (testCaseMutant.isKilled()) {
                count++;
            }
        }
        return count;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 83 * hash + (int) (this.id ^ (this.id >>> 32));
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
        final TestCase other = (TestCase) obj;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    public TestCase getClone() {
        TestCase clone = new TestCase();
        clone.setId(this.id);
        clone.setTestCaseMutantList(this.getTestCaseMutantList());
        return clone;
    }
}

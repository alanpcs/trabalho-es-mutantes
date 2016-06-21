package br.ufpr.inf.cbiogres.pojo;

import java.util.ArrayList;
import java.util.List;

public class Mutant {

    private long id;
    private String description;
    private List<TestCaseMutant> testCaseMutantList = new ArrayList<>();

    public Mutant(long id) {
        this.id = id;
    }

    public Mutant() {
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

    public int getKilledByCount() {
        int count = 0;
        for (TestCaseMutant testCaseMutant : testCaseMutantList) {
            if (testCaseMutant.isKilled()) {
                count++;
            }
        }
        return count;
    }
    
    public boolean isDead(){
        return testCaseMutantList.stream().anyMatch(item -> item.isKilled());
    }
    
    public boolean isAlive(){
        return !isDead();
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 59 * hash + (int) (this.id ^ (this.id >>> 32));
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
        final Mutant other = (Mutant) obj;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }
}

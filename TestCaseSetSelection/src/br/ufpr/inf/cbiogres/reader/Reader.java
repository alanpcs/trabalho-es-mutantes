package br.ufpr.inf.cbiogres.reader;

import br.ufpr.inf.cbiogres.exception.TestCaseSetSelectionException;
import br.ufpr.inf.cbiogres.pojo.Mutant;
import br.ufpr.inf.cbiogres.pojo.TestCase;
import br.ufpr.inf.cbiogres.pojo.TestCaseMutant;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Scanner;

public class Reader {

    private String separator;
    private InputStream file;
    private Boolean complexHeader = false;
    private List<Mutant> mutants;
    private List<TestCase> testCases;

    public Reader(String filePath, String separator, Boolean complexHeader) throws FileNotFoundException {
        this(new FileInputStream(filePath), separator, complexHeader);
    }

    public Reader(InputStream file, String separator, Boolean complexHeader) {
        this.file = file;
        this.separator = separator;
        this.complexHeader = complexHeader;
    }

    public InputStream getFile() {
        return file;
    }

    public void setFile(InputStream file) {
        this.file = file;
    }

    public List<Mutant> getMutants() {
        return mutants;
    }

    public List<TestCase> getTestCases() {
        return testCases;
    }

    private List<TestCase> buildTestCaseList(String fileLine) {
        List<TestCase> list = new ArrayList<>();

        List<String> asList = Arrays.asList(fileLine.split(separator));
        int idCount = 0;
        for (String string : asList) {
            TestCase testCase = new TestCase(idCount++);
            testCase.setDescription(string);
            testCase.setTestCaseMutantList(new ArrayList<>());
            list.add(testCase);
        }
        return list;
    }

    public void read() throws TestCaseSetSelectionException {
        try (Scanner scanner = new Scanner(file)) {

            //Test Case IDs
            String line = scanner.nextLine();

            if (complexHeader) {
                line = line.replaceAll("Mutant;", "")
                        .replaceAll(";Total", "")
                        .replaceAll(";State", "");
            }
            //Build Test Case objects
            testCases = buildTestCaseList(line);

            mutants = new ArrayList<>();

            //While there is something to read
            int mutantId = 0;
            while (scanner.hasNextLine()) {
                line = scanner.nextLine();
                //Tokenize
                List<String> asList = Arrays.asList(line.split(separator));
                
                if(complexHeader){
                    asList = asList.subList(0, asList.size() - 2);
                }
                
                Iterator<String> tokenIterator = asList.iterator();
                //First value is the Mutant ID

                Mutant mutant = new Mutant(mutantId++);
                mutant.setDescription(tokenIterator.next());
                mutant.setTestCaseMutantList(new ArrayList<>());
                mutants.add(mutant);
                Iterator<TestCase> testCaseIterator = testCases.iterator();
                while (testCaseIterator.hasNext()) {
                    if (!tokenIterator.hasNext()) {
                        throw new TestCaseSetSelectionException("The number of test cases does not match the number of data in the matrix."
                                + "\nMutant '" + mutant.getDescription() + "' has less values than there are test cases.");
                    }
                    String token = tokenIterator.next();
                    Boolean value;
                    switch (token) {
                        case "TRUE":
                        case "True":
                        case "true":
                        case "DEAD":
                        case "Dead":
                        case "dead":
                        case "1":
                            value = true;
                            break;
                        case "FALSE":
                        case "False":
                        case "false":
                        case "ALIVE":
                        case "Alive":
                        case "alive":
                        case "0":
                            value = false;
                            break;
                        default:
                            throw new TestCaseSetSelectionException("Value not recognized in the problem instance. Please, use FALSE|TRUE, ALIVE|DEAD, 0|1.");
                    }
                    TestCase testCase = testCaseIterator.next();
                    TestCaseMutant testCaseMutant = new TestCaseMutant(testCase, mutant, value);
                    testCase.getTestCaseMutantList().add(testCaseMutant);
                    mutant.getTestCaseMutantList().add(testCaseMutant);
                }

                if (mutant.isAlive()) {
                    mutants.remove(mutant);
                    testCaseIterator = testCases.iterator();
                    while (testCaseIterator.hasNext()) {
                        TestCase testCase = testCaseIterator.next();
                        testCase.getTestCaseMutantList().remove(testCase.getTestCaseMutantList().size() - 1);
                    }
                }
            }
        }
    }
}

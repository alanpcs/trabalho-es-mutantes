package br.ufpr.inf.cbiogres.exception;

public class TestCaseSetSelectionException extends Exception {

    /**
     * Creates a new instance of <code>TestCaseSetSelectionException</code> without detail message.
     */
    public TestCaseSetSelectionException() {
    }


    /**
     * Constructs an instance of <code>TestCaseSetSelectionException</code> with the specified detail message.
     * @param msg the detail message.
     */
    public TestCaseSetSelectionException(String msg) {
        super(msg);
    }
}

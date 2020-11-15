package com.testApi.p1Api.Pojos;

public class Statement {
    private int statementId;
    private int accountId;
    private String startDate;
    private String endDate;
    private String initialBalance;
    private String endBalance;

    public Statement(int statementId, int accountId, String startDate, String endDate, String initialBalance, String endBalance) {
        this.statementId = statementId;
        this.accountId = accountId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.initialBalance = initialBalance;
        this.endBalance = endBalance;
    }

    public int getStatementId() {
        return statementId;
    }

    public void setStatementId(int statementId) {
        this.statementId = statementId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public String getInitialBalance() {
        return initialBalance;
    }

    public void setInitialBalance(String initialBalance) {
        this.initialBalance = initialBalance;
    }

    public String getEndBalance() {
        return endBalance;
    }

    public void setEndBalance(String endBalance) {
        this.endBalance = endBalance;
    }
}

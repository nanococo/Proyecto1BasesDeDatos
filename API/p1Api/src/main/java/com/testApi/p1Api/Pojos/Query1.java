package com.testApi.p1Api.Pojos;

public class Query1 {
    private int id;
    private int objectiveAccountId;
    private String description;
    private int numberOfActualDeposits;
    private int numberOfExpectedDeposits;
    private String trueBalance;
    private String expectedBalance;

    public Query1(int id, int objectiveAccountId, String description, int numberOfActualDeposits, int numberOfExpectedDeposits, String trueBalance, String expectedBalance) {
        this.id = id;
        this.objectiveAccountId = objectiveAccountId;
        this.description = description;
        this.numberOfActualDeposits = numberOfActualDeposits;
        this.numberOfExpectedDeposits = numberOfExpectedDeposits;
        this.trueBalance = trueBalance;
        this.expectedBalance = expectedBalance;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getObjectiveAccountId() {
        return objectiveAccountId;
    }

    public void setObjectiveAccountId(int objectiveAccountId) {
        this.objectiveAccountId = objectiveAccountId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getNumberOfActualDeposits() {
        return numberOfActualDeposits;
    }

    public void setNumberOfActualDeposits(int numberOfActualDeposits) {
        this.numberOfActualDeposits = numberOfActualDeposits;
    }

    public int getNumberOfExpectedDeposits() {
        return numberOfExpectedDeposits;
    }

    public void setNumberOfExpectedDeposits(int numberOfExpectedDeposits) {
        this.numberOfExpectedDeposits = numberOfExpectedDeposits;
    }

    public String getTrueBalance() {
        return trueBalance;
    }

    public void setTrueBalance(String trueBalance) {
        this.trueBalance = trueBalance;
    }

    public String getExpectedBalance() {
        return expectedBalance;
    }

    public void setExpectedBalance(String expectedBalance) {
        this.expectedBalance = expectedBalance;
    }
}

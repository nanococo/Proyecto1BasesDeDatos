package com.testApi.p1Api.Pojos;

public class Movement {
    private int id;
    private int accountId;
    private int movementTypeId;
    private String date;
    private String amount;
    private String newBalance;
    private String description;

    public Movement(int id, int accountId, int movementTypeId, String date, String amount, String newBalance, String description) {
        this.id = id;
        this.accountId = accountId;
        this.movementTypeId = movementTypeId;
        this.date = date;
        this.amount = amount;
        this.newBalance = newBalance;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getMovementTypeId() {
        return movementTypeId;
    }

    public void setMovementTypeId(int movementTypeId) {
        this.movementTypeId = movementTypeId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getNewBalance() {
        return newBalance;
    }

    public void setNewBalance(String newBalance) {
        this.newBalance = newBalance;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}

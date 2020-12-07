package com.testApi.p1Api.Pojos;

public class ObjectiveAccount {
    private int id;
    private int accountId;
    private String startDate;
    private String endDate;
    private String saveDate;
    private String amount;
    private String description;
    private boolean isActive;

    public ObjectiveAccount(int id, int accountId, String startDate, String endDate, String saveDate, String amount, String description, boolean isActive) {
        this.id = id;
        this.accountId = accountId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.saveDate = saveDate;
        this.amount = amount;
        this.description = description;
        this.isActive = isActive;
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

    public String getSaveDate() {
        return saveDate;
    }

    public void setSaveDate(String saveDate) {
        this.saveDate = saveDate;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}

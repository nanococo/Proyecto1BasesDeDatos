package com.example.pojos;

public class BankAccount implements Cloneable {

    private String ownerName;
    private int accountID;
    private float amount;

    public BankAccount(String ownerName, int accountID, float amount){
        this.ownerName = ownerName;
        this.accountID = accountID;
        this.amount = amount;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }
}

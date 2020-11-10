package com.example.pojos;

public class Account {
    private int id;
    private int accountNumber;
    private int personId;
    private int accountType;
    private String date;
    private String balance;
    private boolean active;

    public Account(int id, int accountNumber, int personId, int accountType, String date, String balance, boolean active) {
        this.id = id;
        this.accountNumber = accountNumber;
        this.personId = personId;
        this.accountType = accountType;
        this.date = date;
        this.balance = balance;
        this.active = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(int accountNumber) {
        this.accountNumber = accountNumber;
    }

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int personId) {
        this.personId = personId;
    }

    public int getAccountType() {
        return accountType;
    }

    public void setAccountType(int accountType) {
        this.accountType = accountType;
    }

    public String getBalance() {
        return balance;
    }

    public void setBalance(String balance) {
        this.balance = balance;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }
}

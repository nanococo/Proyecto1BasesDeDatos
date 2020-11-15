package com.example.pojos;

import java.util.ArrayList;

public class AccountsHolder {

    private ArrayList<Account> accounts;

    public AccountsHolder() {}

    public AccountsHolder(ArrayList<Account> accounts) {
        this.accounts = accounts;
    }

    public ArrayList<Account> getAccounts() {
        return accounts;
    }

    public void setAccounts(ArrayList<Account> accounts) {
        this.accounts = accounts;
    }
}

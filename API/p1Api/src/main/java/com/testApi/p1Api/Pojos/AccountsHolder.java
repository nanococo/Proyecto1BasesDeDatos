package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class AccountsHolder {

    private ArrayList<Account> accounts;

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

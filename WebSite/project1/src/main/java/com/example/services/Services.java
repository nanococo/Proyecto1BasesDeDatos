package com.example.services;

import com.example.pojos.Account;
import com.example.pojos.AccountsHolder;
import com.example.services.singletons.Common;
import com.google.gson.Gson;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Service
public class Services {
    public ArrayList<Account> getAccounts(){
        ArrayList<Account> accounts = null;
        try {
            AccountsHolder accountsHolder;
            Gson gson = new Gson();
            String jsonString = Common.readJsonFromUrl("http://localhost:8081/getAccounts?username="+Common.username);
            accountsHolder = gson.fromJson(jsonString, AccountsHolder.class);

            accounts = accountsHolder.getAccounts();
        } catch (Exception e){
            e.printStackTrace();
        }
        return accounts;
    }
}

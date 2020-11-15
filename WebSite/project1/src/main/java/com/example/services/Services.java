package com.example.services;

import com.example.pojos.*;
import com.example.services.singletons.Common;
import com.google.gson.Gson;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;
import com.vaadin.flow.component.UI;
import net.minidev.json.JSONArray;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

@Service
public class Services {
    public ArrayList<Account> getAccounts(){
        ArrayList<Account> accounts = null;
        try {
            AccountsHolder accountsHolder;
            Gson gson = new Gson();
            String jsonString;

            if(Common.isAdmin){
                jsonString = Common.readJsonFromUrl("http://localhost:8081/getAllAccounts");
            } else {
                jsonString = Common.readJsonFromUrl("http://localhost:8081/getAccounts?username="+Common.username);
            }

            accountsHolder = gson.fromJson(jsonString, AccountsHolder.class);
            accounts = accountsHolder.getAccounts();
        } catch (Exception e){
            e.printStackTrace();
        }
        return accounts;
    }

    public ArrayList<Beneficiary> getBeneficiaries() {
        ArrayList<Beneficiary> beneficiaries = null;
        try {
            BeneficiaryHolder beneficiaryHolder;
            Gson gson = new Gson();
            String jsonString = Common.readJsonFromUrl("http://localhost:8081/getBeneficiaries?accountId="+Common.accountId);
            beneficiaryHolder = gson.fromJson(jsonString, BeneficiaryHolder.class);

            beneficiaries = beneficiaryHolder.getBeneficiaries();
        } catch (Exception e){
            e.printStackTrace();
        }
        return beneficiaries;
    }

    public ArrayList<Statement> getStatements() {
        ArrayList<Statement> statements = null;
        try {
            StatementHolder statementHolder;
            Gson gson = new Gson();

            System.out.println(Common.accountId);

            String jsonString = Common.readJsonFromUrl("http://localhost:8081/getStatement?accountId="+Common.accountId);
            statementHolder = gson.fromJson(jsonString, StatementHolder.class);

            statements = statementHolder.getStatements();
        } catch (Exception e){
            e.printStackTrace();
        }
        return statements;
    }


    public void navigateToBeneficiaries() {
        UI.getCurrent().navigate("beneficiary");
    }

    public int addBeneficiary(String id, String percentage, String kinshipName) {
        try {
            return Common.makeApiCall(new URL("http://localhost:8081/insertBeneficiary?id="+id+"&percentage="+percentage+"&accountId="+ Common.accountId +"&kinship="+kinshipName), "GET");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        return 400;
    }

    public ArrayList<String> getKinship() {
        ArrayList<String> kinship = new ArrayList<>();
        ReadContext readContext = JsonPath.parse(Common.readJsonFromUrl("http://localhost:8081/getKinship"));
        int indexesToCheck =  ((JSONArray) readContext.read("$.kinship")).size();

        for (int i = 0; i < indexesToCheck; i++) {
            kinship.add(readContext.read("$.kinship["+i+"].kinshipName"));
        }
        return kinship;
    }

    public ArrayList<String> getIdTypes(){
        ArrayList<String> idTypes = new ArrayList<>();
        ReadContext readContext = JsonPath.parse(Common.readJsonFromUrl("http://localhost:8081/getIdType"));
        int indexesToCheck =  ((JSONArray) readContext.read("$.idTypes")).size();

        for (int i = 0; i < indexesToCheck; i++) {
            idTypes.add(readContext.read("$.idTypes["+i+"].idTypeName"));
        }
        return idTypes;
    }

    public void deleteBeneficiary(ArrayList<Beneficiary> selectedBeneficiaries) {
        for (Beneficiary selectedBeneficiary : selectedBeneficiaries) {
            try {
                Thread.sleep(500);
                Common.makeApiCall(new URL("http://localhost:8081/deleteBeneficiary?id="+Common.accountId+"&beneficiaryId="+selectedBeneficiary.getBeneficiaryId()), "GET");
            } catch (MalformedURLException | InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public int updateBeneficiary(String personId, String name, String kinship, String percentage, String date, String newId, String email, String phone1, String phone2) {
        try {
            Thread.sleep(500);
            return Common.makeApiCall(new URL(("http://localhost:8081/updateBeneficiary?personId="+URLEncoder.encode(personId+"&accountId="+Common.accountId+"&name="+name+"&kinship="+kinship+"&percentage="+percentage+"&date="+date+"&newId="+newId+"&email="+email+"&phone1="+phone1+"&phone2="+phone2, StandardCharsets.UTF_8.toString())).replaceAll("%26", "&").replaceAll("%3D", "=")), "GET");
        } catch (MalformedURLException | InterruptedException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return 400;
    }

    public void navigateToStatements() {
        UI.getCurrent().navigate("statement");
    }

    public int addPerson(String id, String idTypeSelected, String date, String name, String email, String phone1, String phone2) {
        try {
            Thread.sleep(500);
            return Common.makeApiCall(new URL(("http://localhost:8081/insertPerson?id="+URLEncoder.encode(id+"&idTypeSelected="+idTypeSelected+"&date="+date+"&name="+name+"&email="+email+"&phone1="+phone1+"&phone2="+phone2, StandardCharsets.UTF_8.toString())).replaceAll("%26", "&").replaceAll("%3D", "=")), "GET");
        } catch (MalformedURLException | InterruptedException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return 400;
    }
}

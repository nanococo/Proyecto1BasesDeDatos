package com.testApi.p1Api.Pojos;

public class Query3 {
    private int beneficiaryId;
    private String amountToGet;
    private int accountOfHighestBeneficiary;
    private int numberOfAccounts;

    public Query3(int beneficiaryId, String amountToGet, int accountOfHighestBeneficiary, int numberOfAccounts) {
        this.beneficiaryId = beneficiaryId;
        this.amountToGet = amountToGet;
        this.accountOfHighestBeneficiary = accountOfHighestBeneficiary;
        this.numberOfAccounts = numberOfAccounts;
    }

    public int getBeneficiaryId() {
        return beneficiaryId;
    }

    public void setBeneficiaryId(int beneficiaryId) {
        this.beneficiaryId = beneficiaryId;
    }

    public String getAmountToGet() {
        return amountToGet;
    }

    public void setAmountToGet(String amountToGet) {
        this.amountToGet = amountToGet;
    }

    public int getAccountOfHighestBeneficiary() {
        return accountOfHighestBeneficiary;
    }

    public void setAccountOfHighestBeneficiary(int accountOfHighestBeneficiary) {
        this.accountOfHighestBeneficiary = accountOfHighestBeneficiary;
    }

    public int getNumberOfAccounts() {
        return numberOfAccounts;
    }

    public void setNumberOfAccounts(int numberOfAccounts) {
        this.numberOfAccounts = numberOfAccounts;
    }
}

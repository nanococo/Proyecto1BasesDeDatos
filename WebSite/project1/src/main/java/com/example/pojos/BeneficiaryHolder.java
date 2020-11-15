package com.example.pojos;

import java.util.ArrayList;

public class BeneficiaryHolder {
    public ArrayList<Beneficiary> beneficiaries;

    public BeneficiaryHolder() {
    }

    public BeneficiaryHolder(ArrayList<Beneficiary> beneficiaries) {
        this.beneficiaries = beneficiaries;
    }

    public ArrayList<Beneficiary> getBeneficiaries() {
        return beneficiaries;
    }

    public void setBeneficiaries(ArrayList<Beneficiary> beneficiaries) {
        this.beneficiaries = beneficiaries;
    }
}

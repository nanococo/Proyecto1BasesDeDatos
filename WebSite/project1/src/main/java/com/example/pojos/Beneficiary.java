package com.example.pojos;

public class Beneficiary {
    private int beneficiaryId;
    private int personId;
    private int physicalIdValue;
    private int physicalIdType;
    private String name;
    private String birthday;
    private String email;
    private int num1;
    private int num2;
    private int percentage;
    private int kinshipId;
    private boolean active;

    public Beneficiary(int beneficiaryId, int personId, int physicalIdValue, int physicalIdType, String name, String birthday, String email, int num1, int num2, int percentage, int kinshipId, boolean active) {
        this.beneficiaryId = beneficiaryId;
        this.personId = personId;
        this.physicalIdValue = physicalIdValue;
        this.physicalIdType = physicalIdType;
        this.name = name;
        this.birthday = birthday;
        this.email = email;
        this.num1 = num1;
        this.num2 = num2;
        this.percentage = percentage;
        this.kinshipId = kinshipId;
        this.active = active;
    }

    public int getPersonId() {
        return personId;
    }

    public void setPersonId(int personId) {
        this.personId = personId;
    }

    public int getPhysicalIdValue() {
        return physicalIdValue;
    }

    public void setPhysicalIdValue(int physicalIdValue) {
        this.physicalIdValue = physicalIdValue;
    }

    public int getPhysicalIdType() {
        return physicalIdType;
    }

    public void setPhysicalIdType(int physicalIdType) {
        this.physicalIdType = physicalIdType;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getNum1() {
        return num1;
    }

    public void setNum1(int num1) {
        this.num1 = num1;
    }

    public int getNum2() {
        return num2;
    }

    public void setNum2(int num2) {
        this.num2 = num2;
    }

    public int getPercentage() {
        return percentage;
    }

    public void setPercentage(int percentage) {
        this.percentage = percentage;
    }

    public int getKinshipId() {
        return kinshipId;
    }

    public void setKinshipId(int kinshipId) {
        this.kinshipId = kinshipId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public int getBeneficiaryId() {
        return beneficiaryId;
    }

    public void setBeneficiaryId(int beneficiaryId) {
        this.beneficiaryId = beneficiaryId;
    }
}

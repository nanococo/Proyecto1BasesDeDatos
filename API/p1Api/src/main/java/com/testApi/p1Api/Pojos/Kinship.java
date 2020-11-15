package com.testApi.p1Api.Pojos;

public class Kinship {
    int index;
    String kinshipName;

    public Kinship(int index, String kinshipName) {
        this.kinshipName = kinshipName;
        this.index = index;
    }

    public String getKinshipName() {
        return kinshipName;
    }

    public void setKinshipName(String kinshipName) {
        this.kinshipName = kinshipName;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(int index) {
        this.index = index;
    }
}

package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class KinshipHolder {

    public KinshipHolder(ArrayList<Kinship> kinship) {
        this.kinship = kinship;
    }

    public ArrayList<Kinship> getKinship() {
        return kinship;
    }

    public void setKinship(ArrayList<Kinship> kinship) {
        this.kinship = kinship;
    }

    private ArrayList<Kinship> kinship = new ArrayList<>();
}

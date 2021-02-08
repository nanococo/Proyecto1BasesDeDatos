package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class NewQuery1Holder {

    public NewQuery1Holder() {
    }

    public NewQuery1Holder(ArrayList<NewQuery1> newQuery1s) {
        this.newQuery1s = newQuery1s;
    }

    private ArrayList<NewQuery1> newQuery1s;

    public ArrayList<NewQuery1> getNewQuery1s() {
        return newQuery1s;
    }

    public void setNewQuery1s(ArrayList<NewQuery1> newQuery1s) {
        this.newQuery1s = newQuery1s;
    }
}

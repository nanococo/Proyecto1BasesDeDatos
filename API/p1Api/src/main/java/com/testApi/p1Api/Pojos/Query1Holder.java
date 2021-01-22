package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class Query1Holder {

    public Query1Holder(ArrayList<Query1> query1s) {
        this.query1s = query1s;
    }

    public Query1Holder() {
    }

    private ArrayList<Query1> query1s;

    public ArrayList<Query1> getQuery1s() {
        return query1s;
    }

    public void setQuery1s(ArrayList<Query1> query1s) {
        this.query1s = query1s;
    }
}

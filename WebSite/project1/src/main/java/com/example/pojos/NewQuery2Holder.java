package com.example.pojos;

import java.util.ArrayList;

public class NewQuery2Holder {

    public NewQuery2Holder() {
    }

    public NewQuery2Holder(ArrayList<NewQuery2> newQuery2s) {
        this.newQuery2s = newQuery2s;
    }

    private ArrayList<NewQuery2> newQuery2s;

    public ArrayList<NewQuery2> getNewQuery2s() {
        return newQuery2s;
    }

    public void setNewQuery1s(ArrayList<NewQuery2> newQuery2s) {
        this.newQuery2s = newQuery2s;
    }
}

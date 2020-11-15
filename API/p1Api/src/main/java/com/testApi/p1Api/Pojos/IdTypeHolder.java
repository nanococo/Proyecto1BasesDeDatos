package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class IdTypeHolder {
    private ArrayList<IdType> idTypes;

    public IdTypeHolder(ArrayList<IdType> idTypes) {
        this.idTypes = idTypes;
    }

    public IdTypeHolder() {
    }

    public ArrayList<IdType> getIdTypes() {
        return idTypes;
    }

    public void setIdTypes(ArrayList<IdType> idTypes) {
        this.idTypes = idTypes;
    }
}

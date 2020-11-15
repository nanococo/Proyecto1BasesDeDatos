package com.testApi.p1Api.Pojos;

public class IdType {
    private int idIndex;
    private String idTypeName;

    public IdType(int idIndex, String idTypeName) {
        this.idIndex = idIndex;
        this.idTypeName = idTypeName;
    }

    public int getIdIndex() {
        return idIndex;
    }

    public void setIdIndex(int idIndex) {
        this.idIndex = idIndex;
    }

    public String getIdTypeName() {
        return idTypeName;
    }

    public void setIdTypeName(String idTypeName) {
        this.idTypeName = idTypeName;
    }
}

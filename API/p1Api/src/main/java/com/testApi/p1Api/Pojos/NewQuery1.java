package com.testApi.p1Api.Pojos;

public class NewQuery1 {
    private String name;
    private int minutes;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getMinutes() {
        return minutes;
    }

    public void setMinutes(int minutes) {
        this.minutes = minutes;
    }

    public NewQuery1(String name, int minutes) {
        this.name = name;
        this.minutes = minutes;
    }
}

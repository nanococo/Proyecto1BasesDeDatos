package com.example.pojos;

public class NewQuery4 {
    private String name;
    private int sumOfTime;

    public NewQuery4(String name, int points) {
        this.name = name;
        this.sumOfTime = points;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSumOfTime() {
        return sumOfTime;
    }

    public void setSumOfTime(int sumOfTime) {
        this.sumOfTime = sumOfTime;
    }
}

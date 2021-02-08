package com.example.pojos;

public class NewQuery3 {
    private String name;
    private int pointsMontana;

    public NewQuery3(String name, int points) {
        this.name = name;
        this.pointsMontana = points;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getPointsMontana() {
        return pointsMontana;
    }

    public void setPointsMontana(int pointsMontana) {
        this.pointsMontana = pointsMontana;
    }
}

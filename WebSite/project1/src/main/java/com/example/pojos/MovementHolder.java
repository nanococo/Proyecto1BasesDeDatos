package com.example.pojos;

import java.util.ArrayList;

public class MovementHolder {
    private ArrayList<Movement> movements = new ArrayList<>();

    public MovementHolder() {
    }

    public MovementHolder(ArrayList<Movement> movements) {
        this.movements = movements;
    }

    public ArrayList<Movement> getMovements() {
        return movements;
    }

    public void setMovements(ArrayList<Movement> movements) {
        this.movements = movements;
    }
}

package com.example.pojos;

import java.util.ArrayList;

public class StatementHolder {

    private ArrayList<Statement> statements = new ArrayList<>();

    public StatementHolder(ArrayList<Statement> statements) {
        this.statements = statements;
    }

    public StatementHolder() {
    }

    public ArrayList<Statement> getStatements() {
        return statements;
    }

    public void setStatements(ArrayList<Statement> statements) {
        this.statements = statements;
    }
}

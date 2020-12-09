package com.testApi.p1Api.Pojos;

import java.util.ArrayList;

public class ObjectiveAccountHolder {
    private ArrayList<ObjectiveAccount> objectiveAccounts = new ArrayList<>();

    public ObjectiveAccountHolder(ArrayList<ObjectiveAccount> objectiveAccounts) {
        this.objectiveAccounts = objectiveAccounts;
    }

    public ObjectiveAccountHolder() {
    }

    public ArrayList<ObjectiveAccount> getObjectiveAccounts() {
        return objectiveAccounts;
    }

    public void setObjectiveAccounts(ArrayList<ObjectiveAccount> objectiveAccounts) {
        this.objectiveAccounts = objectiveAccounts;
    }
}

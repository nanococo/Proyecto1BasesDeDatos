package com.testApi.p1Api.Pojos;

public class LoginInfo {

    private String username;
    private boolean isAdmin;
    private boolean isFound;

    public LoginInfo(String username, boolean isAdmin, boolean isFound) {
        this.username = username;
        this.isAdmin = isAdmin;
        this.isFound = isFound;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    public boolean isFound() {
        return isFound;
    }

    public void setFound(boolean found) {
        isFound = found;
    }
}

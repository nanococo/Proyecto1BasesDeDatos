package com.example.services;

import java.io.Serializable;

import com.example.services.singletons.Common;
import com.jayway.jsonpath.JsonPath;
import com.jayway.jsonpath.ReadContext;
import com.vaadin.flow.component.UI;
import org.springframework.stereotype.Service;

@Service
public class GreetService implements Serializable {

    public String greet(String name) {
        if (name == null || name.isEmpty()) {
            return "Hello anonymous user";
        } else {
            return "Hello " + name;
        }
    }

    public void navigate(){
        UI.getCurrent().navigate("home");
    }

    public boolean login(String username, String password){
        ReadContext readContext = JsonPath.parse(Common.readJsonFromUrl("http://localhost:8081/login?username="+username+"&password="+password));
        Common.username = readContext.read("$.username");
        Common.isAdmin = readContext.read("$.admin");
        return readContext.read("$.found");
    }

}

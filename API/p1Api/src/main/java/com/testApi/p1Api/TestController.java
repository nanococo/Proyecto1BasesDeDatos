package com.testApi.p1Api;

import com.testApi.p1Api.DataBaseManager.SQLConnection;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/employees")
    public String test(){
        System.out.println("test is going good");
        return "Hello World";
    }

    @GetMapping("/test")
    public String test2(@RequestParam(value = "testVal") String value, @RequestParam(value = "testVal2") String value2){
        System.out.println("Value 1: "+value);
        System.out.println("Value 2: "+value2);
        SQLConnection.getInstance().setPlayer(value, value2);
        return "Success";
    }
}

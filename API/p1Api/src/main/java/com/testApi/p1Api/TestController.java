package com.testApi.p1Api;

import com.google.gson.Gson;
import com.testApi.p1Api.DataBaseManager.SQLConnection;
import com.testApi.p1Api.Pojos.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    private final Gson gson = new Gson();

    @GetMapping("/employees")
    public String test(){
        System.out.println("test is going good");
        return "Hello World";
    }

    @GetMapping(value = "/login", produces = MediaType.APPLICATION_JSON_VALUE)
    public LoginInfo testLogin(@RequestParam(value = "username") String value, @RequestParam(value = "password") String value2){
        return SQLConnection.getInstance().login(value, value2);
    }

    @GetMapping(value = "/getAccounts", produces = MediaType.APPLICATION_JSON_VALUE)
    public AccountsHolder testLogin(@RequestParam(value = "username") String value){
        return SQLConnection.getInstance().getAccounts(value);
    }

    @GetMapping(value = "/getAllAccounts", produces = MediaType.APPLICATION_JSON_VALUE)
    public AccountsHolder testLogin(){
        return SQLConnection.getInstance().getAllAccounts();
    }

    @GetMapping(value = "/getBeneficiaries", produces = MediaType.APPLICATION_JSON_VALUE)
    public BeneficiaryHolder getBeneficiaries(@RequestParam(value = "accountId") String value){
        return SQLConnection.getInstance().getBeneficiaries(value);
    }

    @GetMapping(value = "/getKinship", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getKinship(){
        KinshipHolder kinshipHolder = SQLConnection.getInstance().getKinship();
        String json = gson.toJson(kinshipHolder);
        return new ResponseEntity<>(json, HttpStatus.OK);
    }

    @GetMapping(value = "/getIdType", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> getIdTypes(){
        IdTypeHolder idTypeHolder = SQLConnection.getInstance().getIdTypes();
        String json = gson.toJson(idTypeHolder);
        return new ResponseEntity<>(json, HttpStatus.OK);
    }


    @GetMapping(value = "/insertBeneficiary")
    public ResponseEntity<?> insertBeneficiary(@RequestParam(value = "id") String value,
                                               @RequestParam(value = "percentage") String value2,
                                               @RequestParam(value = "accountId") String value3,
                                               @RequestParam(value = "kinship") String value4){

        if(SQLConnection.getInstance().insertBeneficiary(value, value2, value3, value4)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/deleteBeneficiary")
    public ResponseEntity<?> deleteBeneficiary(@RequestParam(value = "id") String value,
                                  @RequestParam(value = "beneficiaryId") String value2){

        if(SQLConnection.getInstance().deleteBeneficiary(value, value2)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/deleteObjectiveAccount")
    public ResponseEntity<?> deleteObjectiveAccount(@RequestParam(value = "id") String value){
        if(SQLConnection.getInstance().deleteObjectiveAccount(value)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/updateBeneficiary")
    public ResponseEntity<?> updateBeneficiary(@RequestParam(value = "personId") String value,
                                  @RequestParam(value = "accountId") String value2,
                                  @RequestParam(value = "name") String value3,
                                  @RequestParam(value = "kinship") String value4,
                                  @RequestParam(value = "percentage") String value5,
                                  @RequestParam(value = "date") String value6,
                                  @RequestParam(value = "newId") String value7,
                                  @RequestParam(value = "email") String value8,
                                  @RequestParam(value = "phone1") String value9,
                                  @RequestParam(value = "phone2") String value10){
        if(SQLConnection.getInstance().updateBeneficiary(value, value2, value3, value4, value5, value6, value7, value8, value9, value10)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/getStatement", produces = MediaType.APPLICATION_JSON_VALUE)
    public StatementHolder getStatement(@RequestParam(value = "accountId") String value){
        return SQLConnection.getInstance().getStatements(value);
    }


    @GetMapping(value = "/insertPerson")
    public ResponseEntity<?> insertPerson(@RequestParam(value = "id") String value,
                                               @RequestParam(value = "idTypeSelected") String value2,
                                               @RequestParam(value = "date") String value3,
                                               @RequestParam(value = "name") String value4,
                                               @RequestParam(value = "email") String value5,
                                               @RequestParam(value = "phone1") String value6,
                                               @RequestParam(value = "phone2") String value7){
        if(SQLConnection.getInstance().insertPerson(value, value2, value3, value4, value5, value6, value7)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/getMovements", produces = MediaType.APPLICATION_JSON_VALUE)
    public MovementHolder testLogin(@RequestParam(value = "accountId") String value,
                                    @RequestParam(value = "startDate") String value2,
                                    @RequestParam(value = "endDate") String value3){
        return SQLConnection.getInstance().getMovements(value, value2, value3);
    }

    @GetMapping(value = "/insertObjectiveAccount")
    public ResponseEntity<?> insertObjectiveAccount(@RequestParam(value = "accountId") String value,
                                                    @RequestParam(value = "startDate") String value2,
                                                    @RequestParam(value = "endDate") String value3,
                                                    @RequestParam(value = "dayOfSavings") String value4,
                                                    @RequestParam(value = "amount") String value5,
                                                    @RequestParam(value = "description") String value6){
        if(SQLConnection.getInstance().insertObjectiveAccount(value, value2, value3, value4, value5, value6)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/getObjectiveAccounts", produces = MediaType.APPLICATION_JSON_VALUE)
    public ObjectiveAccountHolder getObjectiveAccounts(@RequestParam(value = "accountId") String value){
        return SQLConnection.getInstance().getObjectiveAccounts(value);
    }

    @GetMapping(value = "/updateObjectiveAccount")
    public ResponseEntity<?> updateObjectiveAccount(@RequestParam(value = "id") String value,
                                                    @RequestParam(value = "amount") String value2,
                                                    @RequestParam(value = "description") String value3,
                                                    @RequestParam(value = "startDate") String value4,
                                                    @RequestParam(value = "endDate") String value5,
                                                    @RequestParam(value = "processDate") String value6){
        if(SQLConnection.getInstance().updateObjectiveAccount(value, value2, value3, value4, value5, value6)){
            return new ResponseEntity<>(HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping(value = "/getMovementsFiltered", produces = MediaType.APPLICATION_JSON_VALUE)
    public MovementHolder getMovementsFiltered(@RequestParam(value = "accountId") String value,
                                               @RequestParam(value = "startDate") String value2,
                                               @RequestParam(value = "endDate") String value3,
                                               @RequestParam(value = "filter") String value4){
        return SQLConnection.getInstance().getMovementsFiltered(value, value2, value3, value4);
    }

    @GetMapping(value = "/getQuery1")
    public Query1Holder getQuery1(){
        return SQLConnection.getInstance().getQuery1();
    }

    @GetMapping(value = "/getQuery3")
    public Query3Holder getQuery3(){
        return SQLConnection.getInstance().getQuery3();
    }
}

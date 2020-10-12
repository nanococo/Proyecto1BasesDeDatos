package com.testApi.p1Api.DataBaseManager;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLConnection {

    private final String connectionString = "jdbc:sqlserver://192.168.39.199:1433;databaseName=WaifuBot";
    private final String user = "waifuBot";
    private final String password = "pass1234";

    private static SQLConnection sqlConnection;

    private SQLConnection(){
        try {
            Connection connection = DriverManager.getConnection(connectionString, user, password);
            System.out.println("Connection Successful");
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static SQLConnection getInstance(){
        if(sqlConnection != null) return sqlConnection;
        sqlConnection = new SQLConnection();
        return sqlConnection;
    }


    public void setPlayer(String id, String name){
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, password);

            CallableStatement proc = connection.prepareCall("{call insertPlayer(?,?)}");
            proc.setString(1, id);
            proc.setString(2, name);

            proc.execute();
        }catch (Exception e){
            e.printStackTrace();
        }
        finally {
            try {
                connection.close();
            } catch (Exception f){
                f.printStackTrace();
            }
        }
    }
}

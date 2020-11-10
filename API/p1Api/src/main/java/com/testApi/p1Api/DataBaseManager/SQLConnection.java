package com.testApi.p1Api.DataBaseManager;

import com.testApi.p1Api.Pojos.Account;
import com.testApi.p1Api.Pojos.AccountsHolder;
import com.testApi.p1Api.Pojos.LoginInfo;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class SQLConnection {

    private final String connectionString = "jdbc:sqlserver://192.168.39.199:1433;databaseName=Banco";
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

    public LoginInfo login(String username, String password){
        Connection connection = null;
        LoginInfo loginInfo;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            //CallableStatement proc = connection.prepareCall("{call testLogin(?,?)}");
            CallableStatement proc = connection.prepareCall("select * from Usuarios where Username = ? and Password = ?");
            proc.setString(1, username);
            proc.setString(2, password);


            ResultSet test = proc.executeQuery();
            if(test.next()) {
                loginInfo = new LoginInfo(username, test.getString("EsAdmin").equals("1"), true);
            } else {
                loginInfo = new LoginInfo(username, false, false);
            }

            connection.close();
            return loginInfo;

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
        return new LoginInfo(username, false, false);
    }

    public AccountsHolder getAccounts(String username){
        Connection connection = null;
        ArrayList<Account> accounts = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            //CallableStatement proc = connection.prepareCall("{call testLogin(?,?)}");
            CallableStatement proc = connection.prepareCall("{call getAccounts(?)}");
            proc.setString(1, username);
            DecimalFormat df = new DecimalFormat("#.##");

            ResultSet test = proc.executeQuery();
            while(test.next()) {
                accounts.add(new Account(
                        Integer.parseInt(test.getString("Id")),
                        Integer.parseInt(test.getString("NumeroCuenta")),
                        Integer.parseInt(test.getString("PersonaId")),
                        Integer.parseInt(test.getString("TipoCuentaId")),
                        test.getString("FechaCreacion"),
                        df.format(Double.parseDouble(test.getString("Saldo"))),
                        test.getString("EstaActiva").equals("1")
                        ));
            }

            connection.close();
            return new AccountsHolder(accounts);

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
        return null;
    }
}

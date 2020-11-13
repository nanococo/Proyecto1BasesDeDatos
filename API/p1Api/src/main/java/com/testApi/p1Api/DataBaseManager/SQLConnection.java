package com.testApi.p1Api.DataBaseManager;

import com.testApi.p1Api.Pojos.*;
import com.testApi.p1Api.Pojos.Statement;

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

    public LoginInfo login(String username, String password){
        Connection connection = null;
        LoginInfo loginInfo;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_testLogin(?,?)}");
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
            CallableStatement proc = connection.prepareCall("{call sp_getAccounts(?)}");
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

    public BeneficiaryHolder getBeneficiaries(String accountId) {
        Connection connection = null;
        ArrayList<Beneficiary> beneficiaries = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getBeneficiaryDataByAccount(?)}");
            proc.setString(1, accountId);

            ResultSet test = proc.executeQuery();
            while(test.next()) {

                beneficiaries.add(new Beneficiary(
                        Integer.parseInt(test.getString(9)),
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        Integer.parseInt(test.getString(3)),
                        test.getString(4),
                        test.getString(5),
                        test.getString(6),
                        Integer.parseInt(test.getString(7)),
                        Integer.parseInt(test.getString(8)),
                        Integer.parseInt(test.getString(12)),
                        Integer.parseInt(test.getString(13)),
                        test.getString(14).equals("1")
                ));
            }

            connection.close();
            return new BeneficiaryHolder(beneficiaries);

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

    public KinshipHolder getKinship() {
        Connection connection = null;
        ArrayList<Kinship> kinship = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            //CallableStatement proc = connection.prepareCall("{call testLogin(?,?)}");
            CallableStatement proc = connection.prepareCall("{call sp_getKinships()}");

            ResultSet test = proc.executeQuery();
            while(test.next()) {

                kinship.add(new Kinship(
                        Integer.parseInt(test.getString(1)),
                        test.getString(2)
                ));
            }

            connection.close();
            return new KinshipHolder(kinship);

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

    public void insertBeneficiary(String id, String percentage, String accountId, String kinship){
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_insertarBeneficiario(?,?,?,?)}");
            proc.setString(1, id);
            proc.setInt(2, Integer.parseInt(accountId));
            proc.setInt(3, Integer.parseInt(percentage));
            proc.setString(4, kinship);

            proc.execute();
            connection.close();

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

    public void deleteBeneficiary(String accountId, String beneficiaryId) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_eliminarBeneficiario(?,?)}");
            proc.setInt(1, Integer.parseInt(beneficiaryId));
            proc.setInt(2, Integer.parseInt(accountId));

            proc.execute();
            connection.close();

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

    public void updateBeneficiary(String personId, String physicalId, String name, String kinship, String percentage, String date, String newId, String email, String phone1, String phone2) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            System.out.println(name);

            CallableStatement proc = connection.prepareCall("{call sp_editarBeneficiario(?,?,?,?,?,?,?,?,?,?)}");
            proc.setInt(1, Integer.parseInt(personId));
            proc.setInt(2, Integer.parseInt(physicalId));
            proc.setString(3, name);
            proc.setString(4, kinship);
            proc.setInt(5, Integer.parseInt(percentage));
            proc.setDate(6, Date.valueOf(date));
            proc.setInt(7, Integer.parseInt(newId));
            proc.setString(8, email);
            proc.setInt(9, Integer.parseInt(phone1));
            proc.setInt(10, Integer.parseInt(phone2));


            proc.execute();
            connection.close();

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

    public StatementHolder getStatements(String accountId) {
        Connection connection = null;
        ArrayList<Statement> statements = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getStatementsByAccountId(?)}");
            proc.setString(1, accountId);

            ResultSet test = proc.executeQuery();
            while(test.next()) {

                statements.add(new Statement(
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        test.getString(3),
                        test.getString(4),
                        test.getString(5),
                        test.getString(6)
                        ));
            }

            connection.close();
            return new StatementHolder(statements);

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
        return new StatementHolder();
    }
}

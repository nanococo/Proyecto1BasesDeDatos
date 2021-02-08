package com.testApi.p1Api.DataBaseManager;

import com.testApi.p1Api.Pojos.*;
import com.testApi.p1Api.Pojos.Statement;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.ArrayList;

public class SQLConnection {

    private final String connectionString = "jdbc:sqlserver://192.168.39.199:1433;databaseName=CompetenciaCiclistica";
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

    public AccountsHolder getAllAccounts(){
        Connection connection = null;
        ArrayList<Account> accounts = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            //CallableStatement proc = connection.prepareCall("{call testLogin(?,?)}");
            CallableStatement proc = connection.prepareCall("{call sp_getAllAccounts()}");
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

    public IdTypeHolder getIdTypes() {
        Connection connection = null;
        ArrayList<IdType> kinship = new ArrayList<>();
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getIdTypes()}");

            ResultSet test = proc.executeQuery();
            while(test.next()) {
                kinship.add(new IdType(
                        Integer.parseInt(test.getString(1)),
                        test.getString(2)
                ));
            }

            connection.close();
            return new IdTypeHolder(kinship);

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

    public boolean insertBeneficiary(String id, String percentage, String accountId, String kinship){
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_insertarBeneficiario(?,?,?,?)}");
            proc.registerOutParameter(1, Types.INTEGER);

            proc.setString(2, id);
            proc.setInt(3, Integer.parseInt(accountId));
            proc.setInt(4, Integer.parseInt(percentage));
            proc.setString(5, kinship);

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();

            return ret==1;

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
        return false;
    }

    public boolean deleteBeneficiary(String accountId, String beneficiaryId) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_eliminarBeneficiario(?,?)}");

            proc.registerOutParameter(1, Types.INTEGER);
            proc.setInt(2, Integer.parseInt(beneficiaryId));
            proc.setInt(3, Integer.parseInt(accountId));

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();
            return ret==1;

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
        return false;
    }

    public boolean updateBeneficiary(String personId, String physicalId, String name, String kinship, String percentage, String date, String newId, String email, String phone1, String phone2) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_editarBeneficiario(?,?,?,?,?,?,?,?,?,?)}");

            proc.registerOutParameter(1, Types.INTEGER);

            proc.setInt(2, Integer.parseInt(personId));
            proc.setInt(3, Integer.parseInt(physicalId));
            proc.setString(4, name);
            proc.setString(5, kinship);
            proc.setInt(6, Integer.parseInt(percentage));
            proc.setDate(7, Date.valueOf(date));
            proc.setInt(8, Integer.parseInt(newId));
            proc.setString(9, email);
            proc.setInt(10, Integer.parseInt(phone1));
            proc.setInt(11, Integer.parseInt(phone2));


            proc.execute();
            int ret = proc.getInt(1);
            connection.close();
            return ret==1;

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
        return false;
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
                        Integer.parseInt(test.getString(5)),
                        Integer.parseInt(test.getString(6)),
                        test.getString(7),
                        test.getString(8),
                        test.getString(9)
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

    public boolean insertPerson(String id, String idTypeName, String date, String name, String email, String phone1, String phone2) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_insertarPersona(?,?,?,?,?,?,?)}");
            proc.registerOutParameter(1, Types.INTEGER);

            proc.setString(2, id);
            proc.setString(3, idTypeName);
            proc.setString(4, name);
            proc.setDate(5, Date.valueOf(date));
            proc.setString(6, email);
            proc.setInt(7, Integer.parseInt(phone1));
            proc.setInt(8, Integer.parseInt(phone2));

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();

            return ret==1;

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
        return false;
    }

    public MovementHolder getMovements(String accountId, String startDate, String endDate) {
        ArrayList<Movement> statements = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getMovementsByAccountAndDat(?,?,?)}");
            proc.setString(1, accountId);
            proc.setDate(2, Date.valueOf(startDate));
            if(endDate==null || endDate.equals("null")){
                proc.setNull(3, Types.DATE);
            } else {
                proc.setDate(3, Date.valueOf(endDate));
            }

            //Hello

            ResultSet test = proc.executeQuery();

            while(test.next()) {
                statements.add(new Movement(
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        Integer.parseInt(test.getString(3)),
                        test.getString(4),
                        test.getString(5),
                        test.getString(6),
                        test.getString(7)
                ));
            }

            connection.close();
            return new MovementHolder(statements);

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
        return new MovementHolder();
    }


    public boolean insertObjectiveAccount(String accountId, String startDate, String endDate, String dayOfSavings, String amount, String description) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_insertarCuentaObjetivo(?,?,?,?,?,?)}");
            proc.registerOutParameter(1, Types.INTEGER);

            proc.setString(2, accountId);
            proc.setDate(3, Date.valueOf(startDate));
            proc.setDate(4, Date.valueOf(endDate));
            proc.setInt(5, Integer.parseInt(dayOfSavings));
            proc.setFloat(6, Float.parseFloat(amount));
            proc.setString(7, description);

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();

            return ret==1;

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
        return false;
    }


    public ObjectiveAccountHolder getObjectiveAccounts(String accountId) {
        ArrayList<ObjectiveAccount> statements = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getObjectiveAccounts(?)}");
            proc.setString(1, accountId);

            ResultSet test = proc.executeQuery();

            while(test.next()) {
                statements.add(new ObjectiveAccount(
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        test.getString(3),
                        test.getString(4),
                        test.getString(5),
                        test.getString(6),
                        test.getString(7),
                        test.getString(8).equals("1")
                ));
            }

            connection.close();
            return new ObjectiveAccountHolder(statements);

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
        return new ObjectiveAccountHolder();
    }

    public boolean updateObjectiveAccount(String id, String amount, String description, String startDate, String endDate, String processDate) {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_editarCuentaObjetivo(?,?,?,?,?,?)}");

            proc.registerOutParameter(1, Types.INTEGER);

            proc.setInt(2, Integer.parseInt(id));
            proc.setFloat(3, Float.parseFloat(amount));
            proc.setString(4, description);
            proc.setDate(5, Date.valueOf(startDate));
            proc.setDate(6, Date.valueOf(endDate));
            proc.setInt(7, Integer.parseInt(processDate));

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();
            return ret==1;

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
        return false;
    }

    public boolean deleteObjectiveAccount(String id){
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{? = call sp_eliminarCuentaObjetivo(?)}");

            proc.registerOutParameter(1, Types.INTEGER);
            proc.setInt(2, Integer.parseInt(id));

            proc.execute();
            int ret = proc.getInt(1);
            connection.close();
            return ret==1;

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
        return false;
    }

    public MovementHolder getMovementsFiltered(String accountId, String startDate, String endDate, String filter) {
        ArrayList<Movement> statements = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getAllMovementsWithPattern(?,?,?,?)}");
            proc.setString(1, accountId);
            proc.setDate(2, Date.valueOf(startDate));
            if (endDate == null || endDate.equals("null")) {
                proc.setNull(3, Types.DATE);
            } else {
                proc.setDate(3, Date.valueOf(endDate));
            }

            proc.setString(4, filter);


            //Hello

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                statements.add(new Movement(
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        Integer.parseInt(test.getString(3)),
                        test.getString(4),
                        test.getString(5),
                        test.getString(6),
                        test.getString(7)
                ));
            }

            connection.close();
            return new MovementHolder(statements);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new MovementHolder();
    }

    public Query1Holder getQuery1() {
        ArrayList<Query1> query1s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_consultaUno()}");
            //Hello

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                query1s.add(new Query1(
                        Integer.parseInt(test.getString(1)),
                        Integer.parseInt(test.getString(2)),
                        test.getString(3),
                        Integer.parseInt(test.getString(4)),
                        Integer.parseInt(test.getString(5)),
                        test.getString(6),
                        test.getString(7)
                ));
            }

            connection.close();
            return new Query1Holder(query1s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new Query1Holder();
    }

    public Query3Holder getQuery3() {
        ArrayList<Query3> query3s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_ObtenerDineroBeneficiarios()}");
            //Hello

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                query3s.add(new Query3(
                        Integer.parseInt(test.getString(1)),
                        test.getString(2),
                        Integer.parseInt(test.getString(3)),
                        Integer.parseInt(test.getString(4))
                ));
            }

            connection.close();
            return new Query3Holder(query3s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new Query3Holder();
    }

    public NewQuery1Holder getNewQuery1(String giroName, String year) {
        ArrayList<NewQuery1> newQuery1s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getBestRunners(?,?)}");
            proc.setString(1, giroName);
            proc.setInt(2, Integer.parseInt(year));

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                newQuery1s.add(new NewQuery1(
                        test.getString(1),
                        Integer.parseInt(test.getString(2))
                ));
            }

            connection.close();
            return new NewQuery1Holder(newQuery1s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new NewQuery1Holder();
    }

    public NewQuery2Holder getNewQuery2(String giroName, String year) {
        ArrayList<NewQuery2> newQuery2s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getBestRegularRunners(?,?)}");
            proc.setString(1, giroName);
            proc.setInt(2, Integer.parseInt(year));

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                newQuery2s.add(new NewQuery2(
                        test.getString(1),
                        Integer.parseInt(test.getString(2))
                ));
            }

            connection.close();
            return new NewQuery2Holder(newQuery2s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new NewQuery2Holder();
    }

    public NewQuery3Holder getNewQuery3(String giroName, String year) {
        ArrayList<NewQuery3> newQuery3s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getRunnersWithBestScore(?,?)}");
            proc.setString(1, giroName);
            proc.setInt(2, Integer.parseInt(year));

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                newQuery3s.add(new NewQuery3(
                        test.getString(1),
                        Integer.parseInt(test.getString(2))
                ));
            }

            connection.close();
            return new NewQuery3Holder(newQuery3s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new NewQuery3Holder();
    }

    public NewQuery4Holder getNewQuery4(String giroName, String year) {
        ArrayList<NewQuery4> newQuery4s = new ArrayList<>();
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(connectionString, user, this.password);

            CallableStatement proc = connection.prepareCall("{call sp_getBestTeams(?,?)}");
            proc.setString(1, giroName);
            proc.setInt(2, Integer.parseInt(year));

            ResultSet test = proc.executeQuery();

            while (test.next()) {
                newQuery4s.add(new NewQuery4(
                        test.getString(1),
                        Integer.parseInt(test.getString(2))
                ));
            }

            connection.close();
            return new NewQuery4Holder(newQuery4s);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                connection.close();
            } catch (Exception f) {
                f.printStackTrace();
            }
        }
        return new NewQuery4Holder();
    }
}

package com.feastorder.util;

/**
 * UTILITY: DBConnection
 * ------------------------------------------------------------
 * Central place to open a connection to your MySQL database.
 * Every DAO class will call DBConnection.getConnection() instead of
 * repeating JDBC boilerplate everywhere.
 *
 * TODO for your team:
 * 1. Add constants for your DB connection details:
 *      private static final String URL = "jdbc:mysql://localhost:3306/feastorder_db";
 *      private static final String USER = "root";
 *      private static final String PASSWORD = "your_password";
 *
 * 2. In a static block, load the JDBC driver:
 *      Class.forName("com.mysql.cj.jdbc.Driver");
 *
 * 3. Write a method:
 *      public static Connection getConnection() throws SQLException {
 *          return DriverManager.getConnection(URL, USER, PASSWORD);
 *      }
 *
 * 4. Make sure the MySQL Connector/J .jar is added to
 *    src/main/webapp/WEB-INF/lib/ (already created for you).
 *
 * IMPORTANT: never hardcode real passwords if you plan to share this
 * repo publicly — consider using a properties file instead once the
 * basic version works.
 */
public class DBConnection {

    // TODO: add connection fields + static getConnection() method here

}

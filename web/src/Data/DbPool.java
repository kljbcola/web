package Data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DbPool {

    private static DbPool instance = null;
    private static String dBDriver = "com.mysql.jdbc.Driver";
    private static String connectionUrl = "jdbc:mysql://localhost:3306/db?useUnicode=true&characterEncoding=UTF-8&useSSL=false";
    private static String user = "datauser";
    private static String password = "135798";
    public static String getConnectionUrl() {
    	return connectionUrl;
    }
    public static String getDBuser() {
    	return user;
    }
    public static String getDBpassword() {
    	return password;
    }
    private DbPool()
    {
        super();
    }
    //取得连接
    public static synchronized Connection getConnection()
    {
        if(instance == null)
            instance = new DbPool();
        return instance._getConnection();
    }
    private Connection _getConnection()
    {
        try
        {
            //加载驱动
            Class.forName(dBDriver);
            return DriverManager.getConnection(connectionUrl,user,password);
            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("数据库连接出错！");
            return null;
        }
    }
    
    //释放资源
    public static void DBClose(Connection con ,PreparedStatement ps,ResultSet rs)
    {
        try
        {
            if(rs !=  null)
                rs.close();
            if(ps != null)
                ps.close();
            if(con != null)
                con.close();
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("数据库连接关闭出错！");
        }
    }
  //释放资源
    public static void DBClose(Connection con ,PreparedStatement ps)
    {
        try
        {
            if(ps != null)
                ps.close();
            if(con != null)
                con.close();
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("数据库连接关闭出错！");
        }
    }
}
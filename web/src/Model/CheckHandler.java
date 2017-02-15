package Model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import Data.DbPool;

public class CheckHandler {
	static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    public static boolean checkUserAccount(String userAccount)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_id from user_message where user_name=?";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,userAccount);
            rs = ps.executeQuery();
            if(rs.next())
            {    
                //释放资源
                DbPool.DBClose(con, ps, rs);      
            	return true;
            }
            else
            {
                //释放资源
                DbPool.DBClose(con, ps, rs);
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
        return false;
    }
    public static boolean checkEquipID(String euqipID)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select equip_name from equip_message where equip_number=?";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,euqipID);
            rs = ps.executeQuery();
            if(rs.next())
            {    
                //释放资源
                DbPool.DBClose(con, ps, rs);      
            	return true;
            }
            else
            {
                //释放资源
                DbPool.DBClose(con, ps, rs);
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("查询出错!");
            return false;
        }
        return false;
    }
}

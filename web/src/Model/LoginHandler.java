package Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import Bean.UserBean;
import Data.DbPool;

public class LoginHandler {
    static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    public static UserBean checkLogin(String userName,String userPwd)
    {
        //从数据访问组件中取得连接
    	UserBean userBean = null;
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_id,name,user_type from user_message where user_name=? and password=md5(?);";
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,userName);
            ps.setString(2, userPwd);
            rs = ps.executeQuery();
            if(rs.next())
            {    
            	userBean=new UserBean();
            	userBean.userID=""+rs.getLong(1);
            	userBean.userName=rs.getString(2);
            	userBean.userType=rs.getString(3);
            	userBean.userAccount=userName;
                //释放资源
                DbPool.DBClose(con, ps, rs);            
            }
            else
            {
                //释放资源
                DbPool.DBClose(con, ps, rs);
            }            
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("checkLogin出错!");
            return null;
        }
        return userBean;
    }
    public static boolean checkPassWord(String userName,String userPwd)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_id from user_message where user_name=? and password=md5(?);";
        
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,userName);
            ps.setString(2, userPwd);
            rs = ps.executeQuery();
            if(rs.next())
            {    
                //释放资源
                DbPool.DBClose(con, ps, rs);    
                return true;
            }
          //释放资源
            DbPool.DBClose(con, ps, rs);   
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("checkPassWord出错!");
        }
        return false;
    }
}
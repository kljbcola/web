package Model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import Bean.UserBean;
import Bean.UserInfoBean;
import Data.DbPool;

public class AdminHandler {
    static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    
    public static boolean checkAdmin(UserBean userBean) {
    	if(userBean==null || !userBean.userType.equals("管理员"))
    		return false;
    	return true;
    }
    public static ArrayList<UserBean> getUserBeans(){
    	ArrayList<UserBean> userBeans=new ArrayList<UserBean>();
    	
    	con = DbPool.getConnection();
        //得到Controller传入的用户输入的用户名及密码
        String strSql = "select user_id,user_name,name,user_type from user_message;";
        try
        {
        	UserBean userBean;
            ps = con.prepareStatement(strSql);
            rs = ps.executeQuery();
            while(rs.next())
            {    
            	userBean=new UserBean();
            	userBean.userID=""+rs.getLong(1);
            	userBean.userAccount=rs.getString(2);
            	userBean.userName=rs.getString(3);
            	userBean.userType=rs.getString(4);
            	userBeans.add(userBean);
                //释放资源
            }
            //释放资源
            DbPool.DBClose(con, ps, rs);
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("checkLogin出错!");
        }
    	return userBeans;
    }

    private static String clearNullString(String str){
    	if(str==null||str.equals("null"))
    		return "";
    	else return str;
    }
	public static UserInfoBean getUserInfoBean(String userID){
		UserInfoBean userInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from user_message where user_id=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,userID);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	userInfoBean=new UserInfoBean();
	            	userInfoBean.userID=""+rs.getLong("user_id");
	            	userInfoBean.userAccount=rs.getString("user_name");	 
	            	userInfoBean.userType=rs.getString("user_type");
	            	userInfoBean.userIC_Number=clearNullString(rs.getString("card_number"));
	            	userInfoBean.userName=rs.getString("name");
	            	userInfoBean.userSex=clearNullString(rs.getString("sex"));
	            	userInfoBean.userID_Type=clearNullString(rs.getString("ID_type"));
	            	userInfoBean.userID_Number=clearNullString(rs.getString("ID_number"));
	            	userInfoBean.userTel=clearNullString(rs.getString("telephone"));
	            	userInfoBean.userAddress=clearNullString(rs.getString("address"));
	            	userInfoBean.userBirthDate=clearNullString(rs.getString("birthdate"));
	            	userInfoBean.userRemark=clearNullString(rs.getString("remark"));
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
		return userInfoBean;
	}
	private static String setValue(String val)
	{
		
		if(val!=null&&!val.equals(""))
			return "\'"+val+"\'";
		return "null";
	}
	public static boolean setUserInfo(UserInfoBean userInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "update user_message set "
	        		+ "  card_number="	+ setValue(userInfoBean.userIC_Number)
	        		+ ", name=" 		+ setValue(userInfoBean.userName)
	        		+ ", sex=" 			+ setValue(userInfoBean.userSex)
	        		+ ", ID_type=" 		+ setValue(userInfoBean.userID_Type)
	        		+ ", ID_number=" 	+ setValue(userInfoBean.userID_Number)
	        		+ ", telephone=" 	+ setValue(userInfoBean.userTel)
	        		+ ", address=" 		+ setValue(userInfoBean.userAddress)
	        		+ ", birthdate=" 	+ setValue(userInfoBean.userBirthDate)
	        		+ ", remark= " 		+ setValue(userInfoBean.userRemark)
	        		+ " where user_id=" + setValue(userInfoBean.userID)
	        		+ ";";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据修改出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
	}
	public static boolean addUser(UserInfoBean userInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO user_message "
	        		+ "(user_name,password,user_type,card_number,name,sex,ID_type,"
	        		+ "ID_number,telephone,address,birthdate,remark) values "+"("
	        		+  setValue(userInfoBean.userAccount)
	        		+ ", md5(" 	+ setValue(userInfoBean.userPassWd) +")"
	        		+ ", " 		+ setValue(userInfoBean.userType)
	        		+ ", "		+ setValue(userInfoBean.userIC_Number)
	        		+ ", " 		+ setValue(userInfoBean.userName)
	        		+ ", " 		+ setValue(userInfoBean.userSex)
	        		+ ", " 		+ setValue(userInfoBean.userID_Type)
	        		+ ", " 		+ setValue(userInfoBean.userID_Number)
	        		+ ", " 		+ setValue(userInfoBean.userTel)
	        		+ ", " 		+ setValue(userInfoBean.userAddress)
	        		+ ", " 		+ setValue(userInfoBean.userBirthDate)
	        		+ ",  " 	+ setValue(userInfoBean.userRemark) +");";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据添加出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
	}
	public static boolean delUser(String UserID)
	{
		con = DbPool.getConnection();
		 int rs;
	        String strSql = "delete from user_message where user_id="+UserID;
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            System.out.println(strSql);
	            rs = ps.executeUpdate();
	        }catch(Exception e)
	        {
	            e.printStackTrace();
	            System.out.println("数据删除出错!");
	            return false;
	        }
	        if(rs<1)
	        	return false;
	        else 
	        	return true;
	}
}

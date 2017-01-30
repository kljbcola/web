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

    public static ArrayList<UserBean> findUserBeans(String keyWord,int keyType){
    	ArrayList<UserBean> userBeans=new ArrayList<UserBean>();
    	switch (keyType) {
		case 1:						//用户ID
			break;

		default:
			break;
		}
    	
    	return userBeans;
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
	            	userInfoBean.userIC_Number=rs.getString("card_number");
	            	userInfoBean.userName=rs.getString("name");
	            	userInfoBean.userSex=rs.getString("sex");
	            	userInfoBean.userID_Type=rs.getString("ID_type");
	            	userInfoBean.userID_Number=rs.getString("ID_number");
	            	userInfoBean.userTel=rs.getString("telephone");
	            	userInfoBean.userAddress=rs.getString("address");
	            	userInfoBean.userBirthDate=rs.getString("birthdate");
	            	userInfoBean.userRemark=rs.getString("remark");
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


}

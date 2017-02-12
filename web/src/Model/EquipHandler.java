package Model;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import Bean.EquipInfoBean;
import Data.DbPool;

public class EquipHandler {
    static Connection con;
    static PreparedStatement ps;
    static ResultSet rs;
    private static String setValue(String val)
	{
		
		if(val!=null&&!val.equals(""))
			return "\'"+val+"\'";
		return "null";
	}
    
    private static String clearNullString(String str){
    	if(str==null||str.equals("null"))
    		return "";
    	else return str;
    }
    
    public static EquipInfoBean getLabInfoBean(String labnum){
    	System.out.println(labnum);
    	EquipInfoBean labInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from lab_message where lab_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,labnum);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	labInfoBean=new EquipInfoBean();
	            	labInfoBean.lab_number=rs.getString("lab_number");
	            	labInfoBean.lab_name=clearNullString(rs.getString("lab_name"));
	            	labInfoBean.lab_location=clearNullString(rs.getString("lab_location"));
	            	labInfoBean.faculty_number=clearNullString(rs.getString("faculty_number"));
	            	labInfoBean.description=clearNullString(rs.getString("description"));
	            	labInfoBean.build_time=clearNullString(rs.getString("build_time"));
	            	labInfoBean.research_area=clearNullString(rs.getString("research_area"));
	            	labInfoBean.attachment=clearNullString(rs.getString("attachment"));
	            	labInfoBean.owner=clearNullString(rs.getString("owner"));
	            	labInfoBean.phone=clearNullString(rs.getString("phone"));
	            	labInfoBean.Email=clearNullString(rs.getString("Email"));
	            	labInfoBean.feature=clearNullString(rs.getString("feature"));
	            	labInfoBean.price=clearNullString(rs.getString("price"));
	            	labInfoBean.overtime_price=clearNullString(rs.getString("overtime_price"));
	            	labInfoBean.min_time=clearNullString(rs.getString("min_time"));
	            	labInfoBean.max_time=clearNullString(rs.getString("max_time"));
	            	labInfoBean.lab_status=clearNullString(rs.getString("lab_status"));
	            	labInfoBean.open_hours=clearNullString(rs.getString("open_hours"));
	            	labInfoBean.close_hours=clearNullString(rs.getString("close_hours"));
	            	labInfoBean.lab_permission=clearNullString(rs.getString("lab_permission"));
	             	labInfoBean.lab_ip=clearNullString(rs.getString("lab_ip"));
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
	            System.out.println("getlabInfoBean出错!");
	            return null;
	        }
		return labInfoBean;
	}
    public static boolean setLabInfo(EquipInfoBean labInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "update lab_message set "
	        		+ "lab_name= "     		+setValue(labInfoBean.lab_name) 
	        		+ ", lab_location= " 		+ setValue(labInfoBean.lab_location)
	        		+ ", faculty_number= "	+ setValue(labInfoBean.faculty_number)
	        		+ ", description= " 		+ setValue(labInfoBean.description)
	        		+ ", build_time= " 		+ setValue(labInfoBean.build_time)
	        		+ ", research_area= " 	+ setValue(labInfoBean.research_area)
	        		+ ", attachment= " 		+ setValue(labInfoBean.attachment)
	        		+ ", owner= " 			+ setValue(labInfoBean.owner)
	        		+ ", phone= " 			+ setValue(labInfoBean.phone)
	        		+ ", Email= " 			+ setValue(labInfoBean.Email)
	        		+ ", feature= " 			+ setValue(labInfoBean.feature)
	        		+ ", price= " 			+ setValue(labInfoBean.price)
	        		+ ", overtime_price= " 	+ setValue(labInfoBean.overtime_price)
	        		+ ", min_time= " 			+ setValue(labInfoBean.min_time)
	        		+ ", max_time= " 			+ setValue(labInfoBean.max_time)
	        		+ ", lab_status= " 		+ setValue(labInfoBean.lab_status)
	        		+ ", open_hours= " 		+ setValue(labInfoBean.open_hours)
	        		+ ", close_hours= " 		+ setValue(labInfoBean.close_hours)
	        		+ ", lab_permission= " 	+ setValue(labInfoBean.lab_permission)
	        		+ ", lab_ip= " 			+ setValue(labInfoBean.lab_ip)
	        		+ " where lab_number=" + setValue(labInfoBean.lab_number)
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
    public static boolean addLab(EquipInfoBean labInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO lab_message "
	        		+ "(lab_number,lab_name,lab_location,faculty_number,description,build_time,research_area,"
	        		+ "attachment,owner,phone,Email,feature,price,overtime_price,min_time,max_time,lab_status,"
	        		+ "open_hours,close_hours,lab_permission,lab_ip) values "+"("
	        		+  			  setValue(labInfoBean.lab_number)
	        		+ ", "   	+ setValue(labInfoBean.lab_name) 
	        		+ ", " 		+ setValue(labInfoBean.lab_location)
	        		+ ", "		+ setValue(labInfoBean.faculty_number)
	        		+ ", " 		+ setValue(labInfoBean.description)
	        		+ ", " 		+ setValue(labInfoBean.build_time)
	        		+ ", " 		+ setValue(labInfoBean.research_area)
	        		+ ", " 		+ setValue(labInfoBean.attachment)
	        		+ ", " 		+ setValue(labInfoBean.owner)
	        		+ ", " 		+ setValue(labInfoBean.phone)
	        		+ ", " 		+ setValue(labInfoBean.Email)
	        		+ ", " 		+ setValue(labInfoBean.feature)
	        		+ ", " 		+ setValue(labInfoBean.price)
	        		+ ", " 		+ setValue(labInfoBean.overtime_price)
	        		+ ", " 		+ setValue(labInfoBean.min_time)
	        		+ ", " 		+ setValue(labInfoBean.max_time)
	        		+ ", " 		+ setValue(labInfoBean.lab_status)
	        		+ ", " 		+ setValue(labInfoBean.open_hours)
	        		+ ", " 		+ setValue(labInfoBean.close_hours)
	        		+ ", " 		+ setValue(labInfoBean.lab_permission)
	        		+ ",  " 	+ setValue(labInfoBean.lab_ip) +");";
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
    public static boolean delLab(String num)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from lab_message where lab_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("dellab出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }

}
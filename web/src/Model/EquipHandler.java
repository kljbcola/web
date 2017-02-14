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
    
    public static String changeBank(String a){
    	String b="";
    	for (int i=0; i<a.length(); i++){
    		if (a.charAt(i)!='\n'&&a.charAt(i)!='\r') b=b+a.charAt(i);
    		else b+="<br>";
    	}
    	return b;
    }
    public static EquipInfoBean changeBank(EquipInfoBean equip){
    	equip.description=changeBank(equip.description);
    	equip.attachment=changeBank(equip.attachment);
    	equip.specification=changeBank(equip.specification);
    	System.out.println(equip.specification+"~~~~~~~~~~~~~");
    	return equip;
    }
    
    public static EquipInfoBean getEquipInfoBean(String equipnum){
    	System.out.println(equipnum);
    	EquipInfoBean equipInfoBean=null;
		con = DbPool.getConnection();
	        String strSql = "select * from equip_message where equip_number=?;";
	        try
	        {
	            ps = con.prepareStatement(strSql);
	            ps.setString(1,equipnum);
	            rs = ps.executeQuery();
	            if(rs.next())
	            {    
	            	equipInfoBean=new EquipInfoBean();
	            	equipInfoBean.equip_number=rs.getString("equip_number");
	            	equipInfoBean.equip_name=clearNullString(rs.getString("equip_name"));
	            	equipInfoBean.equip_model=clearNullString(rs.getString("equip_model"));
	            	equipInfoBean.specification=clearNullString(rs.getString("specification"));
	            	equipInfoBean.lab_name=clearNullString(rs.getString("lab_name"));
	            	equipInfoBean.lab_location=clearNullString(rs.getString("lab_location"));
	            	equipInfoBean.faculty=clearNullString(rs.getString("faculty"));
	            	equipInfoBean.description=clearNullString(rs.getString("description"));
	            	equipInfoBean.build_time=clearNullString(rs.getString("build_time"));
	            	equipInfoBean.research_area=clearNullString(rs.getString("research_area"));
	            	equipInfoBean.attachment=clearNullString(rs.getString("attachment"));
	            	equipInfoBean.owner=clearNullString(rs.getString("owner"));
	            	equipInfoBean.phone=clearNullString(rs.getString("phone"));
	            	equipInfoBean.Email=clearNullString(rs.getString("Email"));
	            	equipInfoBean.price=clearNullString(rs.getString("price"));
	            	equipInfoBean.overtime_price=clearNullString(rs.getString("overtime_price"));
	            	equipInfoBean.min_time=clearNullString(rs.getString("min_time"));
	            	equipInfoBean.max_time=clearNullString(rs.getString("max_time"));
	            	equipInfoBean.equip_status=clearNullString(rs.getString("equip_status"));
	            	equipInfoBean.open_hours=clearNullString(rs.getString("open_hours"));
	            	equipInfoBean.close_hours=clearNullString(rs.getString("close_hours"));
	            	equipInfoBean.equip_permission=clearNullString(rs.getString("equip_permission"));
	             	equipInfoBean.equip_ip=clearNullString(rs.getString("equip_ip"));
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
	            System.out.println("getequipInfoBean出错!");
	            return null;
	        }
		return equipInfoBean;
	}
    public static boolean setequipInfo(EquipInfoBean equipInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "update equip_message set "
	        		+ "equip_name= "     		+setValue(equipInfoBean.equip_name) 
	        		+ ", equip_model= " 		+ setValue(equipInfoBean.equip_model)
	        		+ ", specification= " 		+ setValue(equipInfoBean.specification)
	        		+ ", lab_name= " 			+ setValue(equipInfoBean.lab_name)
	        		+ ", lab_location= " 		+ setValue(equipInfoBean.lab_location)
	        		+ ", faculty= "				+ setValue(equipInfoBean.faculty)
	        		+ ", description= " 		+ setValue(equipInfoBean.description)
	        		+ ", build_time= " 			+ setValue(equipInfoBean.build_time)
	        		+ ", research_area= " 		+ setValue(equipInfoBean.research_area)
	        		+ ", attachment= " 			+ setValue(equipInfoBean.attachment)
	        		+ ", owner= " 				+ setValue(equipInfoBean.owner)
	        		+ ", phone= " 				+ setValue(equipInfoBean.phone)
	        		+ ", Email= " 				+ setValue(equipInfoBean.Email)
	        		+ ", price= " 				+ setValue(equipInfoBean.price)
	        		+ ", overtime_price= " 		+ setValue(equipInfoBean.overtime_price)
	        		+ ", min_time= " 			+ setValue(equipInfoBean.min_time)
	        		+ ", max_time= " 			+ setValue(equipInfoBean.max_time)
	        		+ ", equip_status= " 		+ setValue(equipInfoBean.equip_status)
	        		+ ", open_hours= " 			+ setValue(equipInfoBean.open_hours)
	        		+ ", close_hours= " 		+ setValue(equipInfoBean.close_hours)
	        		+ ", equip_permission= " 	+ setValue(equipInfoBean.equip_permission)
	        		+ ", equip_ip= " 			+ setValue(equipInfoBean.equip_ip)
	        		+ " where equip_number=" 	+ setValue(equipInfoBean.equip_number)
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
    public static boolean addequip(EquipInfoBean equipInfoBean)
	{
		 con = DbPool.getConnection();
		 int rs;
	        String strSql = "INSERT INTO equip_message "
	        		+ "(equip_number,	equip_name,		equip_model,	specification,		lab_name,		lab_location,"
	        		+ " faculty,		description,	build_time,		research_area,		attachment,		owner,"
	        		+ " phone,			Email,			price,			overtime_price,		min_time,		max_time,"
	        		+ "equip_status,	open_hours,		close_hours,	equip_permission,	equip_ip)  values "+"("
	        		+  			  setValue(equipInfoBean.equip_number)
	        		+ ", "   	+ setValue(equipInfoBean.equip_name) 
	        		+ ", " 		+ setValue(equipInfoBean.equip_model)
	        		+ ", " 		+ setValue(equipInfoBean.specification)
	        		+ ", " 		+ setValue(equipInfoBean.lab_name)
	        		+ ", " 		+ setValue(equipInfoBean.lab_location)
	        		+ ", "		+ setValue(equipInfoBean.faculty)
	        		+ ", " 		+ setValue(equipInfoBean.description)
	        		+ ", " 		+ setValue(equipInfoBean.build_time)
	        		+ ", " 		+ setValue(equipInfoBean.research_area)
	        		+ ", " 		+ setValue(equipInfoBean.attachment)
	        		+ ", " 		+ setValue(equipInfoBean.owner)
	        		+ ", " 		+ setValue(equipInfoBean.phone)
	        		+ ", " 		+ setValue(equipInfoBean.Email)
	        		+ ", " 		+ setValue(equipInfoBean.price)
	        		+ ", " 		+ setValue(equipInfoBean.overtime_price)
	        		+ ", " 		+ setValue(equipInfoBean.min_time)
	        		+ ", " 		+ setValue(equipInfoBean.max_time)
	        		+ ", " 		+ setValue(equipInfoBean.equip_status)
	        		+ ", " 		+ setValue(equipInfoBean.open_hours)
	        		+ ", " 		+ setValue(equipInfoBean.close_hours)
	        		+ ", " 		+ setValue(equipInfoBean.equip_permission)
	        		+ ",  " 	+ setValue(equipInfoBean.equip_ip) +");";
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
    public static boolean delequip(String num)
    {
        //从数据访问组件中取得连接
        con = DbPool.getConnection();
        String strSql = "delete from equip_message where equip_number=?;";
        int rs;
        try
        {
            ps = con.prepareStatement(strSql);
            ps.setString(1,num);
            rs = ps.executeUpdate();
       
        }catch(Exception e)
        {
            e.printStackTrace();
            System.out.println("delequip出错!");
            return false;
        }
        if (rs<1) return false;
        else return true;
    }

}
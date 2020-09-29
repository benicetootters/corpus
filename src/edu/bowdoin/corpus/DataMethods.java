package edu.bowdoin.corpus;

import java.security.MessageDigest;
import java.util.Iterator;
import java.util.Vector;

import javax.sql.DataSource;
import javax.xml.bind.DatatypeConverter;

import org.apache.logging.log4j.Logger;
import edu.bowdoin.nova.*;
import nu.xom.Element;
import nu.xom.Elements;

public class DataMethods extends DataUtilities {

	
    /** 
     * Constructor initiates the data source and logger
     * @param ds data source
     * @param log4j Apache log4j2 logger
     */
    public DataMethods(DataSource ds, Logger log4j) {
		this.logger = log4j;
    	this.ds = ds;
	}

    public int GetUserID(String email) {
    	int uid = -1;
    	try {

    		
    		String sql = "SELECT idcorpus_user FROM corpus_user WHERE email=?";
    		Vector<Object> ps = new Vector<Object>(2);
	    	ps.add(email);

	    	
	    	uid = QueryIntPS(sql,ps);
    		
    	} catch( Exception e) {
    		this.logger.error("GetUserID: "+e);
    	}
        return uid;
    }
    
    
    public Element GetWorkPetia(String wid) {
    	String sql = "SELECT Title_Original,Title_English FROM corpus_work  WHERE idCorpus_Work=?";
    	Vector<Object> ps = new Vector<Object>(1);
    	ps.add(new Integer(wid));
    	Element work = xmlQueryPreparedStatement(sql, "work", ps); 

    	sql = "SELECT * FROM petium WHERE WorkID=? ORDER BY Porder";
    	ps = new Vector<Object>(1);
    	ps.add(new Integer(wid));
    	Element petia = xmlQueryPreparedStatement(sql, "petia", ps); 
    	
    	Elements recs = petia.getChildElements("record");
    	Iterator<Element> rit = recs.iterator();
    	while(rit.hasNext()) {
    		Element rec = rit.next();
    		String pid = rec.getFirstChildElement("idpetium").getValue();
    		rec.appendChild( GetPetiumTranslations(pid));
    	}
    	
    	
    	work.appendChild(petia);
    	
    	return work;
    }
    
    public Element GetPetiumTranslations(String pid) {
    	String sql = "SELECT * FROM petium_translation  WHERE id_petium=?";
    	Vector<Object> ps = new Vector<Object>(1);
    	ps.add(new Integer(pid));
    	return xmlQueryPreparedStatement(sql, "translation", ps); 
    }
    
 
    public Element GetWorks() {
    	String sql = "SELECT * FROM corpus_work ORDER BY Title_English";
 
	    return xmlQueryData(sql,"works");
    }
    
    public Element GetLanguages() {
    	String sql = "SELECT * FROM corpus_language ORDER BY LanguageName";
 
	    return xmlQueryData(sql,"languages");
    }
    
    public int AddWorkPetium(String wid, String bt, String ali, String orig, String tran, String por, String adm, String lng, String notes) {
    	int rtn = -1;
    	
    	String sql = "INSERT INTO petium (WorkID,BlockType,alignType,FormattedText,PlainText,Porder,Notes) "
    			+"VALUES(?,?,?,?,?,?,?)";
    	
    	Vector<Object> p3 = new Vector<Object>(7);
    	p3.add(new Integer(wid));
    	p3.add(bt);
		p3.add(ali);
		p3.add(orig);
		p3.add(orig);
		p3.add(new Integer(por));
		p3.add(notes);
		rtn = addRecord(sql, p3);
		
		sql = "INSERT INTO petium_translation (id_petium,FormattedText,PlainText,Translator,Lng,alignType) "
				+"VALUES(?,?,?,?,?,?)";
		
		 p3 = new Vector<Object>(6);
	    	p3.add(new Integer(rtn));
	    	p3.add(tran);
			p3.add(tran);
			p3.add(new Integer(adm));
			p3.add(new Integer(lng));
			p3.add(ali);
			rtn = addRecord(sql, p3);
			
		sql = "UPDATE petium SET Porder=Porder+1 WHERE WorkID=? AND idpetium <> ?";
		p3 = new Vector<Object>(2);
		p3.add(new Integer(wid));
    	p3.add(new Integer(rtn));
    	rtn = addRecord(sql, p3);
    	
    	
    	return rtn;
    }
    
    
    public int EditWorkPetium(String wid, String pid, String bt, String ali, String orig, String tran, String wpor, String por, String adm, String lng, String notes) {
    	int rtn = -1;
    	
    	String sql = "UPDATE petium SET BlockType=?,alignType=?,FormattedText=?,PlainText=?,Porder=?,Notes=?) "
    			+"WHERE idpetium=?";
    	
    	Vector<Object> p3 = new Vector<Object>(7);
    	
    	p3.add(bt);
		p3.add(ali);
		p3.add(orig);
		p3.add(orig);
		p3.add(new Integer(por));
		p3.add(notes);
		p3.add(new Integer(pid));
		rtn = addRecord(sql, p3);
		
		sql = "UPDATE petium_translation SET FormattedText=?,PlainText=?,alignType=?) "
				+"WHERE id_petium=?";
		
		 p3 = new Vector<Object>(4);
	    	
	    	p3.add(tran);
			p3.add(tran);
			p3.add(ali);
			p3.add(new Integer(pid));
			rtn = addRecord(sql, p3);
			
		int p = Integer.parseInt(por);
		int wp = Integer.parseInt(wpor);
    	
		if(wp < p) {
			sql = "UPDATE petium SET Porder=Porder-1 WHERE WorkID=? AND Porder > ? AND Porder <= ? AND idpetium <> ?";
			p3 = new Vector<Object>(4);
		    p3.add(new Integer(wid));
		    p3.add(new Integer(wp));
		    p3.add(new Integer(p));
		    p3.add(new Integer(pid));
			rtn = addRecord(sql, p3);
		}
		
		if(wp > p) {
			sql = "UPDATE petium SET Porder=Porder+1 WHERE WorkID=? AND Porder >= ? AND Porder < ? AND idpetium <> ?";
			p3 = new Vector<Object>(4);
		    p3.add(new Integer(wid));
		    p3.add(new Integer(p));
		    p3.add(new Integer(wp));
		    p3.add(new Integer(pid));
			rtn = addRecord(sql, p3);
		}
		
    	
    	return rtn;
    }
    
    public int RemoveWorkPetium(String pid) {
    	int rtn = -1;
    	String sql = "SELECT Porder FROM petium WHERE idpetium=?";
    	Vector<Object> p3 = new Vector<Object>(1);
    	p3.add(new Integer(pid));
    	int por = QueryIntPS(sql, p3);
    	
    	sql = "SELECT WorkID FROM petium WHERE idpetium=?";
    	p3.add(new Integer(pid));
    	int wid = QueryIntPS(sql, p3);
    	
    	sql = "DELETE FROM petium_translation WHERE id_petium=?";
    	rtn = addRecord(sql, p3);
    	
    	if(rtn > 0) {
    		sql = "DELETE FROM petium WHERE idpetium=?";
    		rtn = addRecord(sql, p3);
    	
    		sql = "UPDATE petium SET Porder=Porder-1 WHERE WorkID=? AND Porder > ?";
    		p3 = new Vector<Object>(1);
        	p3.add(new Integer(wid));
        	p3.add(new Integer(por));
        	rtn = addRecord(sql, p3);
    	
    	}
    	
    	
    	
    	
    	return rtn;
    	
    	
    }
    
    
    public int AddWork(String et, String ot, String ea, String oa, String cite, int uid, int lang) {
    	int rtn = -1;
    	
    	String sql = "INSERT INTO corpus_work "
    			+"(Title_English,Title_Original,Author_English,Author_Original,Citation,AddedBy,Language_Original) "
    				+"VALUES(?,?,?,?,?,?,?)";
    	
    	Vector<Object> p3 = new Vector<Object>(7);
    	p3.add(et);
    	p3.add(ot);
		p3.add(ea);
		p3.add(oa);
		p3.add(cite);
		p3.add(new Integer(uid));
		p3.add(new Integer(lang));
		
		rtn = addRecord(sql, p3);  
    	
    	
    	return rtn;
    }
    
    public int UpdateWorkDetails(String wid, String et, String ot, String ea, String oa, String cite, String sta) {
    	int rtn = -1;
    	
    	String sql = "UPDATE corpus_work "
    			+"SET Title_English=?,Title_Original=?,Author_English=?,Author_Original=?,Citation=?, "
    			+"AddedBy=?,Language_Original=? WHERE idCorpus_Work=? ";
    	
    	Vector<Object> p3 = new Vector<Object>(7);
    	p3.add(et);
    	p3.add(ot);
		p3.add(ea);
		p3.add(oa);
		p3.add(cite);
		p3.add(new Integer(sta));
		p3.add(new Integer(wid));
		
		rtn = addRecord(sql, p3);  
    	
    	
    	return rtn;
    }
    
    
}

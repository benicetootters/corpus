package edu.bowdoin.corpus;

import java.security.MessageDigest;
import java.util.Vector;

import javax.sql.DataSource;
import javax.xml.bind.DatatypeConverter;

import org.apache.logging.log4j.Logger;
import edu.bowdoin.nova.*;
import nu.xom.Element;

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
    
 
    public Element GetWorks() {
    	String sql = "SELECT * FROM corpus_work ORDER BY Title_English";
 
	    return xmlQueryData(sql,"works");
    }
    
    public Element GetLanguages() {
    	String sql = "SELECT * FROM corpus_language ORDER BY LanguageName";
 
	    return xmlQueryData(sql,"languages");
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
    
    
}

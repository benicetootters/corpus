package edu.bowdoin.corpus;

import java.security.MessageDigest;

import javax.xml.bind.DatatypeConverter;

public class Tester {

	public static void main(String[] args) {
		
		String pwd = "zero1";
		try {
		MessageDigest md = MessageDigest.getInstance("MD5");
		md.update(pwd.getBytes());
		byte[] digest = md.digest();
		String myHash = DatatypeConverter.printHexBinary(digest);
		System.out.println(myHash);
		} catch(Exception e) {
			System.out.println("E: "+e);
		}
	}

}

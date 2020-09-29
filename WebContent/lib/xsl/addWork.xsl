<?xml version="1.1" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:param name="uid" />
    <xsl:template match="/languages">
    <div>
		<h1>Add a Work</h1>
		<form method="post" action="mvc.jsp">
			<input type="hidden" name="m" value="addWork" />
			<input type="hidden" name="uid" value="{$uid}" />
			<table>
				<tr>
					<td>Language</td>
					<td>
						<select name="lang">
							<xsl:for-each select="record[LanguageName='Arabic']">
								<option value="{idcorpus_language}"><xsl:value-of select="LanguageName" /></option>
							</xsl:for-each>
						</select>				
					</td>
				</tr>
				<tr>
					<td>Title (Original Language)</td>
					<td><input class="rtl" type="text" name="ot" size="70" /></td>
				</tr>
				<tr>
					<td>Title (English)</td>
					<td><input type="text" name="et" size="70" /></td>
				</tr>
				<tr>
					<td>Author(s) (Original Language)</td>
					<td><input class="rtl" type="text" name="oa" size="70" /></td>
				</tr>
				<tr>
					<td>Author(s) (English)</td>
					<td><input type="text" name="ea" size="70" /></td>
				</tr>
				<tr>
					<td>Citation Information</td>
					<td><textarea name="cite" rows="3" cols="70"><xsl:text>&#160;</xsl:text></textarea></td>
				</tr>
			</table>
			
			<input type="submit" value="Add Work" />
		
		</form>
	
	

	</div>
</xsl:template>
</xsl:stylesheet>
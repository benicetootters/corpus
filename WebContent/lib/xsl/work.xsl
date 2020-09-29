<?xml version="1.1" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:template match="/work">

    <div id="work">
    	<h2><span class="rtl"><xsl:value-of select="record/Title_Original" /></span>
    		(<xsl:value-of select="record/Title_English" />) <button type="button" id="deets">Update details</button>
    	</h2>
    	<a target="_V" href="ViewWork.jsp?wid={record/idCorpus_Work}">View</a>
    	<hr />
    
	<table id="tbox">
		<thead>
			<tr>
				<th>Block Type</th>
				<th>Alignment</th>
				<th>Original</th>
				<th>Translation</th>
				<th>Position</th>
				<th><xsl:text> </xsl:text></th>
			</tr>
		</thead>
		<tbody>
		<xsl:for-each select="petia/record">
		<tr>
			<td style="width:40px;text-align:center;font-weight:bold;">
				<xsl:value-of select="BlockType" />
			</td>
			<td style="width:40px;text-align:center;font-weight:bold;">
				<xsl:value-of select="alignType" />
			</td>
			<td class="rtl">
				<span class="{BlockType} {alignType}">
					<xsl:value-of select="PlainText" />&#x200E;
				</span>
			</td>
			<td>
				<span class="{BlockType} {alignType}">
					<xsl:value-of select="translation/record/PlainText" />
				</span>
			</td>
			<td style="width:30px;text-align:center;font-weight:bold;">
				<xsl:value-of select="Porder" />
			</td>
			<td style="width:60px;text-align:center;cursor:pointer;" class="tak" data="{idpetium}">
				<i class="fas fa-edit"><xsl:text> </xsl:text></i>
			</td>
		</tr>
	</xsl:for-each>
		
		</tbody>
	
	
	</table>
	
	<div id="edeets" style="display:none;" title="Update Work Details">
		<form method="post" action="mvc.jsp">
			<input type="hidden" name="wid" value="{record/idCorpus_Work}" />
			<input type="hidden" name="m" value="updDetails" />
			
			<h3>Status</h3>
				<select name="sta">
					<option value="1">
						<xsl:if test="record/Status=1">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						Active					
					</option>
					<option value="-1">
						<xsl:if test="record/Status=-1">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						Inactive
					</option>
				
				</select>
			
			<h3>Original Title</h3>
			<input type="text" class="rtl" name="ot" value="{record/Title_Original}" />
			
			<h3>English Title</h3>
			<input type="text" name="et" value="{record/Title_English}" />
			
			<h3>Author Original</h3>
			<input type="text" class="rtl" name="oa" value="{record/Author_Original}" />
			
			<h3>Author English</h3>
			<input type="text" name="ea" value="{record/Author_English}" />
			
			<h3>Citation</h3>
			<textarea name="cite" rows="3" cols="50">
				<xsl:value-of select="record/Citation" />
				<xsl:text> </xsl:text>
			</textarea>
			<br /><br />
			<button type="submit">Update</button>
		</form>
	</div>
	
</div>
	

</xsl:template>
</xsl:stylesheet>
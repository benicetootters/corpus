<?xml version="1.1" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:template match="/works">
    <div id="wlist">
	<h1>Works</h1>
	
	<xsl:if test="count(record)=0"><em>No works available</em></xsl:if>
	<ul>
	<xsl:for-each select="record">
		<li><em><xsl:value-of select="Title_English" /></em>. <xsl:value-of select="Author_English" />
			<a style="padding-left:1rem;font-size:1.32rem;" href="Work.jsp?wid={idCorpus_Work}"><i class="fas fa-edit"><xsl:text> </xsl:text></i></a><br />
			<span class="rtl"><xsl:value-of select="Title_Original" /><br />
			<xsl:value-of select="Author_Original" /></span>
			
		</li>
	</xsl:for-each>
	</ul>
	</div>
</xsl:template>
</xsl:stylesheet>
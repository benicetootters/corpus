<?xml version="1.1" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:template match="/works">
    <div>
	<h1>Works</h1>
	
	<xsl:if test="count(record)=0"><em>No works available</em></xsl:if>

	<xsl:for-each select="record">
		<div class="wentry">
			<div class="t">
				<a class="view" title="View" href="ViewWork.jsp?wid={idCorpus_Work}"><i class="fab fa-readme"><xsl:text> </xsl:text></i></a>
				<h3><xsl:value-of select="Title_English" /></h3>
				<p><xsl:value-of select="Author_English" /></p>
			</div>
			<div class="o">
				<h3 class="rtl"><xsl:value-of select="Title_Original" /></h3>
				<p class="rtl"><xsl:value-of select="Author_Original" /></p>
			</div>
			<div class="cite"><xsl:value-of select="Citation" /><xsl:text>&#160;</xsl:text></div>
			
			
			<p style="text-align:right;"><em>translation by <xsl:value-of select="firstname" /> <xsl:text> </xsl:text><xsl:value-of select="lastname" /></em></p>
		</div>
	</xsl:for-each>

	</div>
</xsl:template>
</xsl:stylesheet>
<?xml version="1.1" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" encoding="UTF-8" indent="yes" />
    <xsl:template match="/work">

    <div id="work">
    	<h2><span class="rtl"><xsl:value-of select="record/Title_Original" /></span>
    		(<xsl:value-of select="record/Title_English" />) 
    	</h2>
    	<hr />
    
    	<div id="study">
			<div id="orig">	
				<xsl:for-each select="petia/record">
					<span class="petiumo {BlockType} {alignType}" id="o{idpetium}">
						<xsl:value-of select="PlainText" />&#x200E;
					</span>
				</xsl:for-each>
			</div>
			
			<div id="tran">
				<xsl:for-each select="petia/record">
					<span class="petiumt {BlockType} {alignType}" id="t{idpetium}">
						<xsl:value-of select="translation/record/PlainText" />
						<xsl:if test="petiumNotes!=''">
							<sup><i 
								title="{petiumNotes}"
							class="far fa-sticky-note"><xsl:text> </xsl:text></i></sup>
						</xsl:if>
						<xsl:text> &#x20;</xsl:text>
					</span>
				</xsl:for-each>
			</div>
		</div>

</div>
	

</xsl:template>
</xsl:stylesheet>
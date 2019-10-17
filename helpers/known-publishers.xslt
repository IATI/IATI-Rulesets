<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:json="http://www.w3.org/2005/xpath-functions"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="json functx"
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:include href="../lib/functx.xslt"/>
  
  <xsl:template match="/">
    <codelist>
      <xsl:apply-templates select="json-to-xml(unparsed-text('../tmp/iati-publishers.json'))//json:string[@key=('iati_id') and functx:trim(.)!='']">
        <xsl:sort select="functx:trim(.)"/>    
      </xsl:apply-templates>  
    </codelist>
  </xsl:template>

  <xsl:template match="json:string">
    <code>{functx:trim(.)}</code>
  </xsl:template>

</xsl:stylesheet>

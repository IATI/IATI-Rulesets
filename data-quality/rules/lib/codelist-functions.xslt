<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  expand-text="yes"
  version="3.0">

  <xsl:variable name="codelists">
    <xsl:apply-templates select="collection('../../../lib/schemata/' || $iati-version || '/codelist/?select=*.xml;recurse=yes')" mode="get-codelists"/>
  </xsl:variable>
  
  <xsl:template match="codelist" mode="get-codelists">
    <xsl:copy>
      <xsl:copy select="@name"/>
      <xsl:apply-templates select="//code" mode="get-codelists"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="code" mode="get-codelists">
    <xsl:copy>{.}</xsl:copy>
  </xsl:template>  
  
  <xsl:function name="me:codeListFail" as="xs:boolean">
    <xsl:param name="code"/>
    <xsl:param name="codelist"/>
    <xsl:sequence select="$code and $codelists/codelist[@name=$codelist] and not(($code, lower-case($code), upper-case($code))=$codelists/codelist[@name=$codelist]/code)"/>
  </xsl:function>
  
</xsl:stylesheet>

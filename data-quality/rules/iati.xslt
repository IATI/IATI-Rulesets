<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  xmlns:saxon="http://saxon.sf.net/"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:param name="filename"/>
  
  <xsl:variable name="schemaVersion">0.11.5</xsl:variable>
  
  <!-- support functions and templates -->
  <xsl:include href="../../lib/functx.xslt"/>
  <xsl:include href="lib/codelist-functions.xslt"/>
  <xsl:include href="lib/identifiers.xslt"/>
  <xsl:include href="lib/percentages.xslt"/>
  
  <!-- IATI rules -->
  <xsl:include href="iati/technical.xslt"/>
  <xsl:include href="iati/codelists.xslt"/>
  <xsl:include href="iati/sectors.xslt"/>
  <xsl:include href="iati/identifiers.xslt"/>
  <xsl:include href="iati/extra-documentation/geography.xslt"/>
  <xsl:include href="iati/language.xslt"/>
  <xsl:include href="iati/traceability.xslt"/>
  <xsl:include href="iati/information.xslt"/>
  <xsl:include href="iati/financial.xslt"/>
  <xsl:include href="iati/results.xslt"/>
  <xsl:include href="iati/dates.xslt"/>

  <xsl:output indent="yes"/>
  
  <xsl:variable name="iati-version-declared" select="//(iati-activities|iati-organisations)[1]/@version"/>
  <xsl:variable name="iati-version-valid"
      select="$iati-version-declared=('1.01','1.02','1.03','1.04','1.05','2.01','2.02','2.03')"/>
  <xsl:variable name="iati-version">
    <xsl:choose>
      <xsl:when test="$iati-version-valid">{$iati-version-declared}</xsl:when>
      <xsl:when test="starts-with($iati-version-declared, '1.')">1.05</xsl:when>
      <xsl:otherwise>2.03</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:function name="me:iati-url">
    <xsl:param name="href"/>
    <xsl:if test="$href!=''">http://reference.iatistandard.org/{replace($iati-version, '\.', '')}/{$href}</xsl:if>
  </xsl:function>
    
<!--  <xsl:variable name="validation-errors" select="saxon:validate(/)"/>-->
  
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:if test="name(.)='iati-identifier'">
        <xsl:attribute name="me:id">{iati-identifier}</xsl:attribute>  
      </xsl:if>
      <xsl:if test="name(.)=('iati-activities', 'iati-organisations')">
        <xsl:attribute name="me:schemaVersion">{$schemaVersion}</xsl:attribute>  
        <xsl:attribute name="me:iatiVersion">{$iati-version}</xsl:attribute>  
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
      <xsl:apply-templates select="@*" mode="rules"/>
      <xsl:apply-templates select="." mode="rules"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="rules"/>

</xsl:stylesheet>

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
  <xsl:include href="iati/percentages.xslt"/>

  <xsl:output indent="yes"/>
  
  <xsl:function name="me:iati-url">
    <xsl:param name="href"/>
    <xsl:if test="$href!=''">http://reference.iatistandard.org/{replace($iati-version, '\.', '')}/{$href}</xsl:if>
  </xsl:function>

  <xsl:function name="me:iati-version">
    <xsl:param name="declared-version"/>

    <xsl:choose>
      <xsl:when test="$declared-version=('1.01','1.02','1.03','1.04','1.05','2.01','2.02','2.03')">{$declared-version}</xsl:when>
      <xsl:when test="starts-with($declared-version, '1.')">1.05</xsl:when>
      <xsl:otherwise>2.03</xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
<!--  <xsl:variable name="validation-errors" select="saxon:validate(/)"/>-->
  
  <xsl:template match="@*|node()">
    <xsl:param name="iati-version" tunnel="yes"/>
    <xsl:copy>
      <xsl:variable name="use-iati-version">
        <xsl:choose>
          <xsl:when test="name(.)=('iati-activities', 'iati-organisations')">{me:iati-version(@version)}</xsl:when>
          <xsl:when test="$iati-version">{$iati-version}</xsl:when>
          <xsl:otherwise>2.03</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="name(.)=('iati-activities', 'iati-organisations')">
        <xsl:attribute name="me:id">{iati-identifier}</xsl:attribute>  
        <xsl:attribute name="me:schemaVersion">{$schemaVersion}</xsl:attribute>  
        <xsl:attribute name="me:iatiVersion">{$use-iati-version}</xsl:attribute>  
      </xsl:if>
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="@*" mode="rules">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="." mode="rules">
        <xsl:with-param name="iati-version" select="$use-iati-version" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="@*|node()" mode="rules"/>

</xsl:stylesheet>

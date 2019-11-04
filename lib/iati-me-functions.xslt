<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  expand-text="yes">
  
  <xsl:function name="me:iati-url">
    <xsl:param name="href"/>
    <!-- TODO include iati-version in function call to use proper version -->
    <xsl:variable name="iati-version">2.03</xsl:variable>
    <xsl:choose>
      <xsl:when test="starts-with($href, 'http')"></xsl:when>
      <xsl:when test="$href!=''">https://reference.iatistandard.org/{replace($iati-version, '\.', '')}/{$href}</xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xsl:function name="me:iati-version">
    <xsl:param name="declared-version"/>
    
    <xsl:choose>
      <xsl:when test="$declared-version=('1.01','1.02','1.03','1.04','1.05','2.01','2.02','2.03')">{$declared-version}</xsl:when>
      <xsl:when test="starts-with($declared-version, '1.')">1.05</xsl:when>
      <xsl:otherwise>2.03</xsl:otherwise>
    </xsl:choose>    
  </xsl:function>
  
</xsl:stylesheet>

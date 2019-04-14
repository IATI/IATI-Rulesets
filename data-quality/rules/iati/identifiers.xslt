<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <!-- Checks on the identifiers of organisations or activities -->

  <xsl:template match="iati-organisation/iati-identifier" mode="rules" priority="1.13">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.13</xsl:with-param>
      <xsl:with-param name="versions">1.0x</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    

  <xsl:template match="organisation-identifier" mode="rules" priority="1.12">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.12</xsl:with-param>
      <xsl:with-param name="versions">2.0x</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
    
  <xsl:template match="reporting-org/@ref" mode="rules" priority="1.14">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.14</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="participating-org/@ref" mode="rules" priority="1.8">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.8</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="provider-org/@ref" mode="rules" priority="1.10">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.10</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="receiver-org/@ref" mode="rules" priority="1.15">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.15</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
  
  <xsl:template match="owner-org/@ref" mode="rules" priority="1.11">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.11</xsl:with-param>
    </xsl:call-template>
  </xsl:template>    
</xsl:stylesheet>

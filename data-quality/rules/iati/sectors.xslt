<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="iati-activity[sector]" mode="rules" priority="2.1">
    
    <!-- Check for percentages for multiple sector codes for the default vocabulary. -->    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="sector[not(@vocabulary) or @vocabulary=('', '1')]"/>
      <xsl:with-param name="class" select="'classifications'"/>
      <xsl:with-param name="idclass" select="'2.1'"/>
      <xsl:with-param name="item" select="'sector'"/>
      <xsl:with-param name="items" select="'sectors'"/>
      <xsl:with-param name="vocabulary" select="'1'"/>
      <xsl:with-param name="href" select="'activity-standard/iati-activities/iati-activity/sector/'"/>
    </xsl:call-template>
    
    <!-- Check for multiple sector codes per vocabulary. -->
    <xsl:for-each-group select="sector" group-by="@vocabulary">
      <xsl:if test="not(current-grouping-key()=('', '1'))">
        <xsl:call-template name="percentage-checks">
          <xsl:with-param name="group" select="current-group()"/>
          <xsl:with-param name="class" select="'classifications'"/>
          <xsl:with-param name="idclass" select="'2.1'"/>
          <xsl:with-param name="item" select="'sector'"/>
          <xsl:with-param name="items" select="'sectors'"/>
          <xsl:with-param name="vocabulary" select="current-grouping-key()"/>
          <xsl:with-param name="href" select="'activity-standard/iati-activities/iati-activity/sector/'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each-group>

    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>  

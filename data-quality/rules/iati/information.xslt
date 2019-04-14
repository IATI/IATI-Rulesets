<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:template match="iati-activity[sector]" mode="rules" priority="6.6">
    <xsl:if test="transaction/sector">
      <me:feedback type="error" class="classifications" id="6.6.2">
        <me:src ref="iati" versions="any"/>
        <me:message>If the activity has a sector classification, none of the transactions should have a sector classification.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[not(sector)]" mode="rules" priority="6.7">
    <xsl:choose>
      <xsl:when test="not(transaction[sector])">
        <me:feedback type="error" class="classifications" id="6.2.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The activity should have a sector classification for either the activity or for all transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(sector)]">
        <me:feedback type="error" class="classifications" id="6.7.2">
          <me:src ref="iati" versions="any"/>
          <me:message>If transactions have a sector classification, they must be used for all transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
    
</xsl:stylesheet>

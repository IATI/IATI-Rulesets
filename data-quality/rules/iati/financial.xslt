<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template match="forecast" mode="rules" priority="7.8">
    <xsl:if test="(not(@currency) or currency='')
      and (not(ancestor::iati-activity/@default-currency) or ancestor::iati-activity/@default-currency='')">
      <me:feedback type="danger" class="financial" id="7.8.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The value has no currency and there is no default currency for this activity.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>

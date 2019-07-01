<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  version="3.0"
  expand-text="yes">
  
  <xsl:template match="(recipient-country|recipient-region)[@percentage]" mode="rules" priority="12.1">
    <xsl:param name="iati-version" tunnel="yes"/>

    <xsl:if test="$iati-version = '2.03' and
      @percentage castable as xs:decimal and
      (xs:decimal(@percentage) lt 0 or xs:decimal(@percentage) gt 100)">
      <me:feedback type="danger" class="geo" id="12.1.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The percentage must be between 0.0 and 100.0 (inclusive).</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="$iati-version ne '2.03' and
      @percentage castable as xs:decimal and
      xs:decimal(@percentage) lt 0">
      <me:feedback type="danger" class="geo" id="12.1.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The percentage must be 0.0 or positive.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="capital-spend[@percentage]" mode="rules" priority="12.2">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version = '2.03' and
      @percentage castable as xs:decimal and
      (xs:decimal(@percentage) lt 0 or xs:decimal(@percentage) gt 100)">
      <me:feedback type="danger" class="financial" id="12.2.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The percentage must be between 0.0 and 100.0 (inclusive).</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="$iati-version ne '2.03' and
      @percentage castable as xs:decimal and
      xs:decimal(@percentage) lt 0">
      <me:feedback type="danger" class="financial" id="12.2.2">
        <me:src ref="iati" versions="any"/>
        <me:message>The percentage must be 0.0 or positive.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>
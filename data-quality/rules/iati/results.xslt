<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:template match="baseline/@value|target/@value|actual/@value" mode="rules" priority="8.5">
    <xsl:if test="ancestor::result/@aggregation-status castable as xs:boolean and xs:boolean(ancestor::result/@aggregation-status) and not(. castable as xs:decimal)">
      <me:feedback type="danger" class="performance" id="8.5.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The {name(..)} value is not a number but the indicator is part of a result that can be aggregated.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>    
    
  <xsl:template match="period" mode="rules" priority="8.6">
    
    <xsl:if test="period-start/@iso-date gt period-end/@iso-date">
      <me:feedback type="danger" class="performance" id="8.6.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The start of the period must be before the end of the period.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="budget|total-budget|total-expenditure|recipient-org-budget|recipient-country-budget|recipient-region-budget|planned-disbursement" mode="rules" priority="8.7">
    
    <xsl:if test="period-start/@iso-date gt period-end/@iso-date">
      <me:feedback type="danger" class="financial" id="8.6.3">
        <me:src ref="iati" versions="any"/>
        <me:message>The start of the period is after the end of the period.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="baseline[../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.8">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="not(@value)">
        <me:feedback type="danger" class="performance" id="8.8.1">
          <me:src ref="iati" versions="2.03"/>
          <me:message>The baseline must have a value when indicator measure is unit (1), percentage (2), nominal (3) or ordinal (4).</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="target[../../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.9">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="not(@value)">
        <me:feedback type="danger" class="performance" id="8.9.1">
          <me:src ref="iati" versions="2.03"/>
          <me:message>The target must have a value when indicator measure is unit (1), percentage (2), nominal (3) or ordinal (4).</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="actual[../../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.10">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="not(@value)">
        <me:feedback type="danger" class="performance" id="8.10.1">
          <me:src ref="iati" versions="2.03"/>
          <me:message>The actual must have a value when indicator measure is unit (1), percentage (2), nominal (3) or ordinal (4).</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="indicator[reference]" mode="rules" priority="8.11">
    
    <xsl:if test="../reference">
      <me:feedback type="danger" class="performance" id="8.11.1">
        <me:src ref="iati" versions="any"/>
        <me:message>If a result has a reference code, the indicator must not have a reference code.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

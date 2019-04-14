<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  version="3.0"
  expand-text="yes">
  
  <xsl:variable name="now" select="current-dateTime()"/>
  
  <xsl:template match="iati-activity" mode="rules" priority="11.1">
    <xsl:if test="@last-updated-datetime gt $now">
      <me:feedback type="danger" class="information" id="11.1.1">
        <me:src ref="iati"/>
        <me:message>The last-updated-datetime of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='1']/@iso-date gt activity-date[@type='3']/@iso-date">
      <me:feedback type="danger" class="information" id="11.1.2">
        <me:src ref="iati"/>
        <me:message>The planned start date must be before the planned end date.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='2']/@iso-date gt activity-date[@type='4']/@iso-date">
      <me:feedback type="danger" class="information" id="11.1.3">
        <me:src ref="iati"/>
        <me:message>The actual start date must be before the actual end date.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='2']/@iso-date gt $now">
      <me:feedback type="danger" class="information" id="11.1.4">
        <me:src ref="iati"/>
        <me:message>The actual start date of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="activity-date[@type='4']/@iso-date gt $now">
      <me:feedback type="danger" class="information" id="11.1.5">
        <me:src ref="iati"/>
        <me:message>The actual end date of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="transaction" mode="rules" priority="11.2">
    <xsl:if test="transaction-date/@iso-date gt $now">
      <me:feedback type="danger" class="financial" id="11.2.1">
        <me:src ref="iati"/>
        <me:message>The transaction date must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="value/@value-date gt $now">
      <me:feedback type="danger" class="financial" id="11.2.1">
        <me:src ref="iati"/>
        <me:message>The transaction value date must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>    
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="recipient-country-budget" mode="rules" priority="11.3">
    <xsl:if test="budget-line/value/@value-date lt period-start/@iso-date or budget-line/value/@value-date gt period-end/@iso-date">
      <me:feedback type="danger" class="financial" id="11.3.1">
        <me:src ref="iati"/>
        <me:message>The budget line value date is not in the budget period.</me:message>
      </me:feedback>
    </xsl:if>
  </xsl:template>
  
  <xsl:next-match/>
</xsl:stylesheet>
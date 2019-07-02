<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:template match="iati-activity[sector]" mode="rules" priority="6.6">
    <xsl:if test="transaction/sector">
      <me:feedback type="danger" class="classifications" id="6.6.2">
        <me:src ref="iati" versions="any"/>
        <me:message>If the activity has a sector classification, none of the transactions should have a sector classification.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[not(sector)]" mode="rules" priority="6.7">
    <xsl:choose>
      <xsl:when test="not(transaction[sector])">
        <me:feedback type="danger" class="classifications" id="6.2.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The activity should have a sector classification for either the activity or for all transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(sector)]">
        <me:feedback type="danger" class="classifications" id="6.7.2">
          <me:src ref="iati" versions="any"/>
          <me:message>If transactions have a sector classification, they must be used for all transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="owner-org" mode="rules" priority="6.8">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="information" id="6.8.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The owner organisation must have an identifier or a narrative name.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="provider-org|receiver-org" mode="rules" priority="6.9">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="financial" id="6.9.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The organisation must have an identifier or a narrative name.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="participating-org" mode="rules" priority="6.10">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="participating" id="6.10.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The participating organisation must have an identifier or a narrative name.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!-- activity status and dates -->
  <xsl:template match="iati-activity" mode="rules" priority="6.11">
    <xsl:if test="not(activity-date[@type=('1', '2')])">
      <me:feedback type="danger" class="information" id="6.11.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The activity must have a planned or actual start date.</me:message>
      </me:feedback>      
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[activity-status/@code='1']" mode="rules" priority="6.12">
    <xsl:if test="boolean(activity-date[@type='2'])">
      <me:feedback type="danger" class="information" id="6.12.1">
        <me:src ref="iati" versions="any"/>
        <me:message>A activity in status pipeline/identification must not have an actual start date.</me:message>
      </me:feedback>      
    </xsl:if>

    <xsl:if test="boolean(activity-date[@type='4'])">
      <me:feedback type="danger" class="information" id="6.12.2">
        <me:src ref="iati" versions="any"/>
        <me:message>A activity in status pipeline/identification must not have an actual end date.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="policy-marker[@vocabulary=('99')]" mode="rules" priority="6.13">
    <xsl:if test="not(narrative)">
      <me:feedback type="danger" class="classifications" id="6.13.1">
        <me:src ref="iati" versions="any"/>
        <me:message>When using a reporting organisation policy marker, it must include a narrative name.</me:message>
      </me:feedback>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

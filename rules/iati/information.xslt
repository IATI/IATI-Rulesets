<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <xsl:template match="document-link[ancestor::iati-activity[not(@xml:lang)]]" mode="rules" priority="6.1"> 
    <xsl:if test="not(language) or not(language/@code) or language/@code=''">
      <me:feedback type="danger" class="documents" id="6.1.4">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1TI9PU5dyyRE2IzervFPUZz_Xfue16xYC/view?usp=sharing"/>
        <me:message>Document Link must have a specified language, or the Activity must have a default language.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="document-link[ancestor::iati-organisation[not(@xml:lang)]]" mode="rules" priority="6.16"> 
    <xsl:if test="not(language) or not(language/@code) or language/@code=''">
      <me:feedback type="danger" class="documents" id="6.16.4">
        <me:src ref="iati" versions="any"/>
        <me:message>Document Link must have a specified language, or the Organisation must have a default language.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="document-link" mode="rules" priority="6.15"> 
    <xsl:if test="not(@format) or @format=''">
      <me:feedback type="danger" class="documents" id="6.1.5">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1TI9PU5dyyRE2IzervFPUZz_Xfue16xYC/view?usp=sharing"/>
        <me:message>The document format must be present.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>  
  
  <xsl:template match="iati-activity" mode="rules" priority="6.2">
    <xsl:if test="not(activity-status)">
      <me:feedback type="danger" class="information" id="6.2.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>Activity Status must be present.</me:message>
      </me:feedback>
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[sector]" mode="rules" priority="6.6">
    <xsl:if test="transaction/sector">
      <me:feedback type="danger" class="classifications" id="6.6.2">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1GNnjeqDIyWwuuIkJ8pMjLhE99R_olSJP/view"/>
        <me:message>Sectors are present at both the activity AND transaction level. Sectors should only be present at activity OR transaction level.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[not(sector)]" mode="rules" priority="6.7">
    <xsl:choose>
      <xsl:when test="not(transaction[sector])">
        <me:feedback type="danger" class="classifications" id="6.2.2">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1GNnjeqDIyWwuuIkJ8pMjLhE99R_olSJP/view"/>
          <me:message>Each activity must have a specified Sector Classification, at either activity level, or for ALL transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(sector)]">
        <me:feedback type="danger" class="classifications" id="6.7.2">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1GNnjeqDIyWwuuIkJ8pMjLhE99R_olSJP/view"/>
          <me:message>If transactions have a sector classification, they must be used for all transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="reporting-org" mode="rules" priority="6.3">
    <xsl:if test="not(@type) or @type=''">
      <me:feedback type="danger" class="identification" id="6.3.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/reporting-org/')}"/>
        <me:message>Organisation Type must be present.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="owner-org" mode="rules" priority="6.8">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="information" id="6.8.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/other-identifier/owner-org/')}"/>
        <me:message>The owner organisation must have an identifier or a narrative.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="provider-org|receiver-org" mode="rules" priority="6.9">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="financial" id="6.9.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The organisation must have an identifier or a narrative.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="participating-org" mode="rules" priority="6.10">
    <xsl:if test="not(@ref) and not(narrative)">
      <me:feedback type="danger" class="participating" id="6.10.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1BOJTMbKxDZJldIBsw71mkomYPm_lkNJi/view"/>
        <me:message>The participating organisation must have an identifier or a narrative.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!-- activity status and dates -->
  <xsl:template match="iati-activity" mode="rules" priority="6.11">
    <xsl:if test="not(activity-date[@type=('1', '2')])">
      <me:feedback type="danger" class="information" id="6.11.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>The activity must have a planned or actual start date.</me:message>
      </me:feedback>      
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>

<!-- not a ruleset error, to be added later as additional?
  <xsl:template match="iati-activity[activity-status/@code='1']" mode="rules" priority="6.12">
    <xsl:if test="boolean(activity-date[@type='2'])">
      <me:feedback type="danger" class="information" id="6.12.1">
        <me:src ref="iati" versions="any"/>
        <me:message>An activity in status pipeline/identification must not have an actual start date.</me:message>
      </me:feedback>      
    </xsl:if>

    <xsl:if test="boolean(activity-date[@type='4'])">
      <me:feedback type="danger" class="information" id="6.12.2">
        <me:src ref="iati" versions="any"/>
        <me:message>An activity in status pipeline/identification must not have an actual end date.</me:message>
      </me:feedback>      
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
-->
 
  <xsl:template match="policy-marker[@vocabulary='99']" mode="rules" priority="6.13">
    <xsl:if test="not(narrative)">
      <me:feedback type="danger" class="classifications" id="6.13.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/15JQzYc4rUNqwtP-nmtY7h9tHB2i_Isw7/view"/>
        <me:message>When using a reporting organisation policy marker, it must include a narrative.</me:message>
      </me:feedback>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="policy-marker[(@vocabulary='1') or not(@vocabulary)]" mode="rules" priority="6.14">
    <xsl:if test="not(@significance)">
      <me:feedback type="danger" class="classifications" id="6.14.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/15JQzYc4rUNqwtP-nmtY7h9tHB2i_Isw7/view"/>
        <me:message>When using a policy marker for vocabulary 1, it must include a significance.</me:message>
      </me:feedback>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

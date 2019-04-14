<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity[(recipient-country or recipient-region) and starts-with($iati-version, '1.')]" mode="rules" priority="2.2">
    <!--* When declaring multiple ``recipient-country`` or ``recipient-region`` then a ``@percentage`` must be declared.  These must sum to 100%.-->
    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-country"/>
      <xsl:with-param name="class" select="'geo'"/>
      <xsl:with-param name="idclass" select="'3.1'"/>
      <xsl:with-param name="item" select="'recipient country'"/>
      <xsl:with-param name="items" select="'recipient countries'"/>
    </xsl:call-template>
    
    <!-- Check for percentages for multiple recipient regions for the default vocabulary. -->    
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-region"/>
      <xsl:with-param name="class" select="'geo'"/>
      <xsl:with-param name="idclass" select="'3.4'"/>
      <xsl:with-param name="item" select="'recipient region'"/>
      <xsl:with-param name="items" select="'recipient regions'"/>
      <xsl:with-param name="vocabulary" select="'1'"/>
      <xsl:with-param name="iativersion" select="'1.x'"/>
    </xsl:call-template>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[recipient-country and not(recipient-region) and starts-with($iati-version, '2.')]" mode="rules" priority="2.4">
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-country"/>
      <xsl:with-param name="class" select="'geo'"/>
      <xsl:with-param name="idclass" select="'3.1'"/>
      <xsl:with-param name="item" select="'recipient country'"/>
      <xsl:with-param name="items" select="'recipient countries'"/>
      <xsl:with-param name="iativersion" select="'2.x'"/>
    </xsl:call-template>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!--* It is possible to have both a ``recipient-country`` and ``recipient-region`` in the same ``iati-activity``.  In such cases, the ``@percentage`` must be declared, and sum to 100 across both elements.-->
  <xsl:template match="iati-activity[recipient-region and starts-with($iati-version, '2.')]" mode="rules" priority="2.5">    
    <xsl:call-template name="geography-percentage-checks">
      <xsl:with-param name="group" select="recipient-country|recipient-region"/>
    </xsl:call-template>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template name="geography-percentage-checks">
    <xsl:param name="group"/>
    <xsl:param name="vocabulary" select="'1'"/>
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="$group"/>
      <xsl:with-param name="class" select="'geo'"/>
      <xsl:with-param name="idclass" select="'3.4'"/>
      <xsl:with-param name="item" select="'recipient country or region'"/>
      <xsl:with-param name="items" select="'recipient countries and regions'"/>
      <xsl:with-param name="iativersion" select="'2.x'"/>
      <xsl:with-param name="href" select="'activity-standard/overview/geography/'"/>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template match="iati-activity[recipient-country or recipient-region]" mode="rules" priority="3.6">
    <xsl:if test="transaction/recipient-country or transaction/recipient-region">
      <me:feedback type="danger" class="classifications" id="3.6.2">
        <me:src ref="iati" versions="any"/>
        <me:message>If the activity has recipient-country or recipient-region information, none of the transactions should have a recipient-country or recipient-region.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[not(recipient-country or recipient-region)]" mode="rules" priority="3.7">
    <xsl:choose>
      <xsl:when test="not(transaction[recipient-country or recipient-region])">
        <me:feedback type="danger" class="classifications" id="3.7.1">
          <me:src ref="iati" versions="any"/>
          <me:message>The activity should have recipient-country or recipient-region information for either the activity or for all transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(recipient-country or recipient-region)]">
        <me:feedback type="danger" class="classifications" id="3.7.2">
          <me:src ref="iati" versions="any"/>
          <me:message>If transactions have a recipient-country or recipient-region, they must be used for all transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>

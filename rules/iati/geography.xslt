<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity[recipient-region]" mode="rules" priority="3.4">
    <xsl:param name="iati-version" tunnel="yes"/>

    <!--* It is possible to have both a ``recipient-country`` and ``recipient-region`` in the same ``iati-activity``.  In such cases, the ``@percentage`` must be declared, and sum to 100 across both elements.-->
    <!-- Check for multiple sector codes per vocabulary. -->
    <xsl:for-each-group select="recipient-region" group-by="(@vocabulary, '1')[1]">
      <xsl:call-template name="percentage-checks">
        <xsl:with-param name="group" select="(../recipient-country, current-group())"/>
        <xsl:with-param name="class">geo</xsl:with-param>
        <xsl:with-param name="idclass">3.4</xsl:with-param>
        <xsl:with-param name="item">recipient country or region</xsl:with-param>
        <xsl:with-param name="items">recipient countries or regions</xsl:with-param>
        <xsl:with-param name="vocabulary" select="current-grouping-key()"/>
        <xsl:with-param name="versions">2.0x</xsl:with-param>
        <xsl:with-param name="href">https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view</xsl:with-param>
      </xsl:call-template>    
      
    </xsl:for-each-group>

<!--
    <xsl:if test="not(recipient-region/@vocabulary=('1','') or recipient-region[not(@vocabulary)])">
      <me:feedback type="warning" class="information" id="103.1.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1GNnjeqDIyWwuuIkJ8pMjLhE99R_olSJP/view"/>
        <me:message>The activity should also declare a region code from region vocabulary 1 - OECD DAC.</me:message>
      </me:feedback>
    </xsl:if>
-->

    <xsl:next-match/>    
  </xsl:template>

  <xsl:template match="iati-activity[(recipient-country and not(recipient-region))]"   mode="rules" priority="3.1">
    <xsl:param name="iati-version" tunnel="yes"/>
    <xsl:call-template name="percentage-checks">
      <xsl:with-param name="group" select="recipient-country"/>
      <xsl:with-param name="class">geo</xsl:with-param>
      <xsl:with-param name="idclass">3.1</xsl:with-param>
      <xsl:with-param name="item">recipient country</xsl:with-param>
      <xsl:with-param name="items">recipient countries</xsl:with-param>
      <xsl:with-param name="versions">2.0x</xsl:with-param>
      <xsl:with-param name="href">https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view</xsl:with-param>
    </xsl:call-template>
   
    <xsl:next-match/>    
  </xsl:template>
  
  <xsl:template match="iati-activity[recipient-country or recipient-region]" mode="rules" priority="3.6">
    <xsl:if test="transaction/recipient-country or transaction/recipient-region">
      <me:feedback type="danger" class="financial" id="3.6.2">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1E3hztk6gWTW5DypLELeSwW5X-Ahg0yjm/view"/>
        <me:message>Recipient countries or regions must only be declared at activity level OR for all transactions.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[not(recipient-country or recipient-region)]" mode="rules" priority="3.7">
    <xsl:choose>
      <xsl:when test="not(transaction[recipient-country or recipient-region])">
        <me:feedback type="warning" class="geo" id="3.7.1">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view"/>
          <me:message>Recipient country or recipient region should be declared for either the activity or for all transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(recipient-country or recipient-region)]">
        <me:feedback type="danger" class="geo" id="3.7.2">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view"/>
          <me:message>If a recipient country OR recipient region is declared for a transaction, they must be used for ALL transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>

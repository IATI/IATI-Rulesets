<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity[(recipient-country or recipient-region)]" mode="rules" priority="3.2">
    <xsl:param name="iati-version" tunnel="yes"/>
    <xsl:if test="starts-with($iati-version, '1.')">
      
      <!--* When declaring multiple ``recipient-country`` or ``recipient-region`` then a ``@percentage`` must be declared.  These must sum to 100%.-->
      <xsl:call-template name="percentage-checks">
        <xsl:with-param name="group" select="recipient-country"/>
        <xsl:with-param name="class">geo</xsl:with-param>
        <xsl:with-param name="idclass">3.2</xsl:with-param>
        <xsl:with-param name="item">recipient country</xsl:with-param>
        <xsl:with-param name="items">recipient countries</xsl:with-param>
        <xsl:with-param name="versions">1.0x</xsl:with-param>
        <xsl:with-param name="href">https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view</xsl:with-param>
      </xsl:call-template>
      
      <!-- Check for percentages for multiple recipient regions for the default vocabulary. -->    
      <xsl:call-template name="percentage-checks">
        <xsl:with-param name="group" select="recipient-region"/>
        <xsl:with-param name="class">geo</xsl:with-param>
        <xsl:with-param name="idclass">3.22</xsl:with-param>
        <xsl:with-param name="item">recipient country</xsl:with-param>
        <xsl:with-param name="items">recipient countries</xsl:with-param>
        <xsl:with-param name="vocabulary" select="'1'"/>
        <xsl:with-param name="versions">1.0x</xsl:with-param>
        <xsl:with-param name="href">https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view</xsl:with-param>
      </xsl:call-template>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-activity[recipient-region]" mode="rules" priority="3.4">
    <xsl:param name="iati-version" tunnel="yes"/>

    <!--* It is possible to have both a ``recipient-country`` and ``recipient-region`` in the same ``iati-activity``.  In such cases, the ``@percentage`` must be declared, and sum to 100 across both elements.-->
    <xsl:if test="starts-with($iati-version, '2.')">
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
    </xsl:if>    
    
    <xsl:if test="not(recipient-region/@vocabulary=('1','') or recipient-region[not(@vocabulary)])">
      <me:feedback type="warning" class="information" id="103.1.1">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1GNnjeqDIyWwuuIkJ8pMjLhE99R_olSJP/view"/>
        <me:message>The activity should also have a region using the OECD DAC region vocabulary.</me:message>
      </me:feedback>
    </xsl:if>
      
    <xsl:next-match/>    
  </xsl:template>

  <xsl:template match="iati-activity[(recipient-country and not(recipient-region))]"   mode="rules" priority="3.1">
    <xsl:param name="iati-version" tunnel="yes"/>
    <xsl:if test="starts-with($iati-version, '2.')">
      <xsl:call-template name="percentage-checks">
        <xsl:with-param name="group" select="recipient-country"/>
        <xsl:with-param name="class">geo</xsl:with-param>
        <xsl:with-param name="idclass">3.1</xsl:with-param>
        <xsl:with-param name="item">recipient country</xsl:with-param>
        <xsl:with-param name="items">recipient countries</xsl:with-param>
        <xsl:with-param name="versions">2.0x</xsl:with-param>
        <xsl:with-param name="href">https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view</xsl:with-param>
      </xsl:call-template>
    </xsl:if>    
    <xsl:next-match/>    
  </xsl:template>
  
  <xsl:template match="iati-activity[recipient-country or recipient-region]" mode="rules" priority="3.6">
    <xsl:if test="transaction/recipient-country or transaction/recipient-region">
      <me:feedback type="danger" class="financial" id="3.6.2">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1E3hztk6gWTW5DypLELeSwW5X-Ahg0yjm/view"/>
        <me:message>If the activity has recipient-country or recipient-region information, none of the transactions should have a recipient-country or recipient-region.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[not(recipient-country or recipient-region)]" mode="rules" priority="3.7">
    <xsl:choose>
      <xsl:when test="not(transaction[recipient-country or recipient-region])">
        <me:feedback type="danger" class="geo" id="3.7.1">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view"/>
          <me:message>The activity should have recipient-country or recipient-region information for either the activity or for all transactions.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="transaction[not(recipient-country or recipient-region)]">
        <me:feedback type="danger" class="geo" id="3.7.2">
          <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/18P3vSUKK2iWCnXCrORDVAHR8K_EIg8Pp/view"/>
          <me:message>If transactions have a recipient-country or recipient-region, they must be used for all transactions.</me:message>
        </me:feedback>
      </xsl:when>      
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>

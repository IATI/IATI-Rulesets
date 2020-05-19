<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="budget" mode="rules" priority="7.15">
    <xsl:if test="not(value/@value-date)">
      <me:feedback type="danger" class="financial" id="7.5.2">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1vB3vk7gbnADwG1S8A1bRDd8mK-nOfwCh/view?usp=drive_open"/>
        <me:message>Budget Value must include a Value Date.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
    
  <xsl:template match="budget|total-budget|total-expenditure|recipient-country-budget|recipient-region-budget|recipient-org-budget" mode="rules" priority="7.5">
    <xsl:if test="count(period-start/@iso-date)=1 and
      period-start/@iso-date castable as xs:date and
      count(period-end/@iso-date)=1 and
      period-end/@iso-date castable as xs:date and
      (xs:date(period-start/@iso-date) + xs:yearMonthDuration('P1Y') lt xs:date(period-end/@iso-date))">
      <me:feedback type="danger" class="financial" id="7.5.3">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1JhMfO-f3Mldrs15OMlHTAUF9KixTUq5G/view"/>
        <me:message>Budget Period must not be longer than one year.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <!-- not a ruleset error, to be added later as additional?
  <xsl:template match="transaction-date" mode="rules" priority="7.6">
    <xsl:choose>
      <xsl:when test="@iso-date gt ancestor::iati-activity/@last-updated-datetime">
        <me:feedback type="danger" class="financial" id="7.6.1">
          <me:src ref="iati" versions="any"/>
          <me:message>The transaction date is later than the date of the last update of the activity.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="@iso-date gt ancestor::iati-activities/@generated-datetime">
        <me:feedback type="danger" class="financial" id="7.6.2">
          <me:src ref="iati" versions="any"/>
          <me:message>The transaction date is later than the date of generation of the activities file.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  -->

  <xsl:template match="iati-activity//value|loan-status|forecast" mode="rules" priority="7.8">
    <xsl:if test="(not(@currency) or currency='')
      and (not(ancestor::iati-activity/@default-currency) or ancestor::iati-activity/@default-currency='')">
      <me:feedback type="danger" class="financial" id="7.8.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('codelists/Currency/')}"/>
        <me:message>The Value must have a specified Currency, or the Activity must have a default Currency.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-organisation//value" mode="rules" priority="7.8">
    <xsl:if test="(not(@currency) or currency='')
      and (not(ancestor::iati-organisation/@default-currency) or ancestor::iati-organisation/@default-currency='')">
      <me:feedback type="danger" class="financial" id="7.8.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('codelists/Currency/')}"/>
        <me:message>The financial value must have a specified currency, or the activity must declare a default currency.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-activity[country-budget-items]" mode="rules" priority="7.9">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version = '2.03'">
      <xsl:for-each-group select="country-budget-items" group-by="@vocabulary">
        <xsl:call-template name="percentage-checks">
          <xsl:with-param name="group" select="current-group()/budget-item"/>
          <xsl:with-param name="class">financial</xsl:with-param>
          <xsl:with-param name="idclass">7.9</xsl:with-param>
          <xsl:with-param name="item">budget item</xsl:with-param>
          <xsl:with-param name="items">budget items</xsl:with-param>
          <xsl:with-param name="severity">warning</xsl:with-param>
          <xsl:with-param name="verb">should</xsl:with-param>
          <xsl:with-param name="href">activity-standard/iati-activities/iati-activity/country-budget-items/budget-item/</xsl:with-param>
        </xsl:call-template>
      </xsl:for-each-group>
    </xsl:if>
   
    <xsl:next-match/>    
  </xsl:template>
  
  <xsl:template match="transaction[aid-type]" mode="rules" priority="7.10">
    <xsl:if test="not(aid-type/@vocabulary=('1','') or not(aid-type/@vocabulary))">
      <me:feedback type="warning" class="financial" id="107.2.1">
        <me:src ref="iati" versions="2.03"/>
        <me:message>The transaction should also contain a code from the OECD DAC aid type vocabulary.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="count(aid-type[@vocabulary=('1','') or not(@vocabulary)]) > 1
      or (some $v in (aid-type/@vocabulary[. != ('1', '')]) satisfies count(aid-type[@vocabulary=$v]) > 1)">
      <me:feedback type="warning" class="financial" id="107.2.2">
        <me:src ref="iati" versions="2.03"/>
        <me:message>Each transaction should only contain one aid type code per aid type vocabulary (e.g. 1 - OECD DAC)</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
</xsl:stylesheet>

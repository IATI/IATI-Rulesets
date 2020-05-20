<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="xs functx"
  expand-text="yes">

  <!-- not a ruleset error, to be added later as additional?
  <xsl:template match="baseline/@value|target/@value|actual/@value" mode="rules" priority="8.5">
    <xsl:if test="ancestor::result/@aggregation-status castable as xs:boolean and xs:boolean(ancestor::result/@aggregation-status) and not(. castable as xs:decimal)">
      <me:feedback type="danger" class="performance" id="8.5.1">
        <me:src ref="iati" versions="any"/>
        <me:message>The {name(..)} value is not a number but the indicator is part of a result that can be aggregated.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>    
  -->
  
  <xsl:template match="period" mode="rules" priority="8.6">
    
    <xsl:if test="count(period-start/@iso-date)=1 and
      period-start/@iso-date castable as xs:date and
      count(period-end/@iso-date)=1 and
      period-end/@iso-date castable as xs:date and
      (period-start/@iso-date gt period-end/@iso-date)">
      <me:feedback type="danger" class="performance" id="8.6.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/period-start/')}"/>
        <me:message>The start date of the indicator period must be before the end date of the indicator period.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="budget|total-budget|total-expenditure|recipient-org-budget|recipient-country-budget|recipient-region-budget|planned-disbursement" mode="rules" priority="8.7">
    
    <xsl:if test="count(period-start/@iso-date)=1 and
      period-start/@iso-date castable as xs:date and
      count(period-end/@iso-date)=1 and
      period-end/@iso-date castable as xs:date and
      (period-start/@iso-date gt period-end/@iso-date)">
      <me:feedback type="danger" class="financial" id="8.6.3">
        <me:src ref="iati" versions="any" href="https://drive.google.com/file/d/1mv2Q666tKBOAoiy5JayslmZNetxDM1uu/view"/>
        <me:message>The start of the period must be before the end of the period.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="baseline[../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.8">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:choose>
        <xsl:when test="not(@value)">
          <me:feedback type="danger" class="performance" id="8.8.1">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/baseline/')}"/>
            <me:message>The baseline must have a value when the indicator measure is non-qualitative (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal).</me:message>
          </me:feedback>
        </xsl:when>
        <xsl:when test="not(@value castable as xs:decimal)">
          <me:feedback type="warning" class="performance" id="8.8.2">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/baseline/')}"/>
            <me:message>The baseline value should be a valid number for all non-qualitative measures (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal).</me:message>
          </me:feedback>
        </xsl:when>        
      </xsl:choose>
    </xsl:if>
        
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="baseline[../@measure=('5')]" mode="rules" priority="8.18">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="@value">
        <me:feedback type="warning" class="performance" id="8.8.3">
          <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/baseline/')}"/>
          <me:message>The baseline value should be omitted for qualitative measures.</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="target[../../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.9">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:choose>
        <xsl:when test="not(@value)">
          <me:feedback type="danger" class="performance" id="8.9.1">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/target/')}"/>
            <me:message>The target must have a value when indicator measure is non-qualitative (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal).</me:message>
          </me:feedback>
        </xsl:when>
        <xsl:when test="not(@value castable as xs:decimal)">
          <me:feedback type="warning" class="performance" id="8.9.2">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/target/')}"/>
            <me:message>The target value should be a valid number for all non-qualitative measures (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal)</me:message>
          </me:feedback>
        </xsl:when>
      </xsl:choose>        
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="target[../../@measure=('5')]" mode="rules" priority="8.19">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="@value">
        <me:feedback type="warning" class="performance" id="8.9.3">
          <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/target/')}"/>
          <me:message>The target value should be omitted for qualitative measures.</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="actual[../../@measure=('1', '2', '3', '4')]" mode="rules" priority="8.10">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:choose>
        <xsl:when test="not(@value)">
          <me:feedback type="danger" class="performance" id="8.10.1">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/actual/')}"/>
            <me:message>The actual must have a value when the indicator measure is non-qualitative (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal).</me:message>
          </me:feedback>
        </xsl:when>
        <xsl:when test="not(@value castable as xs:decimal)">
          <me:feedback type="warning" class="performance" id="8.10.2">
            <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/actual/')}"/>
            <me:message>The actual value should be a valid number for all non-qualitative indicator measures (e.g. 1 = unit, 2 = percentage, 3 = nominal, 4 = ordinal).</me:message>
          </me:feedback>
        </xsl:when>        
      </xsl:choose>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="actual[../../@measure=('5')]" mode="rules" priority="8.20">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="$iati-version='2.03'">
      <xsl:if test="@value">
        <me:feedback type="warning" class="performance" id="8.10.3">
          <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/period/actual/')}"/>
          <me:message>The actual value should be omitted for qualitative indicator measures.</me:message>
        </me:feedback>
      </xsl:if>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="indicator[reference]" mode="rules" priority="8.11">
    
    <xsl:if test="../reference">
      <me:feedback type="danger" class="performance" id="8.11.1">
        <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/result/indicator/reference/')}"/>
        <me:message>A reference code must only be declared at result OR result indicator level.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

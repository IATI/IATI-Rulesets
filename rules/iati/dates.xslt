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
    <xsl:if test="@last-updated-datetime and 
      @last-updated-datetime castable as xs:dateTime 
      and xs:dateTime(@last-updated-datetime) gt $now">
      <me:feedback type="danger" class="information" id="11.1.1">
        <me:src ref="iati" href="{me:iati-url('activity-standard/iati-activities/iati-activity/')}"/>
        <me:message>The last updated datetime of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='1']/@iso-date and
      activity-date[@type='1']/@iso-date castable as xs:date and
      activity-date[@type='3']/@iso-date and
      activity-date[@type='3']/@iso-date castable as xs:date and
      xs:date(activity-date[@type='1']/@iso-date) gt xs:date(activity-date[@type='3']/@iso-date)">
      <me:feedback type="danger" class="information" id="11.1.2">
        <me:src ref="iati" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>The planned start date of the activity must be before the planned end date.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='2']/@iso-date and
      activity-date[@type='2']/@iso-date castable as xs:date and
      activity-date[@type='4']/@iso-date and
      activity-date[@type='4']/@iso-date castable as xs:date and
      xs:date(activity-date[@type='2']/@iso-date) gt xs:date(activity-date[@type='4']/@iso-date)">
      <me:feedback type="danger" class="information" id="11.1.3">
        <me:src ref="iati" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>The actual start date of the activity must be before the actual end date.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:if test="activity-date[@type='2']/@iso-date and
      activity-date[@type='2']/@iso-date castable as xs:date and
      xs:date(activity-date[@type='2']/@iso-date) gt xs:date($now)">
      <me:feedback type="danger" class="information" id="11.1.4">
        <me:src ref="iati" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>The actual start date of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="activity-date[@type='4']/@iso-date and
      activity-date[@type='4']/@iso-date castable as xs:date and
      xs:date(activity-date[@type='4']/@iso-date) gt xs:date($now)">
      <me:feedback type="danger" class="information" id="11.1.5">
        <me:src ref="iati" href="https://drive.google.com/file/d/1-R-xGMCrAKiadMBIHsNc4Xvl75CB0IV1/view"/>
        <me:message>The actual end date of the activity must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="transaction" mode="rules" priority="11.2">
    <xsl:if test="transaction-date/@iso-date and
      transaction-date/@iso-date castable as xs:date and 
      xs:date(transaction-date/@iso-date) gt xs:date($now)">
      <me:feedback type="danger" class="financial" id="11.2.1">
        <me:src ref="iati" href="https://drive.google.com/file/d/1E3hztk6gWTW5DypLELeSwW5X-Ahg0yjm/view"/>
        <me:message>The transaction date must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:if test="value/@value-date and
      value/@value-date castable as xs:date and
      xs:date(value/@value-date) gt xs:date($now)">
      <me:feedback type="danger" class="financial" id="11.2.2">
        <me:src ref="iati" href="https://drive.google.com/file/d/1E3hztk6gWTW5DypLELeSwW5X-Ahg0yjm/view"/>
        <me:message>The transaction value date must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>    
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="recipient-country-budget/budget-line/value[@value-date]" mode="rules" priority="11.3">
    <xsl:if test="@value-date castable as xs:date and
      ../../period-start/@iso-date and
      ../../period-start/@iso-date castable as xs:date and
      ../../period-end/@iso-date and
      ../../period-end/@iso-date castable as xs:date and
      (xs:date(@value-date) lt xs:date(../../period-start/@iso-date) or xs:date(@value-date) gt xs:date(../../period-end/@iso-date))">
      <me:feedback type="danger" class="financial" id="11.3.1">
        <me:src ref="iati" href="https://drive.google.com/file/d/1mv2Q666tKBOAoiy5JayslmZNetxDM1uu/view"/>
        <me:message>The budget line value date must be within the budget period.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="iati-organisation" mode="rules" priority="11.4">
    <xsl:if test="@last-updated-datetime and
      @last-updated-datetime castable as xs:dateTime and
      xs:dateTime(@last-updated-datetime) gt $now">
      <me:feedback type="danger" class="information" id="11.4.1">
        <me:src ref="iati"/>
        <me:message>The last updated datetime of the organisation must not be in the future.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>

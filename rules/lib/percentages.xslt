<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">
  
  <xsl:template name="percentage-checks">
    <xsl:param name="group" as="node()*"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    <xsl:param name="item"/>
    <xsl:param name="items"/>
    <xsl:param name="vocabulary" select="'n/a'"/>
    <xsl:param name="versions" select="'any'"/>
    <xsl:param name="href" select="''"/>
    <xsl:param name="severity" select="'danger'"/>
    <xsl:param name="verb" select="'must'"/>
    
    <xsl:choose>
      <xsl:when test="count($group) = 0">
      </xsl:when>
      
      <xsl:when test="count($group) = 1">
        <xsl:if test="$group/@percentage and $group/@percentage castable as xs:decimal and xs:decimal($group/@percentage) !=100">
          <me:feedback type="{$severity}" class="{$class}" id="{$idclass}.4">
            <me:src ref="iati" versions="{$versions}" href="{me:iati-url($href)}"/>
            <me:message>When a single {$item} is declared, the percentage must either be omitted, or set to 100.</me:message>
            <me:diagnostic>For {$item} {$group/@code} in vocabulary {$vocabulary}</me:diagnostic>
          </me:feedback>
        </xsl:if>
      </xsl:when>
      
      <xsl:when test="count($group[not(@percentage)]) > 0">
        <me:feedback type="{$severity}" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$versions}" href="{me:iati-url($href)}"/>
          <me:message>When multiple {$items} are declared, each must have a percentage.</me:message>
          <me:diagnostic>For <xsl:if test="$vocabulary!='n/a'">vocabulary {$vocabulary} and </xsl:if>{$items} <xsl:value-of select="$group[not(@percentage)]/@code" separator=", "/>.</me:diagnostic>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="abs(sum($group/@percentage[. castable as xs:decimal])-100) > 0.0101">
        <me:feedback type="{$severity}" class="{$class}" id="{$idclass}.2">
          <me:src ref="iati" versions="{$versions}" href="{me:iati-url($href)}"/>
          <me:message>Percentage values for {$items}, {$verb} add up to 100%.</me:message>
          <me:diagnostic>The sum is {sum($group/@percentage[. castable as xs:decimal])}<xsl:if test="$vocabulary!='n/a'"> for {$items} in vocabulary {$vocabulary}</xsl:if>.</me:diagnostic>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

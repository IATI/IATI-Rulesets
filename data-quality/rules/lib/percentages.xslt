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
    <xsl:param name="iativersion" select="'any'"/>
    <xsl:param name="href" select="''"/>
    
    <xsl:choose>
      <xsl:when test="count($group) = 0">
      </xsl:when>
      
      <xsl:when test="count($group) = 1">
        <xsl:if test="$group/@percentage and $group/@percentage castable as xs:decimal and xs:decimal($group/@percentage) !=100">
          <me:feedback type="danger" class="{$class}" id="{$idclass}.4">
            <me:src ref="iati" versions="{$iativersion}" href="{me:iati-url($href)}"/>
            <me:message>For a single {$item}, the percentage can be omitted or should be 100.</me:message>
          </me:feedback>
        </xsl:if>
      </xsl:when>
      
      <xsl:when test="count($group[not(@percentage)]) > 0">
        <me:feedback type="danger" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$iativersion}" href="{me:iati-url($href)}"/>
          <me:message>Percentages are missing for one or more {$items}.</me:message>
          <me:diagnostic>For <xsl:if test="$vocabulary!='n/a'">vocabulary {$vocabulary} and </xsl:if>{$items} <xsl:value-of select="$group/@code" separator=", "/>.</me:diagnostic>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="abs(sum($group/@percentage)-100) > 0.0101">
        <me:feedback type="danger" class="{$class}" id="{$idclass}.2">
          <me:src ref="iati" versions="{$iativersion}" href="{me:iati-url($href)}"/>
          <me:message>Percentages for {$items} must add up to 100%.</me:message>
          <me:diagnostic>The sum is {sum($group/@percentage)}<xsl:if test="$vocabulary!='n/a'"> for vocabulary {$vocabulary}</xsl:if>.</me:diagnostic>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>

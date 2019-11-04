<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template name="identifier_check">
    <xsl:param name="item"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    <xsl:param name="versions" select="'any'"/>
   
    <xsl:choose>
      <xsl:when test="$item != functx:trim($item)">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$versions}"/>
          <me:message>The identifier should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
   
    <xsl:choose>
      <xsl:when test="matches($item, '[/&amp;|?]')">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.13">
          <me:src ref="iati" versions="{$versions}"/>
          <me:message>The identifier must not contain any of the symbols /, &amp;, | or ?.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="act_identifier_check">
    <xsl:param name="item"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    <xsl:param name="versions" select="'any'"/>
    
    <xsl:choose>
      <xsl:when test="$item != functx:trim($item)">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$versions}"/>
          <me:message>The identifier should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>
  
</xsl:stylesheet>

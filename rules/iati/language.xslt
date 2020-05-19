<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:template match="iati-activity" mode="rules" priority="4.1">
  
    <xsl:if test="not(./@xml:lang) and descendant::narrative[not(@xml:lang)]">
      <me:feedback type="danger" class="information" id="4.1.1">
        <me:src ref="iati" href="{me:iati-url('codelists/Language/')}"/>
        <me:message>The activity should specify a default language OR the language must be specified for each narrative element.</me:message>
      </me:feedback>
    </xsl:if>
  
    <xsl:next-match/>
  </xsl:template>

  <xsl:template match="iati-organisation" mode="rules" priority="4.5">
    
    <xsl:if test="not(./@xml:lang) and descendant::narrative[not(@xml:lang)]">
      <me:feedback type="danger" class="organisation" id="4.5.1">
        <me:src ref="iati" href="{me:iati-url('codelists/Language/')}"/>
        <me:message>The organisation should specify a default language, or the language should be specified for each narrative element.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="title" mode="rules" priority="4.3">
    <xsl:call-template name="narrative_content_check">
      <xsl:with-param name="class">information</xsl:with-param>
      <xsl:with-param name="itemnode" select="."/>
      <xsl:with-param name="item">title</xsl:with-param>
      <xsl:with-param name="href">activity-standard/iati-activities/iati-activity/title/</xsl:with-param>
      <xsl:with-param name="idclass">4.3</xsl:with-param>
    </xsl:call-template>    
  </xsl:template>

  <xsl:template match="description" mode="rules" priority="4.4">
    <xsl:call-template name="narrative_content_check">
      <xsl:with-param name="class">information</xsl:with-param>
      <xsl:with-param name="itemnode" select="."/>
      <xsl:with-param name="item">description</xsl:with-param>
      <xsl:with-param name="href">activity-standard/iati-activities/iati-activity/title/</xsl:with-param>
      <xsl:with-param name="idclass">4.4</xsl:with-param>
    </xsl:call-template>    
  </xsl:template>
  
  <xsl:template name="narrative_content_check">
    <xsl:param name="class"/>
    <xsl:param name="itemnode"/>
    <xsl:param name="item"/>
    <xsl:param name="href"/>
    <xsl:param name="idclass"/>
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:if test="not($itemnode/narrative) or not($itemnode/narrative[functx:trim(.)!=''])">
      <me:feedback type="danger" class="{$class}" id="{$idclass}.1">
        <me:src ref="iati" versions="2.x" href="{me:iati-url('{$href}')}"/>
        <me:message>The {$item} must contain narrative content.</me:message>
      </me:feedback>
    </xsl:if>

    <xsl:next-match/>
  </xsl:template>
  
</xsl:stylesheet>

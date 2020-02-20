<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:functx="http://www.functx.com"
  
  expand-text="yes"
  exclude-result-prefixes="me xs">

  <xsl:import href="../functx.xslt"/>
  <xsl:variable name="meta" select="/me:meta"/>
  <xsl:variable name="calls" select="collection('../../?select=*.xslt;recurse=yes')//xsl:call-template"/>

  <xsl:template match="/">
    <xsl:variable name="rules">
      <file>
        <xsl:perform-sort>
          <xsl:sort select="column[@name='ID']"/>
          <xsl:apply-templates select="collection('../../?select=*.xslt;recurse=yes')//me:feedback" mode="get-feedback-messages"/>        
        </xsl:perform-sort>
      </file>
    </xsl:variable>
    <xsl:apply-templates select="$rules" mode="office-spreadsheet-file"/>
  </xsl:template>

  <xsl:template match="*[ancestor::xsl:template[1][@match]]" mode="get-feedback-messages">
    <row>
      <column style="co1" name="ID">{@id}</column>
      <column style="co1" name="Class">{@class}</column>
      <column style="co1" name="Severity">{$meta//me:severity[@type=current()/@type]}</column>
      <column style="co2" name="Ruleset(s)"><xsl:value-of separator=", "><xsl:apply-templates select="me:src" mode="ruleset-list"/></xsl:value-of></column>
      <column style="co4" name="Message">{me:message 
        => replace(functx:escape-for-regex("{$item}"), me:param(., 'item'))
        => replace(functx:escape-for-regex("{$items}"), me:param(., 'items'))}</column>
      <column style="co4" name="Guidance">{me:src[1]/@href
        => replace(functx:escape-for-regex("$href"), me:param(., 'href'))}</column>
      <column style="co4" name="Context (Xpath)">{ancestor::xsl:template[1]/@match}</column>
      <column style="co4" name="Test (Xpath)">{normalize-space(ancestor::*[local-name(.)=('if','when')][1]/@test)}</column>
    </row>
  </xsl:template>

  <xsl:template match="*[ancestor::xsl:template[1][@name]]" mode="get-feedback-messages">
    <!-- these are named templates called by other matches -->
    <xsl:apply-templates select="$calls[@name=current()/ancestor::xsl:template/@name]" mode="get-feedback-calls">
      <xsl:with-param name="rule" select="."/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*" mode="get-feedback-calls">
    <xsl:param name="rule"/>    
    <row>
      <column style="co1" name="ID">{$rule/@id
        => replace(functx:escape-for-regex('{$idclass}'), me:param(., 'idclass'))}</column>
      <column style="co1" name="Class">{me:param(., 'class')}</column>
      <column style="co1" name="Severity">{$meta//me:severity[@type=$rule/@type]}</column>
      <column style="co2" name="Ruleset(s)">{me:param(., 'versions')}</column>
      <column style="co4" name="Message">{$rule/me:message 
        => replace(functx:escape-for-regex("{$item}"), me:param(., 'item'))
        => replace(functx:escape-for-regex("{$items}"), me:param(., 'items'))}</column>
      <column style="co4" name="Guidance">{$rule/me:src[1]/@href
        => replace(functx:escape-for-regex("$href"), me:param(., 'href'))}</column>
      <column style="co4" name="Context (Xpath)">{ancestor::xsl:template[1]/@match}</column>
      <column style="co4" name="Test (Xpath)">{normalize-space($rule/ancestor::*[local-name(.)=('if','when')][1]/@test)}</column>
    </row>
  </xsl:template>

  <xsl:function name="me:param">
    <xsl:param name="call"/>
    <xsl:param name="item"/>
    <xsl:text>{$call/xsl:with-param[@name=$item]/text()}</xsl:text>
  </xsl:function>
  
  <xsl:template match="me:src" mode="ruleset-list">
    <me:t>{@ref}<xsl:if test="@versions and @versions!='any'">:{@versions}</xsl:if><xsl:if test="@type"> ({$meta//me:severity[@type=current()/@type]})</xsl:if></me:t>
  </xsl:template>
</xsl:stylesheet>

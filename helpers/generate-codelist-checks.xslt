<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:axsl="http://www.w3.org/1999/XSL/TransformAlias"
  xmlns:me="http://iati.me"
  exclude-result-prefixes="math xd"
  expand-text="yes"
  version="3.0">

  <xsl:output indent="yes"/>
  <xsl:namespace-alias stylesheet-prefix="axsl" result-prefix="xsl"/>
  
  <xsl:import href="../lib/iati-me-functions.xslt"/>
  
  <xsl:template match="mappings">
    <axsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:me="http://iati.me"
      exclude-result-prefixes="xs"
      expand-text="yes">
    
      <xsl:apply-templates/>
    
    </axsl:stylesheet>
  </xsl:template>
  
  <xsl:template match="mapping">
    <xsl:variable name="pos" select="'9.' || position() div 2"/>
    <xsl:variable name="codelist" select="codelist/@ref"/>
    <xsl:variable name="condition">
      <xsl:if test="condition">[{condition}]</xsl:if>
    </xsl:variable>
    <xsl:variable name="class" select="class/@ref"/>
    <xsl:variable name="message" select="message"/>
    
    <xsl:analyze-string select="path" regex="(.+)/([^/]+)">
      <xsl:matching-substring>
        <xsl:variable name="default">The {regex-group(2)} code is invalid.</xsl:variable>
        
        <axsl:template match="{regex-group(1) || $condition || '/' || regex-group(2)}" mode="rules" priority="{$pos}">
          <axsl:param name="iati-version" tunnel="yes"/>
          <axsl:if test="me:codeListFail(., '{$codelist}', $iati-version)">
            <me:feedback type="danger" class="{($class, 'iati')[1]}" id="{$pos || '.1'}">
              <me:src ref="iati" versions="any">
                <xsl:attribute name="href">
                  <xsl:text expand-text="no">{me:iati-url('codelists/</xsl:text>
                  <xsl:text>{$codelist}</xsl:text>
                  <xsl:text expand-text="no">/')}</xsl:text>
                </xsl:attribute>                
              </me:src>
              <me:message>{($message, $default)[1]}</me:message>
            </me:feedback>
          </axsl:if>
          
          <axsl:next-match/>
        </axsl:template>
        
      </xsl:matching-substring>
    </xsl:analyze-string>
          
  </xsl:template>
</xsl:stylesheet>
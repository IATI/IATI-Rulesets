<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:variable name="known-publisher-ids" select="doc('../../var/known-publishers.xml')//code"/>
  <xsl:variable name="org-id-prefixes" select="doc('../../var/known-orgid-prefixes.xml')//code"/>
  
  <xsl:template name="identifier_check">
    <xsl:param name="item"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    <xsl:param name="versions" select="'any'"/>
    <xsl:param name="href" select="''"/>
    <xsl:param name="identifier" select="'identifier'"/>
   
    <xsl:choose>
      <xsl:when test="$item != functx:trim($item)">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$versions}">
            <xsl:if test="$href!=''">
              <xsl:attribute name="href" select="$href"/>
            </xsl:if>
          </me:src>
          <me:message>The {$identifier} should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
   
    <!-- skip publisher ids approved by the Registry -->
    <xsl:if test="not($item=$known-publisher-ids)">
      <xsl:choose>
        <xsl:when test="matches($item, '[/&amp;|?]')">
          <me:feedback type="warning" class="{$class}" id="{$idclass}.13">
            <me:src ref="iati" versions="{$versions}">
              <xsl:if test="$href!=''">
                <xsl:attribute name="href" select="$href"/>
              </xsl:if>
            </me:src>
            <me:message>The {$identifier} must not contain any of the symbols /, &amp;, | or ?.</me:message>
          </me:feedback>
        </xsl:when>
      </xsl:choose>

      <!-- only check prefixes for reporting-org -->
      <xsl:if test="$idclass=('1.14', '1.18')">
        <xsl:choose>
          <xsl:when test="not(some $prefix in $org-id-prefixes satisfies starts-with($item, $prefix||'-'))">
            <me:feedback type="warning" class="{$class}" id="{$idclass}.8">
              <me:src ref="iati" versions="{$versions}">
                <xsl:if test="$href!=''">
                  <xsl:attribute name="href" select="$href"/>
                </xsl:if>              
              </me:src>
              <me:message>The {$identifier} does not start with a known prefix.</me:message>
            </me:feedback>
          </xsl:when>        
        </xsl:choose>        
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template name="act_identifier_check">
    <xsl:param name="item"/>
    <xsl:param name="class"/>
    <xsl:param name="idclass"/>
    <xsl:param name="versions" select="'any'"/>
    <xsl:param name="identifier" select="'identifier'"/>
    
    <xsl:choose>
      <xsl:when test="$item != functx:trim($item)">
        <me:feedback type="warning" class="{$class}" id="{$idclass}.1">
          <me:src ref="iati" versions="{$versions}"/>
          <me:message>The {$identifier} should not start or end with spaces or newlines.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>    
  </xsl:template>
  
</xsl:stylesheet>

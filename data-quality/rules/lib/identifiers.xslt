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
    <xsl:param name="versions" select="'any'"></xsl:param>
   
    <xsl:choose>
      <xsl:when test="matches($item, '[^/&amp;|?]+')">
        <me:feedback type="danger" class="{$class}" id="{$idclass}.13">
          <me:src ref="iati" versions="any" href="me:iati-url('organisation-identifiers/')"/>
          <me:message>The identifier must not contain any of the symbols /, &amp;, | or ?.</me:message>
        </me:feedback>
      </xsl:when>

    </xsl:choose>

    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>

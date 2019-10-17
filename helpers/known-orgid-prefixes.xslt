<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  expand-text="yes">

  <xsl:output indent="yes"/>

  <xsl:template match="/">
    <codelist>
      <xsl:apply-templates select="//code"/>
    </codelist>
  </xsl:template>

  <xsl:template match="code">
    <xsl:copy>
      <xsl:copy-of select="../@status"/>
      <xsl:copy-of select="node()"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>

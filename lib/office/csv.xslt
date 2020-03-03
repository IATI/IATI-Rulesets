<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:wb="http://iati.me/office"
  expand-text="yes">

  <xsl:output method="text" encoding="utf-8" />  

  <xsl:template match="*" mode="office-spreadsheet-file">
    <!-- the table consists of the header and the data rows -->
    <xsl:apply-templates select="*[1]" mode="office-spreadsheet-header"/>
    <xsl:apply-templates mode="office-spreadsheet-row"/>
  </xsl:template>
  
  <xsl:template match="*" mode="office-spreadsheet-header">
    <!-- the header consists of a description of all columns followed by the first data row -->
    <xsl:value-of separator=",">
      <xsl:apply-templates mode="office-spreadsheet-header-column-heading"/>   
    </xsl:value-of>    
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-header-column-heading">
    <wb:text>"{@name}"</wb:text>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-row">
    <xsl:value-of separator=",">
      <xsl:apply-templates mode="office-spreadsheet-cell"/>
    </xsl:value-of>    
    <xsl:text>&#xa;</xsl:text>
  </xsl:template>

  <xsl:template match="*[normalize-space(.)=('', ' ')]" mode="office-spreadsheet-cell">
    <wb:text/>
  </xsl:template>
  
  <xsl:template match="*[contains(., '&quot;') or contains(., ',')]" mode="office-spreadsheet-cell">
    <wb:text>"{normalize-space(.[1])=>replace('&quot;',  '&quot;&quot;')}"</wb:text>
  </xsl:template>

  <xsl:template match="*" mode="office-spreadsheet-cell">
    <wb:text>{normalize-space(.[1])}</wb:text>
  </xsl:template>
</xsl:stylesheet>

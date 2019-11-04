<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version='3.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:me="http://iati.me"
  xmlns:functx="http://www.functx.com"
  exclude-result-prefixes="functx"
  expand-text="yes">

  <xsl:variable name="known-publisher-ids" select="doc('../../var/known-publishers.xml')//code"/>
  <xsl:variable name="org-id-prefixes" select="doc('../../var/known-orgid-prefixes.xml')//code"/>
  
  <xsl:template match="iati-identifier" mode="rules" priority="1.1">
    <xsl:param name="iati-version" tunnel="yes"/>
    
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.3</xsl:with-param>
    </xsl:call-template>    
    
    <xsl:choose>
      <xsl:when test="not(some $id in (../reporting-org/@ref, ../other-identifier[@type='B1']/@ref) satisfies starts-with(., $id))">
        <me:feedback type="warning" class="identifiers" id="1.1.1">
          <me:src ref="iati" versions="any"/>
          <me:message>The activity identifier should begin with the organisation identifier of the reporting organisation (or a previous version included in the other-identifier element).</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test=". = ../reporting-org/@ref">
        <me:feedback type="danger" class="identifiers" id="1.1.3">
          <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/iati-identifier/')}"/>
          <me:message>The activity identifier must not be the same as the organisation identifier of the reporting organisation.</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="$iati-version = '2.03' and
        not(some $id in (../reporting-org/@ref, ../other-identifier[@type='B1']/@ref) satisfies matches(., functx:escape-for-regex($id) || '-.+'))">
        <me:feedback type="warning" class="identifiers" id="1.1.21">
          <me:src ref="iati" versions="2.03" href="{me:iati-url('activity-standard/iati-activities/iati-activity/iati-identifier/')}"/>
          <me:message>The activity identifier's prefix and suffix should be separated by a hyphen e.g. XM-DAC-2222</me:message>
        </me:feedback>
      </xsl:when>
      <xsl:when test="not(some $known-id in $known-publisher-ids satisfies starts-with(., $known-id || '-'))">
        <me:feedback type="warning" class="identifiers" id="1.3.11">
          <me:src ref="iati" versions="2.x"/>
          <me:message>The activity identifier should begin with an organisation identifier approved by the IATI registry.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>

    <!-- TODO move this to an activity file-level test -->
    <xsl:if test="../../iati-activity[iati-identifier=current()][2]">
      <me:feedback type="danger" class="identifiers" id="1.1.2">
        <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/iati-identifier/')}"/>
        <me:message>The activity identifier must not occur multiple times in the dataset.</me:message>
      </me:feedback>
    </xsl:if>
    
    <xsl:next-match/>
  </xsl:template>
    
  <!-- Checks on the identifiers of organisations or activities -->

  <xsl:template match="reporting-org" mode="rules" priority="1.7">
    
    <xsl:choose>
      <xsl:when test="not(@ref)">
        <me:feedback type="danger" class="identifiers" id="1.7.2">
          <me:src ref="iati" versions="any" href="{me:iati-url('activity-standard/iati-activities/iati-activity/reporting-org/')}"/>
          <me:message>Organisation Identifier must be present.</me:message>
        </me:feedback>      
      </xsl:when>
      
      <xsl:when test="not(@ref=$known-publisher-ids)">
        <me:feedback type="warning" class="identifiers" id="1.14.12">
          <me:src ref="iati" versions="2.x"/>
          <me:message>The activity's organisation identifier should be an organisation identifier approved by the IATI registry.</me:message>
        </me:feedback>
      </xsl:when>
      
      <xsl:when test="not(some $prefix in $org-id-prefixes satisfies starts-with(@ref, $prefix||'-'))">
        <me:feedback type="warning" class="identifiers" id="1.14.8">
          <me:src ref="iati" versions="2.x" href="http://org-id.guide"/>
          <me:message>The identifier does not start with a known prefix.</me:message>
        </me:feedback>
      </xsl:when>
    </xsl:choose>
    
    <xsl:next-match/>
  </xsl:template>
  
  <xsl:template match="organisation-identifier" mode="rules" priority="1.12">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.12</xsl:with-param>
      <xsl:with-param name="versions">2.0x</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
    
  <xsl:template match="reporting-org/@ref" mode="rules" priority="1.14">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.14</xsl:with-param>
      <xsl:with-param name="href">https://iatistandard.org/en/guidance/preparing-organisation/organisation-account/how-to-create-your-iati-organisation-identifier/</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="participating-org/@ref" mode="rules" priority="1.8">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.8</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@activity-id" mode="rules" priority="1.9">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.9</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@provider-activity-id" mode="rules" priority="1.4">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.4</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="@receiver-activity-id" mode="rules" priority="1.5">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.5</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="provider-org/@ref" mode="rules" priority="1.10">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">financial</xsl:with-param>
      <xsl:with-param name="idclass">1.10</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="receiver-org/@ref" mode="rules" priority="1.15">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">organisation</xsl:with-param>
      <xsl:with-param name="idclass">1.15</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
  <xsl:template match="other-identifier[upper-case(@type)=('A3')]/@ref" mode="rules" priority="1.6">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.6</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="other-identifier[upper-case(@type)=('B1')]/@ref" mode="rules" priority="1.16">
    <!-- TODO hack for now: use activity identifier check so it only checks for leading/trailing whitespace, not for unwanted characters (as for other organisation identifiers) -->
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.16</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    

  <xsl:template match="owner-org/@ref" mode="rules" priority="1.11">
    <xsl:call-template name="identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">participating</xsl:with-param>
      <xsl:with-param name="idclass">1.11</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
    
  <xsl:template match="related-activity/@ref" mode="rules" priority="1.7">
    <xsl:call-template name="act_identifier_check">
      <xsl:with-param name="item" select="."/>
      <xsl:with-param name="class">identifiers</xsl:with-param>
      <xsl:with-param name="idclass">1.7</xsl:with-param>
    </xsl:call-template>
    <xsl:next-match/>
  </xsl:template>    
  
</xsl:stylesheet>

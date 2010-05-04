<?xml version="1.0"?>
<!-- 
   TODO

   - support reporting-org
   - support iati-identifier
-->
<!--
  IATI-to-IDML conversion script for UN-OCHA to Haiti AMP reporting.

  David Megginson, 2010-04-27

  This script will convert an XML document in IATI's draft format to
  version 2.0 of the International Development Markup Language (IDML)
  as currently used by Haiti's AMP (from the Development Gateway).
  Note that the output has *not* been tested, and may contain
  incorrect assumptions about how the AMP uses IDML.
  
  Please feel free to modify this script as required.  If you run into
  strange bugs after making modifications, try removing the
  xml:space="preserve" attribute from the root element: it results
  in nicely-formatted output for humans to read, but makes the
  XSLT very sensitive to whitespace changes.

  This script is meant only as a stopgap, until the Development
  Gateway AMP can import IATI data directly.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- iterate through the IATI projects, ignoring anything else -->
  <xsl:template match="/iati-activities">
    <activities>
      <xsl:apply-templates select="iati-activity" mode="internal"/>
    </activities>
  </xsl:template>

  <xsl:template match="/iati-activity">
    <activities>
      <xsl:apply-templates select="/iati-activity" mode="internal"/>
    </activities>
  </xsl:template>

  <!-- transform IATI project IDML activity -->
  <xsl:template match="iati-activity" mode="internal">
    <activity>
      <xsl:attribute name="dbKey">
        <xsl:value-of select="other-identifier"/>
      </xsl:attribute>
      <id>
        <xsl:attribute name="uniqID">
          <xsl:value-of select="other-identifier"/>
        </xsl:attribute>
        <assigningOrg>UN-OCHA</assigningOrg>
      </id>
      <title>
        <xsl:value-of select="title"/>
      </title>
      <objective>
        <xsl:value-of select="description[@type='objectives']"/>
      </objective>
      <description>
        <xsl:value-of select="description[@type='summary']"/>
      </description>
      <location locationType="Country">
        <xsl:attribute name="iso3">
          <xsl:value-of select="recipient-country/@ref"/>
        </xsl:attribute>
        <xsl:attribute name="countryName">
          <xsl:value-of select="recipient-country"/>
        </xsl:attribute>
        <locationName>
          <xsl:attribute name="code">
            <xsl:value-of select="recipient-country"/>
          </xsl:attribute>
          <xsl:value-of select="recipient-country"/>
        </locationName>
      </location>
      <location locationType="Region">
        <xsl:attribute name="iso3">
          <xsl:value-of select="recipient-country/@ref"/>
        </xsl:attribute>
        <xsl:attribute name="countryName">
          <xsl:value-of select="recipient-country"/>
        </xsl:attribute>
        <locationName>
          <xsl:value-of select="target-location[@type='un-ocha-province']"/>
        </locationName>
      </location>
      <proposedStartDate>
        <xsl:attribute name="date">
          <xsl:value-of select="activity-date[@type='start']/@iso-date"/>
        </xsl:attribute>
      </proposedStartDate>
      <closingDate>
        <xsl:attribute name="date">
          <xsl:value-of select="activity-date[@type='completion']/@iso-date"/>
        </xsl:attribute>
      </closingDate>
      <status code="proposed"/>
      <sectors percentage="100">
        <xsl:attribute name="code">
          <xsl:value-of select="sector[@type='IASC']/@ref"/>
        </xsl:attribute>
        <xsl:value-of select="sector[@type='IASC']"/>
      </sectors>
      <xsl:apply-templates select="transaction[@flow='incoming']"/>
      <relatedOrgs type="Responsible Organization">
        <xsl:attribute name="code">
          <xsl:value-of select="reporting-org/@ref"/>
        </xsl:attribute>
        <xsl:value-of select="reporting-org"/>
      </relatedOrgs>
      <additional field="ocha-activities" type="String">
        <xsl:value-of select="description[@type='activities']"/>
      </additional>
      <additional field="ocha-outputs" type="String">
        <xsl:value-of select="description[@type='outputs']"/>
      </additional>
      <additional field="ocha-appeal-id" type="String">
        <xsl:value-of select="related-initiative[@type='un-ocha-appeal']/@ref"/>
      </additional>
      <additional field="ocha-appeal-name" type="String">
        <xsl:value-of select="related-initiative[@type='un-ocha-appeal']"/>
      </additional>
      <additional field="ocha-cluster-code" type="String">
        <xsl:value-of select="sector[@type='cluster']/@ref"/>
      </additional>
      <additional field="ocha-cluster-name" type="String">
        <xsl:value-of select="sector[@type='cluster']"/>
      </additional>
      <additional field="ocha-total-cost" type="Number">
        <xsl:value-of select="total-cost"/>
      </additional>
      <xsl:if test="aid-type">
        <additional field="ocha-aid-type" type="String">
          <xsl:value-of select="aid-type"/>
        </additional>
      </xsl:if>
      <additional field="ocha-total-cost-currency" type="String">
        <xsl:value-of select="total-cost/@currency"/>
      </additional>
    </activity>
  </xsl:template>

  <!-- transform IATI incoming-contribution to IDML funding -->
  <xsl:template match="transaction[@flow='incoming']">
    <funding>
      <xsl:attribute name="code">
        <xsl:value-of select="@ref"/>
      </xsl:attribute>
      <fundingOrg>
        <xsl:attribute name="code">
          <xsl:value-of select="provider-org/@ref"/>
        </xsl:attribute>
        <xsl:value-of select="provider-org"/>
      </fundingOrg>
      <assistanceType>
        <xsl:value-of select="../aid-type"/>
      </assistanceType>
      <financingInstrument>donation</financingInstrument>
      <xsl:choose>
        <xsl:when test="status='Paid contribution'">
          <disbursements type="donation">
            <xsl:attribute name="date">
              <xsl:choose>
                <xsl:when test="milestone-date[@type='disbursement']">
                  <xsl:value-of select="milestone-date[@type='disbursement']"/>
                </xsl:when>
                <xsl:when test="milestone-date">
                  <xsl:value-of select="milestone-date"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="value/@value-date"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="amount">
              <xsl:value-of select="value"/>
            </xsl:attribute>
            <xsl:attribute name="currency">
              <xsl:choose>
                <xsl:when test="value/@currency">
                  <xsl:value-of select="value/@currency"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="../@default-currency"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </disbursements>
        </xsl:when>
        <xsl:otherwise>
          <commitments type="donation">
            <xsl:attribute name="date">
              <xsl:choose>
                <xsl:when test="milestone-date[@type='commitment']">
                  <xsl:value-of select="milestone-date[@type='commitment']"/>
                </xsl:when>
                <xsl:when test="milestone-date">
                  <xsl:value-of select="milestone-date"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="value/@value-date"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="amount">
              <xsl:value-of select="value"/>
            </xsl:attribute>
            <xsl:attribute name="currency">
              <xsl:choose>
                <xsl:when test="value/@currency">
                  <xsl:value-of select="value/@currency"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="../@default-currency"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </commitments>
        </xsl:otherwise>
      </xsl:choose>
    </funding>
  </xsl:template>

</xsl:stylesheet>

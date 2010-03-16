<?xml version="1.0"?>

<!--
  IATI-to-IDML conversion script for UN-OCHA to Haiti AMP reporting.

  David Megginson, 2010-03-16

  This is the second draft of a conversion script based on an early
  draft schema (2010-03-16) from the International Aid Transparency
  Initiative (IATI).

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
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xml:space="preserve">

<xsl:template match="iati-projects">
<activities>
<xsl:apply-templates select="project"/>
</activities>
</xsl:template>

<xsl:template match="project">
  <activity><xsl:attribute name="dbKey"><xsl:value-of select="primary-id"/></xsl:attribute>
    <id><xsl:attribute name="uniqID"><xsl:value-of select="primary-id"/></xsl:attribute>
      <assigningOrg>UN-OCHA</assigningOrg>
    </id>
    <title><xsl:value-of select="title"/></title>
    <objective><xsl:value-of select="description[@type='objectives']"/></objective>
    <description><xsl:value-of select="description[@type='summary']"/></description>
    <location locationType="Country"><xsl:attribute name="iso3"><xsl:value-of select="recipient-country/@ref"/></xsl:attribute><xsl:attribute name="countryName"><xsl:value-of select="recipient-country"/></xsl:attribute>
      <locationName><xsl:attribute name="code"><xsl:value-of select="recipient-country"/></xsl:attribute><xsl:value-of select="recipient-country"/></locationName>
    </location>
    <location locationType="Region"><xsl:attribute name="iso3"><xsl:value-of select="recipient-country/@ref"/></xsl:attribute><xsl:attribute name="countryName"><xsl:value-of select="recipient-country"/></xsl:attribute>
      <locationName><xsl:value-of select="target-location[@type='province']"/></locationName>
    </location>
    <proposedStartDate><xsl:attribute name="date"><xsl:value-of select="start-date-planned"/></xsl:attribute></proposedStartDate>
    <closingDate><xsl:attribute name="date"><xsl:value-of select="start-date-planned"/></xsl:attribute></closingDate>
    <status code="proposed"/>
    <sectors percentage="100"><xsl:attribute name="code"><xsl:value-of select="sector[@type='DAC']/@ref"/></xsl:attribute><xsl:value-of select="sector[@type='DAC']"/></sectors><xsl:apply-templates select="incoming-contribution"/>
    <additional field="ocha-activities" type="String"><xsl:value-of select="description[@type='activities']"/></additional>
    <additional field="ocha-outputs" type="String"><xsl:value-of select="description[@type='outputs']"/></additional>
    <additional field="ocha-appeal-id" type="String"><xsl:value-of select="related-initiative[@type='appeal']"/></additional>
    <additional field="ocha-cluster" type="String"><xsl:value-of select="section[@type='cluster']/@ref"/></additional>
    <additional field="ocha-total-cost" type="Number"><xsl:value-of select="total-cost"/></additional>
    <additional field="ocha-total-cost-currency" type="String"><xsl:value-of select="total-cost/@currency"/></additional>
  </activity>
</xsl:template>

<xsl:template match="incoming-contribution">
    <funding><xsl:attribute name="code"><xsl:value-of select="@ref"/></xsl:attribute>
      <fundingOrg><xsl:attribute name="code"><xsl:value-of select="donor-org/@ref"/></xsl:attribute><xsl:value-of select="donor-org"/></fundingOrg>
      <assistanceType><xsl:value-of select="contribution-type"/></assistanceType>
      <financingInstrument>donation</financingInstrument>
<xsl:choose><xsl:when test="status='disbursed'">
      <disbursements type="donation"><xsl:attribute name="date"><xsl:value-of select="milestone-date[@type='disbursement']"/></xsl:attribute><xsl:attribute name="amount"><xsl:value-of select="value"/></xsl:attribute><xsl:attribute name="currency"><xsl:value-of select="value/@currency"/></xsl:attribute></disbursements></xsl:when><xsl:otherwise>
      <commitments type="donation"><xsl:attribute name="date"><xsl:value-of select="milestone-date[@type='disbursement']"/></xsl:attribute><xsl:attribute name="amount"><xsl:value-of select="value"/></xsl:attribute><xsl:attribute name="currency"><xsl:value-of select="value/@currency"/></xsl:attribute></commitments></xsl:otherwise></xsl:choose>
    </funding>
</xsl:template>

</xsl:stylesheet>

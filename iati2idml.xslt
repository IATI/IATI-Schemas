<?xml version="1.0"?>

<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xml:space="preserve">

<xsl:template match="iati-projects">
<activities>
<xsl:apply-templates/>
</activities>
</xsl:template>

<xsl:template match="project">
  <activity>
    <id>

      <assigningOrg>UN-OCHA</assigningOrg>
    </id>
  </activity>
</xsl:template>

</xsl:stylesheet>
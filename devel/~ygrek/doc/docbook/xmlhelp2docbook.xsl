<?xml version='1.0' encoding="windows-1251"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
  <xsl:output encoding="windows-1251" method="xml" indent="yes"/>

  <xsl:template match="forthsourcecode">
  <xsl:for-each select="module">          <!-- ��� ������� 䠩��-->
  <chapter>                               <!-- ������-->
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <title>
      <xsl:value-of select="@name"/>      <!-- ��� 䠩��-->
    </title>

    <section id="toc-section">            <!-- ����������-->
      <para>{DESCRIPTION}</para>
      <toc id="toc"/>
    </section>

    <xsl:for-each select="colon">         <!-- ��� ������� ��।������ �१ �����稥-->
    <xsl:if test="@vocabulary='FORTH'">   <!-- ���쪮 � �� �ᯮ�������� � ��騩 ᫮����-->
    <section>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <title>
        <xsl:value-of select="@name"/>    <!-- ��� ᫮��-->
      </title>
      <indexterm type="word">
        <primary>
          <xsl:value-of select="@name"/>  <!-- ������ �� ����� ᫮��-->
        </primary>
      </indexterm>
      <para>
        <emphasis>
        <xsl:value-of select="@params"/>  <!-- �⥪���� �����-->
        </emphasis>
      </para>
      <para>
        <xsl:value-of select="comment"/>  <!-- �������ਨ-->
      </para>
    </section>
    </xsl:if>
    </xsl:for-each>

  </chapter>
  </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

<?xml version='1.0' encoding="windows-1251"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" >
  <xsl:output encoding="windows-1251" method="xml" indent="yes"/>

  <xsl:template match="forthsourcecode">
  <xsl:for-each select="module">          <!-- ��� ������� 䠩��-->
  <section>                               <!-- ������-->
    <xsl:attribute name="id">
      <xsl:value-of select="generate-id()"/>
    </xsl:attribute>
    <title>
      <xsl:value-of select="@name"/>      <!-- ��� 䠩��-->
    </title>

    <section id="toc-section">
      <para>{DESCRIPTION}</para>          <!-- ���ᠭ�� (����⠢����� ᭠�㦨)-->
      <toc id="toc"/>                     <!-- ����������-->
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
        <xsl:for-each select="comment">  <!-- �������ਨ-->
          <xsl:value-of select="."/>
           <xsl:if test="not (position()=last())">
               <sbr/>                    <!-- ��ॢ�� ��ப� (�஬� ��᫥����)-->
          </xsl:if>
        </xsl:for-each>
      </para>
    </section>
    </xsl:if>
    </xsl:for-each>

  </section>
  </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

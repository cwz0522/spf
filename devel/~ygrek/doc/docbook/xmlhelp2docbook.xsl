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
      <!--para>{DESCRIPTION}</para-->          <!-- ���ᠭ�� (����⠢����� ᭠�㦨)-->
      <para>                              <!-- ���ᠭ�� (�� ����)-->
      <xsl:for-each select="comment">
        <xsl:value-of select="."/>
        <xsl:if test="not (position()=last())">
            <sbr/>                    <!-- ��ॢ�� ��ப� (�஬� ��᫥����)-->
        </xsl:if>
      </xsl:for-each>
      </para>
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
        <primaryie>
          <xsl:value-of select="@name"/>  <!-- ������ �� ����� ᫮��-->
        </primaryie>
      </indexterm>
      <para>
        <emphasis>
        <xsl:value-of select="@params"/>  <!-- �⥪���� �����-->
        </emphasis>
      </para>
      <xsl:variable name="FirstComment">
        <xsl:value-of select="comment"/>
      </xsl:variable>

      <para>
      <xsl:choose>
        <xsl:when test="string-length($FirstComment)!=0">

          <xsl:for-each select="comment">  <!-- �������ਨ-->
            <xsl:value-of select="."/>
             <xsl:if test="not (position()=last())">
                 <sbr/>                    <!-- ��ॢ�� ��ப� (�஬� ��᫥����)-->
            </xsl:if>
          </xsl:for-each>

        </xsl:when>
        <xsl:otherwise>

          <xsl:call-template name="allstack">
            <xsl:with-param name = "S" >
              <xsl:value-of select="@params" />
            </xsl:with-param>
          </xsl:call-template>

        </xsl:otherwise>
      </xsl:choose>
      </para>
    </section>
    </xsl:if>
    </xsl:for-each>

  </section>
  </xsl:for-each>
  </xsl:template>


  <xsl:template name = "allstack" >
    <xsl:param name = "S"/>

    <variablelist>

    <xsl:call-template name = "allstack-norm" >
       <xsl:with-param name = "S" >
         <xsl:value-of select="normalize-space($S)" />
       </xsl:with-param>
    </xsl:call-template>

    </variablelist>

  </xsl:template>

  <xsl:template name = "allstack-norm" >
      <xsl:param name = "S"/>

      <xsl:variable name="Word">
        <xsl:value-of select="substring-before($S,' ')"/>
      </xsl:variable>

      <xsl:if test="string-length($Word)>0">

         <xsl:if test="$Word != '|' and $Word != '\' and $Word != '--'">

            <xsl:if test="$Word!='(' and $Word!='{'">

                <varlistentry>                      <!-- ���ᠭ�� ��ࠬ��஢ - 蠡��� -->
                  <term>
                    <xsl:value-of select="$Word"/>
                  </term>
                  <listitem>
                  <simpara>
                  <xsl:text> </xsl:text>
                  </simpara>
                  </listitem>
                </varlistentry>

            </xsl:if>

            <xsl:call-template name = "allstack-norm" >
              <xsl:with-param name = "S" >
                 <xsl:value-of select="substring-after($S,' ')" />
              </xsl:with-param>
            </xsl:call-template>

         </xsl:if>

      </xsl:if>

  </xsl:template>

</xsl:stylesheet>

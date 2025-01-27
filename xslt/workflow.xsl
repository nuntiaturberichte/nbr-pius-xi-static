<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of
                select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level = 's']"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <style>
                    .level-2 {
                        margin-left: 1vw;
                        margin-right: 1vw;
                        background-color: #f9f9f9;
                        margin-bottom: 20px;
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                    }
                    .level-3 {
                        margin-left: 1vw;
                        margin-right: 1vw;
                        background-color: #f1f1f1;
                        margin-bottom: 20px;
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                    }
                    .level-4 {
                        margin-left: 1vw;
                        margin-right: 1vw;
                        background-color: #e9e9e9;
                        margin-bottom: 20px;
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                    }
                    table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    table th,
                    table td {
                        padding: 10px;
                        border: 1px solid #dee2e6;
                        text-align: left;
                    }
                    
                    table th {
                        background-color: #f8f9fa;
                    }
                    
                    table tr:nth-child(even) {
                        background-color: #F5F5F5;
                    }
                    
                    table a {
                        color: #007bff;
                        text-decoration: none;
                    }
                    
                    table a:hover {
                        text-decoration: underline;
                    }</style>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="my-4" style="text-align:center">
                            <h1>Arbeitsablauf</h1>
                        </div>
                        <xsl:apply-templates select="//tei:body/tei:div"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:div">
        <xsl:variable name="level" select="@type"/>
        <xsl:element name="div">
            <xsl:attribute name="class">
                <xsl:value-of select="concat('level-', $level)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:variable name="level" select="@type"/>
        <xsl:element name="{concat('h', $level)}">
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:list[@type = 'ordered']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:ref">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>

    <xsl:template match="tei:table">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <xsl:for-each select="tei:cell">
                                    <th style="text-align:center; background-color: #99C3FF;">
                                        <xsl:value-of select="."/>
                                    </th>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="tei:cell">
                                    <xsl:choose>
                                        <xsl:when test="@cols">
                                            <td colspan="{@cols}"
                                                style="text-align:center; font-style: italic; background-color: #D6E7FF;">
                                                <xsl:value-of select="."/>
                                            </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td>
                                                <xsl:value-of select="."/>
                                            </td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:otherwise>
                        </xsl:choose>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="tei:code">
        <code>
            <xsl:apply-templates/>
        </code>
    </xsl:template>

    <xsl:template match="tei:gi">
        <code><xsl:apply-templates/></code>
    </xsl:template>
</xsl:stylesheet>

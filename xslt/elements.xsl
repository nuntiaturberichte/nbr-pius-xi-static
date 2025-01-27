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
        <xsl:variable name="doc_title" select="'Kodierungsrichtlinien'"/>
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
                    #kodierung-bsp {
                        margin-top: 2em;
                        border: 2px solid black;
                        padding: 5px;
                        border-radius: 8px;
                    }</style>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="my-4" style="text-align:center">
                        <h1>Kodierungsrichtlinien</h1>
                    </div>
                    <div class="container">
                        <xsl:apply-templates select="//tei:body"/>
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

    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:figure[@xml:id = 'kodierung-bsp.png']">
        <img class="img-fluid">
            <xsl:attribute name="id">
                <xsl:text>kodierung-bsp</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="src">
                <xsl:value-of select="@source"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
                <xsl:value-of select="tei:desc"/>
            </xsl:attribute>
        </img>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:code">
        <code>
            <xsl:value-of select="."/>
        </code>
    </xsl:template>
    
    <xsl:template match="tei:gi">
        <code><xsl:apply-templates/></code>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>


</xsl:stylesheet>

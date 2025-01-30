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
                    .level-1 {
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                    }
                    
                    .level-2,
                    .level-3,
                    .level-4,
                    .level-5,
                    .level-6,
                    .level-7 {
                        margin-left: 1vw;
                        margin-right: 1vw;
                        margin-bottom: 20px;
                        padding: 10px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                    }
                    
                    .level-1 {
                        background-color: #FFFBEB;
                    }
                    
                    .level-2 {
                        background-color: #FFF3C2;
                    }
                    
                    .level-3 {
                        background-color: #FFEB99;
                    }
                    
                    .level-4 {
                        background-color: #FFE270;
                    }
                    
                    .level-5 {
                        background-color: #FFDA47;
                    }
                    
                    .level-6 {
                        background-color: #FFD21F;
                    }
                    
                    .level-7 {
                        background-color: #F5C400;
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

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:list[@type = 'circle']">
        <ul style="list-style-type: circle;">
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
</xsl:stylesheet>

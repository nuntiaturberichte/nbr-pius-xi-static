<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="//tei:body/tei:div/tei:head"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <style>
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
                        background-color: #ffedad;
                    }
                    
                    table tr:nth-child(even) {
                        background-color: #fff6d6;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="card mt-4">
                            <div class="card-header"
                                style="text-align:center; background-color: #ffedad;">
                                <h1 style="display:inline-block;margin-bottom:0;padding-right:5px;">
                                    <xsl:value-of select="//tei:body/tei:div/tei:head"/>
                                </h1>
                            </div>
                            <div class="card-body">
                                <div>
                                    <xsl:variable name="fileName"
                                        select="tokenize(document-uri(.), '/')[last()]"/>
                                    <xsl:variable name="imgName"
                                        select="replace($fileName, '\.[^.]+$', '.jpg')"/>
                                    <xsl:if test="$imgName ne 'wenzel_grosam.jpg'">
                                        <img
                                            style="max-height: 420px; float: left; border: 1px solid black; margin-right: 1rem; border-radius: 10px;"
                                            src="./images/{$imgName}"/>
                                    </xsl:if>
                                    <xsl:apply-templates select="//tei:div[@type = 'text']"/>
                                </div>

                                <div style="display: none;">
                                    <xsl:apply-templates select="//tei:div[@type = 'table']"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:table">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:for-each select="tei:cell">
                            <td>
                                <xsl:apply-templates/>
                            </td>
                        </xsl:for-each>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'bold']">
        <span style="font-weight: bold;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="tei:hi[@rend = 'italic']">
        <span style="font-style: italic;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>

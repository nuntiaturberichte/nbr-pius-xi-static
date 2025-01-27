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
        <xsl:variable name="doc_title" select="'Grazer Nuntiaturberichte - Digitale Edition'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <meta name="description"
                    content="Recherchieren Sie in der digitalen Edition der Grazer Nuntiaturberichte, der frei zugänglichen Korrespondenz des päpstlichen Gesandten in Innerösterreich zur Zeit der Gegenreformation."/>
                <style>
                    /* carousel */
                    
                    .carousel-container {
                        max-width: 800px;
                        height: 500px;
                        padding: 40px;
                        background-color: #f2f2f2;
                        border: 2px solid #dee2e6;
                        border-radius: 5px;
                        overflow: hidden;
                        display: flex;
                        justify-content: center;
                        align-items: center;
                    }
                    
                    .carousel-inner {
                        width: 100%;
                        height: 100%;
                        border-radius: 5px;
                    }
                    
                    .carousel-caption {
                        background-color: rgba(128, 128, 128, 0.9);
                        border-radius: 5px;
                        padding-top: 0.75rem;
                        padding-bottom: 0.75rem;
                    }
                    
                    .carousel-control-prev:hover,
                    .carousel-control-next:hover {
                        background-color: rgba(128, 128, 128, 0.9);
                        border-radius: 5px;
                    }
                    
                    /* Tabelle */
                    
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
                        background-color: #f2f2f2;
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
                            <h1>Über das Projekt</h1>
                        </div>
                        <xsl:apply-templates select="//tei:body/tei:div"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:div[@type = 'text_and_img']">
        <div class="row">
            <div class="col-lg-7">
                <xsl:apply-templates select="tei:div[@xml:id = 'text']"/>
            </div>
            <div class="col-lg-5">
                <div class="carousel-container">
                    <div id="carouselExampleCaptions" class="carousel slide carousel-fade">
                        <div class="carousel-indicators">
                            <xsl:for-each select="tei:div[@xml:id = 'img']/tei:figure">
                                <button type="button" data-bs-target="#carouselExampleCaptions"
                                    data-bs-slide-to="{position() - 1}"
                                    class="{if (position() = 1) then 'active' else ''}"
                                    aria-label="Slide {position()}"/>
                            </xsl:for-each>
                        </div>
                        <div class="carousel-inner">
                            <xsl:for-each select="tei:div[@xml:id = 'img']/tei:figure">
                                <div>
                                    <xsl:attribute name="class">
                                        <xsl:choose>
                                            <xsl:when test="position() = 1">carousel-item
                                                active</xsl:when>
                                            <xsl:otherwise>carousel-item</xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:attribute>
                                    <img class="d-block w-100">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="@source"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="alt">
                                            <xsl:value-of select="tei:desc"/>
                                        </xsl:attribute>
                                    </img>
                                    <div class="carousel-caption d-none d-md-block">
                                        <p>
                                            <xsl:value-of select="tei:p"/>
                                        </p>
                                    </div>
                                </div>
                            </xsl:for-each>
                        </div>
                        <button class="carousel-control-prev" type="button"
                            data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
                            <span class="carousel-control-prev-icon" aria-hidden="true"/>
                            <span class="visually-hidden">Previous</span>
                        </button>
                        <button class="carousel-control-next" type="button"
                            data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
                            <span class="carousel-control-next-icon" aria-hidden="true"/>
                            <span class="visually-hidden">Next</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:table[@type = 'vol_rev']">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:choose>
                            <xsl:when test="position() = 1">
                                <xsl:for-each select="tei:cell">
                                    <th>
                                        <xsl:value-of select="."/>
                                    </th>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="tei:cell">
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <th>
                                                <xsl:value-of select="."/>
                                            </th>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td>
                                                <xsl:choose>
                                                  <xsl:when test="tei:ref">
                                                  <a href="{tei:ref/@target}">
                                                  <xsl:value-of select="tei:ref"/>
                                                  </a>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of select="."/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
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

    <xsl:template match="tei:table[@type = 'pers']">
        <div class="table-responsive">
            <table>
                <xsl:for-each select="tei:row">
                    <tr>
                        <xsl:if test="@n = '0'">
                            <xsl:for-each select="tei:cell">
                                <th>
                                    <xsl:apply-templates/>
                                </th>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="@n != '0'">
                            <xsl:for-each select="tei:cell">
                                <td>
                                    <xsl:apply-templates/>
                                </td>
                            </xsl:for-each>
                        </xsl:if>
                    </tr>
                </xsl:for-each>
            </table>
        </div>
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

    <xsl:template match="tei:gi">
        <code><xsl:apply-templates/></code>
    </xsl:template>

    <xsl:template match="tei:head">
        <h2>
            <xsl:value-of select="."/>
        </h2>
    </xsl:template>

    <xsl:template match="tei:list[@type = 'unordered']">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:list[@type = 'ordered']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:value-of select="."/>
        </li>
    </xsl:template>


</xsl:stylesheet>

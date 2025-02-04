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
        <xsl:variable name="doc_title" select="'Nuntiatur Pius XI - Digitale Edition'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <meta name="description"
                    content="Recherchieren Sie in der digitalen Edition der Nuntiatur Pius XI., einer frei zugänglichen Sammlung der Korrespondenz des Papstes aus der Zwischenkriegszeit."/>
                <style>
                    .nunt-link:hover {
                        background-color: #f8f9fa !important;
                    }</style>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <div class="container col-xxl-8 pt-3">
                        <div class="row flex-lg-row align-items-center g-5 py-3">
                            <div class="col-lg-6">
                                <h1 class="lh-base">
                                    <span class="display-6">Nuntiatur Pius XI</span>
                                    <br/>
                                    <span class="display-4">Korrespondenz</span>
                                    <br/>
                                    <span class="display-6">XXXX-XXXX</span>
                                </h1>
                                <p class="text-end">Bearbeitet von Bernhard Kronegger</p>
                                <xsl:apply-templates select="//tei:body//tei:p[@style = 'big']"/>
                                <xsl:apply-templates select="//tei:body//tei:p[@style = 'small']"/>
                                <div class="d-grid gap-2 d-md-flex justify-content-md-start">
                                    <a href="search.html" type="button"
                                        class="btn btn-warning px-4 me-md-2">Volltextsuche</a>
                                    <a href="correspaction.html" type="button"
                                        class="btn btn-outline-warning px-4" style="color: black;"
                                        >Zu den Dokumenten</a>
                                    <div class="dropdown">
                                        <button class="btn dropdown-toggle"
                                            style="background-color: #ffe485" type="button"
                                            data-bs-toggle="dropdown" aria-expanded="false">Zu
                                            anderen Nuntiaturen</button>
                                        <ul class="dropdown-menu">
                                            <li>
                                                <a class="dropdown-item nunt-link"
                                                  style="background-color: #e0e0e0"
                                                  href="https://grazer-nuntiatur.acdh.oeaw.ac.at/"
                                                  >Grazer Nuntiatur</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-10 col-sm-8 col-lg-6" style="text-align: center;">
                                <xsl:apply-templates select="//tei:figure"/>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p[@style = 'big']">
        <p class="lead">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:p[@style = 'small']">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:figure">
        <figure class="figure">
            <img class="d-block mx-lg-auto img-fluid rounded" loading="lazy">
                <xsl:attribute name="src">
                    <xsl:value-of select="@source"/>
                </xsl:attribute>
                <xsl:attribute name="alt">
                    <xsl:text>Portrait von Pius XI</xsl:text>
                </xsl:attribute>
            </img>
            <figcaption class="figure-caption pt-3 text-center" style="width: 370px;">
                <xsl:value-of select="tei:desc"/>
            </figcaption>
        </figure>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Suche'"/>
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <meta name="description"
                    content="Durchsuchen Sie die Nuntiatur Pius XI. mit einer facettierten Volltextsuche, womit Suchergebnisse nach verschiedenen Kategorien gefiltert werden können."
                />
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <div class="container">
                        <div class="text-center">
                            <h1 class="text-center my-4">
                                <xsl:value-of select="$doc_title"/>
                            </h1>
                            <div id="searchbox"/>
                            <div id="stats-container"/>
                            <div id="current-refinements"/>
                            <div id="clear-refinements"/>
                        </div>

                        <div class="row">
                            <div id="pagination" class="p-3"/>
                        </div>

                        <div class="row">
                            <div class="col-md-3">
                                <h2>Facetten</h2>
                                <div id="refinement-list-author" class="pb-3"/>
                                <div id="refinement-list-receiver" class="pb-3"/>
                                <div id="refinement-list-year" class="pb-3"/>
                            </div>
                            <div class="col-md-9">
                                <div id="hits"/>
                            </div>
                        </div>

                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css"/>
                <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.46.0"/>
                <script src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"/>
                <script src="js/search.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

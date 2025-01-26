<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/tooltip_js.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Dokumente'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link href="https://unpkg.com/tabulator-tables@6.2.5/dist/css/tabulator.min.css"
                    rel="stylesheet"/>
                <link
                    href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.10.5/font/bootstrap-icons.min.css"
                    rel="stylesheet"/>
                <style>
                    /* Überschrift */
                    .header-container {
                        display: flex;
                        justify-content: center;
                        position: relative;
                        align-items: center;
                    }
                    
                    /* Loader */
                    #loader {
                        position: fixed;
                        left: 50%;
                        top: 50%;
                        width: 50px;
                        height: 50px;
                        margin-left: -25px;
                        margin-top: -25px;
                        border: 4px solid rgba(0, 0, 0, .1);
                        border-radius: 50%;
                        border-top-color: #3498db;
                        animation: spin 1s infinite linear;
                        z-index: 1000;
                    }
                    @keyframes spin {
                    to { transform: rotate(360deg); }
                    }
                    
                    /* Tabelle */
                    .tabulator-tableholder {
                        overflow-x: hidden !important;
                    }
                    #tabulator-table-correspaction {
                        background-color: #ffedad !important;
                    }
                    .tabulator-header {
                        margin-left: 4px !important;
                    }
                    .tabulator-headers {
                        padding: 0 !important;
                    }
                    .tabulator-col-sorter-element {
                        background-color: #ffedad !important;
                    }
                    .tabulator-row.tabulator-row-even {
                        background-color: #FFF6D6 !important;
                    }
                    .tabulator-row.tabulator-row-even:hover {
                        background-color: #bbb !important;
                    }
                    .tabulator-page-counter {
                        background-color: inherit !important;
                    }
                    .tabulator-paginator {
                        background-color: inherit !important;
                    }
                    .tabulator-footer {
                        background-color: #ffedad !important;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container my-4">
                        <div class="header-container">
                            <h1 class="text-center mb-0">Alle Dokumente</h1>
                            <span id="tooltip" title="Alle Filter zurücksetzen"
                                data-bs-placement="top">
                                <button id="reset-filters" class="btn btn-lg" type="button">
                                    <i class="bi bi-x-square-fill"/>
                                </button>
                            </span>
                        </div>
                    </div>
                    <div id="loader"/>
                    <div style="display: block; justify-content: center; margin: 0 2em;"
                        id="tabulator-table-wrapper">
                        <table class="table table-sm display" id="tabulator-table-correspaction">
                            <thead>
                                <tr>
                                    <th scope="col">Archivnummer</th>
                                    <th scope="col">Dokumenttyp</th>
                                    <th scope="col">Titel</th>
                                    <th scope="col">Schlagwort</th>
                                    <th scope="col">Sender</th>
                                    <th scope="col">Empfänger</th>
                                    <th scope="col">Sendedatum</th>
                                    <th scope="col">Sendeort</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection($collectionPath)/tei:TEI">
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)"/>
                                    </xsl:variable>
                                    <xsl:variable name="filename"
                                        select="substring-before(tokenize($full_path, '/')[last()], '.xml')"/>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="$filename"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="descendant::tei:text/@type"/>
                                        </td>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:value-of select="concat($filename, '.html')"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title/text()"
                                                />
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:for-each
                                                select="descendant::tei:msContents/tei:msItem/tei:note[@type = 'keyword']">
                                                <xsl:value-of select="normalize-space(.)"/>
                                                <xsl:if test="position() != last()">
                                                  <xsl:text>, </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </td>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'sent']/tei:persName[1]/@ref"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'sent']/tei:persName[1]"
                                                />
                                            </a>
                                        </td>
                                        <td>
                                            <a target="_blank">
                                                <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1]/@ref"
                                                  />
                                                </xsl:attribute>
                                                <xsl:value-of
                                                  select="descendant::tei:correspDesc/tei:correspAction[@type = 'received']/tei:persName[1]"
                                                />
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="descendant::tei:correspDesc/tei:correspAction[@type = 'sent']/tei:date/@when"
                                            />
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="descendant::tei:correspAction[@type = 'sent']/tei:placeName"
                                            />
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                    <xsl:call-template name="html_tabulator_dl_buttons"/>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js_correspaction"/>
                <xsl:call-template name="tooltip"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

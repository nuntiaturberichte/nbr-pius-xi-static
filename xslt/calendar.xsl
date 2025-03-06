<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/yearCalendar_js.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Kalender'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <meta name="description"
                    content="Nutzen Sie die Kalenderansicht der Nuntiatur Pius XI, um historische Korrespondenzen und wichtige Ereignisse der Vorkriegszeit nach Datum zu erkunden."/>
                <link rel="stylesheet" type="text/css"
                    href="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.css"/>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
                <style>
                    .btn:hover {
                        background-color: #f8c400 !important;
                    }
                    .btn:focus {
                        background-color: #f8c400 !important;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="card mt-4">
                            <div class="card-header"
                                style="text-align:center; background-color: #ffedad;">
                                <h1 style="display:inline-block;margin-bottom:0;padding-right:5px;"
                                    >Kalender</h1>
                                <a style="padding-left:5px;" href="js-data/calendarData.js">
                                    <i class="fas fa-download" title="Kalenderdaten herunterladen"
                                        style="color: black;"/>
                                </a>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-sm-2 yearscol" style="width: 18%;">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p
                                                  style="text-align: center; font-weight: bold; margin-bottom: 0;"
                                                  >Jahr</p>
                                            </div>
                                            <div class="col-sm-12">
                                                <div class="row justify-content-md-center"
                                                  id="years-table"/>
                                            </div>
                                            <div class="col-sm-12 mt-4">
                                                <p
                                                  style="text-align: center; font-weight: bold; margin-bottom: 0;"
                                                  >Dokumenttyp</p>
                                                <ul class="list-unstyled">
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color:#0d6efd; margin-right:10px;"
                                                  />Brief</li>
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color:#C74343; margin-right:10px;"
                                                  />Bericht</li>
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color:#6AB547; margin-right:10px;"
                                                  />Telegramm</li>
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color:#7B287D; margin-right:10px;"
                                                  />Archivnotiz</li>
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color:#f8c400; margin-right:10px;"
                                                  />Provvista</li>
                                                  <li>
                                                  <span
                                                  style="display:inline-block; width:20px; height:20px; background-color: black; margin-right:10px;"
                                                  />Sonstiges</li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-10" style="width: 80%;">
                                        <div id="calendar"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="loadModal"/>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="yearCalendar_js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>

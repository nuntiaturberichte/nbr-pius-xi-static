<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/download_pdf_js.xsl"/>
    <xsl:import href="./partials/tooltip_js.xsl"/>
    <xsl:import href="./partials/position_annotation_js.xsl"/>
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </xsl:variable>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
                    rel="stylesheet"/>
                <style>
                    /* Beschreibungs-Tabelle Anfang */
                    table {
                        width: 100%;
                        font-size: 14px;
                    }
                    
                    table th,
                    table td {
                        padding: 10px;
                        border: 1px solid #dee2e6;
                        text-align: left;
                    }
                    
                    table th {
                        background-color: #FFFBEB;
                        text-align: center;
                        font-weight: bold;
                    }
                    
                    table tr:nth-child(even) {
                        background-color: #FFFBEB;
                    }
                    /* Beschreibungs-Tabelle Ende */
                    
                    /* Text Anfang */
                    .row {
                        display: flex;
                        position: relative; /* Ermöglicht absolute Positionierung der Anmerkungen */
                    }
                    
                    .col-10 {
                        width: 80%;
                        position: relative; /* Referenz für absolute Positionierung */
                    }
                    
                    .col-2 {
                        width: 20%;
                        position: relative; /* Referenz für absolute Positionierung */
                    }
                    
                    .annotated-word {
                        background-color: #f0f8ff; /* Optional: Markierung des Wortes */
                        padding: 0.1rem;
                        cursor: pointer;
                        position: relative;
                    }
                    
                    .annotation {
                        position: absolute; /* Ermöglicht dynamische Platzierung */
                        font-size: 0.9em;
                        color: #666;
                        white-space: nowrap; /* Optional: Verhindert Zeilenumbruch */
                    }
                    /* Text Ende */</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="card mt-5">
                            <div class="card-header" style="background-color: #FFEDAD">
                                <div class="row align-items-center" id="title-nav">
                                    <!-- LINKS -->
                                    <div class="col-auto d-flex justify-content-start">
                                        <h1>
                                            <nav class="navbar navbar-previous-next">
                                                <i class="bi bi-arrow-left nav-link float-start"
                                                  id="navbarDropdownLeft" role="button"
                                                  data-bs-toggle="dropdown" aria-expanded="false"/>
                                                <ul class="dropdown-menu unstyled"
                                                  aria-labelledby="navbarDropdown">
                                                  <!-- "Vorheriger Brief" -->
                                                  <span class="dropdown-item-text">Vorheriger
                                                  Brief</span>
                                                  <!-- Listenpunkt für direkten Vorfolger -->
                                                  <li>
                                                  <xsl:if
                                                  test="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCollection']/@target">
                                                  <!-- Link und Linktext zum direkten Vorfolger -->
                                                  <a id="prev-doc" class="dropdown-item">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(substring-before(//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCollection']/@target, '.xml'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="bi bi-arrow-left">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCollection']"
                                                  />
                                                  </i>
                                                  </a>
                                                  </xsl:if>
                                                  </li>
                                                  <!-- "... in der Korrespondenz" -->
                                                  <span class="dropdown-item-text">… in der
                                                  Korrespondenz</span>
                                                  <!-- Listenpunkt für Korrespondenz-Vorfolger -->
                                                  <li>
                                                  <xsl:if
                                                  test="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCorrespondence']/@target">
                                                  <!-- Link und Linktext zum Korrespondenz-Vorfolger -->
                                                  <a id="prev-doc2" class="dropdown-item">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(substring-before(//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCorrespondence']/@target, '.xml'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="bi bi-arrow-left">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'previous_letter' and @type = 'withinCorrespondence']"
                                                  />
                                                  </i>
                                                  </a>
                                                  </xsl:if>
                                                  </li>
                                                </ul>
                                            </nav>
                                        </h1>
                                    </div>

                                    <!-- MITTE -->
                                    <div
                                        class="col d-flex justify-content-center align-items-center text-center"
                                        id="heading">
                                        <h1>
                                            <xsl:value-of
                                                select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"
                                            />
                                        </h1>
                                        <xsl:if
                                            test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level = 'a' and @type = 'appendix']">
                                            <span>
                                                <em>
                                                  <xsl:value-of
                                                  select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@level = 'a' and @type = 'appendix']"
                                                  />
                                                </em>
                                            </span>
                                        </xsl:if>
                                    </div>

                                    <!-- RECHTS -->
                                    <div class="col-auto d-flex justify-content-end">
                                        <h1>
                                            <nav class="navbar navbar-previous-next">
                                                <i class="bi bi-arrow-right nav-link float-start"
                                                  id="navbarDropdownLeft" role="button"
                                                  data-bs-toggle="dropdown" aria-expanded="false"/>
                                                <ul class="dropdown-menu dropdown-menu-end unstyled"
                                                  aria-labelledby="navbarDropdownLeft">
                                                  <!-- "Nächster Brief" -->
                                                  <span class="dropdown-item-text">Nächster
                                                  Brief</span>
                                                  <!-- Listenpunkt für direkten Nachfolger -->
                                                  <li>
                                                  <xsl:if
                                                  test="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCollection']/@target">
                                                  <!-- Link und Linktext zum direkten Nachfolger -->
                                                  <a id="prev-doc" class="dropdown-item">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(substring-before(//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCollection']/@target, '.xml'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="bi bi-arrow-right">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCollection']"
                                                  />
                                                  </i>
                                                  </a>
                                                  </xsl:if>
                                                  </li>
                                                  <!-- "... in der Korrespondenz" -->
                                                  <span class="dropdown-item-text">… in der
                                                  Korrespondenz</span>
                                                  <!-- Listenpunkt für Korrespondenz-Vorfolger -->
                                                  <li>
                                                  <xsl:if
                                                  test="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCorrespondence']/@target">
                                                  <!-- Link und Linktext zum Korrespondenz-Vorfolger -->
                                                  <a id="prev-doc2" class="dropdown-item">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="concat(substring-before(//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCorrespondence']/@target, '.xml'), '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <i class="bi bi-arrow-right">
                                                  <xsl:value-of
                                                  select="//tei:correspDesc/tei:correspContext/tei:ref[@subtype = 'next_letter' and @type = 'withinCorrespondence']"
                                                  />
                                                  </i>
                                                  </a>
                                                  </xsl:if>
                                                  </li>
                                                </ul>
                                            </nav>
                                        </h1>
                                    </div>
                                </div>
                            </div>

                            <div id="letter-body">

                                <!-- Beschreibung Anfang -->
                                <div id="description" class="card-body">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th colspan="2">Beschreibung</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:if test="//tei:text/@type">
                                                <tr>
                                                  <td>Art des Dokuments</td>
                                                  <td>
                                                  <!-- Brief -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:text/@type = 'Brief'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Brief</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Brief</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Bericht -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:text/@type = 'Bericht'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Bericht</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Bericht</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Telegramm -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:text/@type = 'Telegramm'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Telegramm</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Telegramm</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Archivsnotiz -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:text/@type = 'Archivsnotiz'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Archivsnotiz</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Archivsnotiz</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Provvista -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:text/@type = 'Provvista'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Provvista</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Provvista</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="//tei:physDesc/tei:scriptDesc">
                                                <tr>
                                                  <td>Ausführung</td>
                                                  <td>
                                                  <!-- Maschinenschriftlich -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:physDesc/tei:scriptDesc/tei:ab = 'Maschinenschriftlich'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Maschinenschriftlich</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Maschinenschriftlich</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Handschriftlich -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:physDesc/tei:scriptDesc/tei:ab = 'Handschriftlich'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Handschriftlich</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Handschriftlich</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Gesetzt -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:physDesc/tei:scriptDesc/tei:ab = 'Gesetzt'">
                                                  <span
                                                  style="background-color: black; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Gesetzt</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Gesetzt</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if test="//tei:msDesc/@type">
                                                <tr>
                                                  <td>Status des Dokuments</td>
                                                  <td>
                                                  <!-- Reinschrift -->
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:msDesc/@type = 'Reinschrift'">
                                                  <span
                                                  style="background-color: #599B6C; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Reinschrift</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Reinschrift</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Konzept -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:msDesc/@type = 'Konzept'">
                                                  <span
                                                  style="background-color: #FF5A1F; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  >Konzept</span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Konzept</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>

                                                  <!-- Separator -->
                                                  <xsl:text>,&#160;</xsl:text>

                                                  <!-- Abschrift -->
                                                  <xsl:choose>
                                                  <xsl:when test="//tei:msDesc/@type = 'Abschrift'">
                                                  <span
                                                  style="background-color: #ADADAD; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;"
                                                  > Abschrift </span>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <span style="color: #d3d3d3; font-size: 0.9em;"
                                                  >Abschrift</span>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:for-each select="//tei:correspDesc">
                                                <tr>
                                                  <td>Kommunikationsweg</td>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent'] and tei:correspAction[@type = 'received']">
                                                  <td style="text-align: center;">
                                                  <!-- Sender -->
                                                  <div style="margin-bottom: 1em;">
                                                  <strong>von:&#160;</strong>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:persName/@ref">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:persName/@ref"
                                                  />
                                                  </xsl:if>
                                                  </xsl:attribute>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:persName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:persName"
                                                  />
                                                  </xsl:if>
                                                  </a>
                                                  <xsl:text>&#160;-&#160;</xsl:text>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:placeName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:placeName"
                                                  />
                                                  </xsl:if>
                                                  <xsl:text>,&#160;</xsl:text>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:date">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:date"
                                                  />
                                                  </xsl:if>
                                                  </div>

                                                  <!-- Pfeil -->
                                                  <div
                                                  style="font-size: 1.5em; color: gray; margin: 1em 0;">
                                                  <i class="bi bi-arrow-down"/>
                                                  </div>

                                                  <!-- Empfänger -->
                                                  <div style="margin-bottom: 1em;">
                                                  <strong>an:&#160;</strong>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:persName/@ref">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:persName/@ref"
                                                  />
                                                  </xsl:if>
                                                  </xsl:attribute>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:persName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:persName"
                                                  />
                                                  </xsl:if>
                                                  </a>
                                                  <xsl:text>&#160;-&#160;</xsl:text>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:placeName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:placeName"
                                                  />
                                                  </xsl:if>
                                                  <xsl:text>,&#160;</xsl:text>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:date">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:date"
                                                  />
                                                  </xsl:if>
                                                  </div>
                                                  </td>
                                                  </xsl:if>
                                                </tr>
                                            </xsl:for-each>
                                            <xsl:if test="//tei:msIdentifier/tei:repository">
                                                <tr>
                                                  <td>Quelle</td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="//tei:msIdentifier/tei:repository"/>
                                                  <xsl:if
                                                  test="//tei:msIdentifier/tei:idno[@type = 'archive']">
                                                  <xsl:text>;&#160;</xsl:text>
                                                  <xsl:value-of
                                                  select="//tei:msIdentifier/tei:idno[@type = 'archive']"
                                                  />
                                                  </xsl:if>
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if
                                                test="//tei:msIdentifier/tei:idno[@type = 'institutional' and @subtype = 'internal']">
                                                <tr>
                                                  <td>Interne Nummerierung</td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="//tei:msIdentifier/tei:idno[@type = 'institutional' and @subtype = 'internal']"
                                                  />
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                            <xsl:if
                                                test="//tei:msIdentifier/tei:idno[@type = 'institutional' and @subtype = 'external']">
                                                <tr>
                                                  <td>Externe Nummerierung</td>
                                                  <td>
                                                  <xsl:value-of
                                                  select="//tei:msIdentifier/tei:idno[@type = 'institutional' and @subtype = 'external']"
                                                  />
                                                  </td>
                                                </tr>
                                            </xsl:if>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Beschreibung Ende -->

                                <!-- Regest Anfang -->

                                <xsl:if test="//tei:profileDesc/tei:abstract/tei:p">
                                    <div id="abstract" class="card-body">
                                        <h3>Regest</h3>
                                        <xsl:for-each select="//tei:profileDesc/tei:abstract/tei:p">
                                            <p>
                                                <em>
                                                  <xsl:apply-templates/>
                                                </em>
                                            </p>
                                        </xsl:for-each>


                                        <!-- Regest Ende -->

                                        <!-- Schlagworte Anfang -->

                                        <xsl:if
                                            test="//tei:msContents/tei:msItem/tei:note[@type = 'keyword']">
                                            <p>
                                                <xsl:for-each
                                                  select="//tei:msContents/tei:msItem/tei:note[@type = 'keyword']">
                                                  <span
                                                  style="background-color: #54457F; color: #fff; padding: 0.1em 0.4em; border-radius: 0.2em; font-size: 0.9em;">
                                                  <xsl:value-of select="."/>
                                                  </span>
                                                  <xsl:text>&#160;</xsl:text>
                                                </xsl:for-each>
                                            </p>
                                        </xsl:if>
                                        <hr/>
                                    </div>
                                </xsl:if>

                                <!-- Schlagworte Ende -->

                                <!-- Text Anfang -->

                                <div class="card-body">
                                    <h2>Text</h2>

                                    <!-- opener Anfang -->
                                    <xsl:if test="//tei:body/tei:opener">
                                        <div id="opener">
                                            <xsl:apply-templates
                                                select="//tei:text/tei:body/tei:opener"/>
                                        </div>
                                    </xsl:if>
                                    <!-- opener Ende -->

                                    <div id="text">
                                        <div class="row">
                                            <!-- Fließtext -->
                                            <div class="col-10">
                                                <xsl:apply-templates
                                                  select="//tei:body/*[not(self::tei:note[@type = 'foliation']) and not(self::tei:opener)]"
                                                />
                                            </div>
                                            <!-- Anmerkungen -->
                                            <div class="col-2">
                                                <xsl:apply-templates
                                                  select="//tei:note[@type = 'foliation']"/>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <!-- Text Ende -->

                                <!-- Legende Anfang -->

                                <div id="legend" class="card-body">
                                    <h3>Legende</h3>
                                    <!-- mit ifs prüfen -->
                                </div>

                                <!-- Legende Ende -->








                                <xsl:if test="//tei:note">
                                    <hr/>
                                    <div id="footnotes-apparatus" class="card-body">
                                        <h3>Fußnoten</h3>
                                        <ul class="list-unstyled">
                                            <xsl:for-each select="//tei:note">
                                                <xsl:if test="@type = 'footnote'">
                                                  <xsl:variable name="fnSign"
                                                  select="number(substring-after(substring-after(@xml:id, '_'), '_'))"/>
                                                  <xsl:variable name="fnId" select="@xml:id"/>
                                                  <li id="{$fnId}_app" href="#{$fnId}_con">
                                                  <sup>
                                                  <span class="badge bg-primary">
                                                  <xsl:value-of select="number($fnSign)"/>
                                                  </span>
                                                  </sup>&#160;<xsl:value-of
                                                  select="normalize-space(.)"/>&#160;<a
                                                  href="#{$fnId}_con"><i class="bi bi-arrow-up"
                                                  /></a>
                                                  </li>
                                                </xsl:if>
                                                <xsl:if test="@type = 'siglum'">
                                                  <xsl:variable name="sSign"
                                                  select="substring-after(substring-after(@xml:id, '_'), '_')"/>
                                                  <xsl:variable name="sId" select="@xml:id"/>
                                                  <li id="{$sId}_app" href="#{$sId}_con">
                                                  <sup>
                                                  <span class="badge bg-primary">
                                                  <xsl:value-of select="$sSign"/>
                                                  </span>
                                                  </sup>&#160;<xsl:value-of
                                                  select="normalize-space(.)"/>&#160;<a
                                                  href="#{$sId}_con"><i class="bi bi-arrow-up"/></a>
                                                  </li>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </xsl:if>
                            </div>
                            <div class="card-footer" style="background-color: #FFEDAD">
                                <div class="row">
                                    <div class="col-12 col-md-4 d-flex justify-content-start">
                                        <h4>Download</h4>
                                    </div>
                                    <div class="col-12 col-md-4 d-flex justify-content-center">
                                        <a
                                            href="https://grazer-nuntiatur.acdh.oeaw.ac.at/{concat(//tei:TEI/@xml:id, '.xml')}"
                                            target="_blank" style="color: black;">
                                            <i class="fas fa-file-code fa-2x"
                                                title="XML herunterladen"/>&#160;<xsl:value-of
                                                select="concat(//tei:TEI/@xml:id, '.xml')"/>
                                        </a>
                                    </div>
                                    <div class="col-12 col-md-4 d-flex justify-content-center">
                                        <a href="#" id="downloadPdf" style="color: black;">
                                            <i class="fas fa-file-pdf fa-2x"
                                                title="PDF herunterladen"/>&#160;<span
                                                id="pdfFileName">
                                                <xsl:value-of
                                                  select="concat(//tei:TEI/@xml:id, '.pdf')"/>
                                            </span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="download_pdf"/>
                <xsl:call-template name="tooltip"/>
                <xsl:call-template name="position_annotation"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:seg[@type = 'subjectLine']">
        <strong class="d-block mb-4">
            <xsl:value-of select="."/>
        </strong>
    </xsl:template>

    <xsl:template match="tei:salute">
        <p>
            <xsl:value-of select="."/>
        </p>
    </xsl:template>

    <xsl:template match="tei:pb">
        <sub>
            <span class="badge bg-warning">
                <xsl:value-of select="@n"/>
            </span>
        </sub>
    </xsl:template>

    <xsl:template match="tei:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:list/tei:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'foliation']">
        <sub>
            <span class="badge bg-secondary annotated-word">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </span>
        </sub>
        <xsl:if test="@rend">
            <div class="annotation">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@rend"/>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- zu Entstehungsprozess - Anfang -->

    <!-- Unterstreichung Anfang -->
    <xsl:template match="tei:hi[@rend = 'underline']">
        <span style="text-decoration: underline;">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <!-- Unterstreichung Ende -->


    <!-- zu Entstehungsprozess - Ende -->










    <xsl:template match="tei:lb[position() > 1]">
        <br/>
    </xsl:template>



    <xsl:template match="tei:note[@type = 'footnote']">
        <xsl:variable name="fnSign" select="substring-after(substring-after(@xml:id, '_'), '_')"/>
        <xsl:variable name="fnId" select="@xml:id"/>
        <a class="footnote" id="{$fnId}_con" href="#{$fnId}_app" title="{normalize-space(.)}">
            <sup>
                <span class="badge bg-primary">
                    <xsl:value-of select="number($fnSign)"/>
                </span>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'siglum']">
        <xsl:variable name="sSign" select="substring-after(substring-after(@xml:id, '_'), '_')"/>
        <xsl:variable name="sId" select="@xml:id"/>
        <a class="siglum" id="{$sId}_con" href="#{$sId}_app" title="{normalize-space(.)}">
            <sup>
                <span class="badge bg-primary">
                    <xsl:value-of select="$sSign"/>
                </span>
            </sup>
        </a>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:variable name="sRefSign" select="substring-after(substring-after(@xml:id, '_'), '_')"/>
        <xsl:variable name="refId" select="@target"/>
        <a class="siglum-ref" href="{$refId}">
            <sup>
                <span class="badge bg-primary">
                    <xsl:value-of select="$sRefSign"/>
                </span>
            </sup>
        </a>
    </xsl:template>



</xsl:stylesheet>

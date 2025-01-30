<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/download_pdf_js.xsl"/>
    <xsl:import href="./partials/tooltip_js.xsl"/>
    <xsl:import href="./partials/position_annotation_js.xsl"/>
    <xsl:import href="partials/highlight_annotation_js.xsl"/>
    <xsl:import href="partials/scroll_offset_js.xsl"/>
    <xsl:import href="partials/limit_toc_legend_div_js.xsl"/>
    <xsl:import href="partials/toggle_view_js.xsl"/>
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
                    .container {
                        position: relative;
                        display: block;
                    }
                    
                    .card {
                        position: relative;
                    }
                    
                    /* Inhaltsverzeichnis Beginn */
                    
                    .toc {
                        position: fixed;
                        top: 148px;
                        left: 1vw;
                        width: 250px;
                        background-color: #ffedad;
                        padding: 15px;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                    }
                    
                    .toc a {
                        display: block;
                        padding: 8px 12px;
                        text-decoration: none;
                        color: black;
                        transition: background-color 0.3s, color 0.3s;
                    }
                    
                    .toc a:hover {
                        background-color: #f8c400;
                        border-radius: 5px;
                    }
                    
                    .toc a:active {
                        background-color: black;
                    }
                    
                    /* Inhaltsverzeichnis Ende */
                    
                    /* Legende schmal Beginn */
                    
                    .legend-slim {
                        position: fixed;
                        top: 148px;
                        right: 1vw;
                        width: 250px;
                    }
                    
                    .legend-slim th {
                        background-color: #ffedad
                    }
                    
                    /* Legende schmal Ende */
                    
                    /* Legende breit Anfang */
                    .legend-broad {
                        display: none;
                    }
                    
                    @media (max-width : 1810px) {
                        .legend-broad {
                            display: block;
                        }
                    }
                    /* Legende breit Anfang */
                    
                    /* Handling toc und legend bezüglich Bildschirmbreite Anfang */
                    @media (max-width : 1840px) {
                        .toc {
                            left: 5px;
                        }
                        .legend-slim {
                            right: 5px;
                        }
                    }
                    
                    @media (max-width : 1810px) {
                        .legend-slim.toggle-content,
                        .toc {
                            display: none;
                        }
                    }
                    /* Handling toc und legend bezüglich Bildschirmbreite Ende */
                    
                    /* Beschreibungs-Tabelle Anfang */
                    table {
                        width: 100%;
                        font-size: 14px;
                        border-collapse: separate;
                        border-spacing: 0;
                        border-radius: 7px;
                        overflow: hidden;
                        border: 1px solid #ddd;
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
                        flex: 10;
                        position: relative;
                    }
                    
                    .col-2 {
                        flex: 2;
                        position: relative;
                    }
                    
                    @media (max-width : 550px) {
                        .col-2 {
                            display: none;
                        }
                    
                        .col-10 {
                            flex: 1;
                            border-right: none !important;
                        }
                    }
                    
                    .annotation {
                        background-color: #e0e0e0;
                        border-radius: 5px;
                        border: 1px solid #ddd;
                    }
                    
                    /* Adaption für Leseansicht Anfang*/
                    .col-12 {
                        border-right: none !important;
                    }
                    
                    .toggle-content {
                        display: inline;
                    }
                    
                    /* Unterstreichung */
                    .no-annotations.toggle-content[style *= "text-decoration: underline;"] {
                        display: inline;
                        text-decoration: none !important;
                    }
                    /* Markierung */
                    .no-annotations.toggle-content[style *= "background-color: #ffedad; border-radius: 5px;"] {
                        display: inline;
                        background-color: transparent !important;
                    }
                    /* Ersetzung */
                    .no-annotations.toggle-content[style *= "border: black 1px dotted; border-radius: 5px;"] {
                        display: inline;
                        border: none !important;
                    }
                    /* Einfügung */
                    .no-annotations.toggle-content[style *= "border-radius: 5px; background-color: #CBE1D1"] {
                        display: inline;
                        background-color: transparent !important;
                    }
                    
                    .no-annotations.toggle-content {
                        display: none;
                    }
                    /* Adaption für Leseansicht Ende */
                    
                    /* Text Ende */
                    
                    /* Annotation-Hervorhebung Anfang */
                    .highlight {
                        border: 1px solid black !important;
                        border-radius: 5px
                    }
                    
                    .col-2 .highlight {
                        background-color: #999999;
                        border: 1px solid black !important;
                        border-radius: 5px
                    }
                    /* Annotation-Hervorhebung Ende */</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">

                        <!-- Inhaltsverzeichnis Anfang -->

                        <div class="toc">
                            <h2>Inhalt</h2>
                            <ul class="list-unstyled" style="margin-bottom: 0px;">
                                <xsl:if
                                    test="//tei:text/@type | //tei:physDesc/tei:scriptDesc | //tei:msDesc/@type | //tei:correspAction | //tei:msIdentifier/tei:repository | //tei:msIdentifier/tei:idno">
                                    <li>
                                        <a href="#description">Beschreibung</a>
                                    </li>
                                </xsl:if>
                                <xsl:if test="//tei:profileDesc/tei:abstract/tei:p">
                                    <li>
                                        <a href="#abstract">Regest</a>
                                    </li>
                                </xsl:if>
                                <xsl:if test="//tei:text/tei:body/*">
                                    <li>
                                        <a href="#text">Text</a>
                                    </li>
                                </xsl:if>
                                <xsl:if test="//tei:note[@type = 'footnote']">
                                    <li>
                                        <a href="#footnotes">Fußnoten</a>
                                    </li>
                                </xsl:if>
                            </ul>
                        </div>

                        <!-- Inhaltsverzeichnis Ende -->

                        <!-- Legende Anfang -->

                        <xsl:if
                            test="//tei:body//tei:pb | //tei:body//tei:note[@type = 'foliation'] | //tei:body//tei:subst | //tei:body//tei:hi[@rend = 'mark'] | //tei:body//tei:hi[@rend = 'underline'] | //tei:body//tei:note[@type = 'footnote'] | //tei:body//tei:del | //tei:body//tei:gap | //tei:body//tei:add">
                            <div class="legend-slim toggle-content">
                                <table>
                                    <colgroup>
                                        <col style="width: 40%;"/>
                                        <col style="width: 60%;"/>
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th colspan="2">Legende</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:if test="//tei:body//tei:pb">
                                            <tr>
                                                <td>
                                                  <span class="badge bg-warning"
                                                  style="font-size: 10px; padding: 2px 4px; line-height: 1.5"
                                                  >n</span>
                                                </td>
                                                <td>Seitenbeginn</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:note[@type = 'foliation']">
                                            <tr>
                                                <td>
                                                  <span class="badge bg-secondary"
                                                  style="font-size: 10px; padding: 2px 4px; line-height: 1.5"
                                                  >n</span>
                                                </td>
                                                <td>Folierungsnummer des Archivs</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:note[@type = 'footnote']">
                                            <tr>
                                                <td>
                                                  <sup>
                                                  <span class="badge bg-primary">n</span>
                                                  </sup>
                                                </td>
                                                <td>Fußnote</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:lb[position() > 1]">
                                            <tr>
                                                <td>&#8629;</td>
                                                <td>Zeilenwechsel</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:hi[@rend = 'underline']">
                                            <tr>
                                                <td>
                                                  <span style="text-decoration: underline;"
                                                  >Text</span>
                                                </td>
                                                <td>Unterstreichung</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:hi[@rend = 'mark']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="background-color: #ffedad; border-radius: 5px;"
                                                  >Text</span>
                                                </td>
                                                <td>Markierung</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:subst">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="border: black 1px dotted; border-radius: 5px;">
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px;"
                                                  >-Text</span>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  >+Text</span>
                                                  </span>
                                                </td>
                                                <td>Ersetzung</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if
                                            test="//tei:body//tei:del[@rend = 'strikethrough'] | //tei:body//tei:gap[@reason = 'strikethrough']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px; text-decoration: line-through;"
                                                  >Text</span>
                                                </td>
                                                <td>Durchstreichung</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if
                                            test="//tei:body//tei:del[@rend = 'overwritten'] | //tei:body//tei:gap[@reason = 'overwritten']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px; color: gray; text-decoration: line-through; text-decoration-style: wavy;"
                                                  >Text</span>
                                                </td>
                                                <td>Überschreibung</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:gap[@unit = 'char']">
                                            <tr>
                                                <td>▯</td>
                                                <td>ein unlesbares Zeichen</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:gap[@unit = 'words']">
                                            <tr>
                                                <td>▭</td>
                                                <td>ein unlesbares Wort</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:add[not(@place)]">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-right"/>Text</span>
                                                </td>
                                                <td>Einfügung in derselben Zeile bzw. über dem alten
                                                  Text</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:add[@place = 'above']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-up"/>Text</span>
                                                </td>
                                                <td>Einfügung über der Zeile</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:add[@place = 'below']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-down"/>Text</span>
                                                </td>
                                                <td>Einfügung unter der Zeile</td>
                                            </tr>
                                        </xsl:if>
                                        <xsl:if test="//tei:body//tei:add[@place = 'margin']">
                                            <tr>
                                                <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-left"/>Text</span>
                                                </td>
                                                <td>Einfügung am Rand</td>
                                            </tr>
                                        </xsl:if>
                                    </tbody>
                                </table>
                            </div>
                        </xsl:if>

                        <!-- Legende Ende -->

                        <div class="card mt-5">

                            <!-- Card Header Anfang -->

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

                            <!-- Card Header Ende -->

                            <div id="letter-body">

                                <!-- Beschreibung Anfang -->
                                <xsl:if
                                    test="//tei:text/@type | //tei:physDesc/tei:scriptDesc | //tei:msDesc/@type | //tei:correspAction | //tei:msIdentifier/tei:repository | //tei:msIdentifier/tei:idno">
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
                                                  >Abschrift</span>
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
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent'] and tei:correspAction[@type = 'received']">
                                                  <tr>
                                                  <td>Kommunikationsweg</td>
                                                  <td style="text-align: center;">
                                                  <!-- Sender -->
                                                  <div style="margin-bottom: 1em;">
                                                  <strong>von:&#160;</strong>
                                                  <a>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:persName/@ref">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:persName/@ref"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:persName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:persName"
                                                  />
                                                  </xsl:if>
                                                  </a>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:placeName">
                                                  <xsl:text>&#160;-&#160;</xsl:text>
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:placeName"
                                                  />
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:date">
                                                  <xsl:text>,&#160;</xsl:text>
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
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:persName/@ref">
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:persName/@ref"
                                                  />
                                                  </xsl:attribute>
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:persName">
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:persName"
                                                  />
                                                  </xsl:if>
                                                  </a>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'received']/tei:placeName">
                                                  <xsl:text>&#160;-&#160;</xsl:text>
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'received']/tei:placeName"
                                                  />
                                                  </xsl:if>
                                                  <xsl:if
                                                  test="tei:correspAction[@type = 'sent']/tei:date">
                                                  <xsl:text>,&#160;</xsl:text>
                                                  <xsl:value-of
                                                  select="tei:correspAction[@type = 'sent']/tei:date"
                                                  />
                                                  </xsl:if>
                                                  </div>
                                                  </td>
                                                  </tr>
                                                  </xsl:if>
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
                                </xsl:if>

                                <!-- Beschreibung Ende -->

                                <!-- Regest Anfang -->

                                <xsl:if test="//tei:profileDesc/tei:abstract">
                                    <div id="abstract" class="card-body">
                                        <h3>Regest</h3>
                                        <xsl:apply-templates select="//tei:abstract" mode="col-10"/>

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
                                    </div>
                                    <hr/>
                                </xsl:if>

                                <!-- Schlagworte Ende -->

                                <!-- Text Anfang -->

                                <xsl:if test="//tei:text/tei:body/*">
                                    <div class="card-body" id="text">
                                        <div
                                            style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 2rem;">
                                            <h2>Text</h2>

                                            <div class="btn-group btn-group-sm" role="group"
                                                aria-label="Ansicht umschalten">
                                                <button id="showAnnotations" class="btn btn-dark"
                                                  >Annotierte Ansicht</button>
                                                <button id="showReadingView"
                                                  class="btn btn-outline-dark">Leseansicht</button>
                                            </div>

                                            <xsl:variable name="fileName"
                                                select="tokenize(document-uri(.), '/')[last()]"/>
                                            <div>
                                                <a id="downloadPdf" class="btn btn-danger btn-sm"
                                                  style="margin-right: .25rem;">
                                                  <span id="pdfFileName" style="display: none;">
                                                  <xsl:value-of
                                                  select="replace(tokenize(document-uri(.), '/')[last()], '.xml$', '.pdf')"
                                                  />
                                                  </span>PDF herunterladen</a>
                                                <a
                                                  href="https://nuntiaturberichte.github.io/nbr-pius-xi-static/{$fileName}"
                                                  target="_blank" class="btn btn-primary btn-sm">XML
                                                  herunterladen</a>
                                            </div>
                                        </div>
                                        <div id="text">
                                            <div class="row">
                                                <!-- Fließtext Anfang -->
                                                <div class="col-10 text-column"
                                                  style="border-right: 1px solid #db2017;">
                                                  <xsl:apply-templates select="//tei:body/*"
                                                  mode="col-10"/>
                                                </div>
                                                <!-- Fließtext Ende -->
                                                <!-- Anmerkungen Anfang -->
                                                <div class="col-2">
                                                  <xsl:apply-templates
                                                  select="//tei:note[@type = 'foliation'] | //tei:signed | //tei:hi[@rend = 'underline'] | //tei:hi[@rend = 'mark'] | //tei:add | //tei:unclear | //tei:body//tei:sic | //tei:corr | //tei:supplied[@reason = 'deciphering']"
                                                  mode="col-2"/>
                                                </div>
                                                <!-- Anmerkungen Ende -->
                                            </div>
                                        </div>
                                    </div>
                                </xsl:if>

                                <!-- Text Ende -->

                                <!-- Legende wenn Breite unter 1810 px Anfang -->
                                <xsl:if
                                    test="//tei:body//tei:pb | //tei:body//tei:note[@type = 'foliation'] | //tei:body//tei:subst | //tei:body//tei:hi[@rend = 'mark'] | //tei:body//tei:hi[@rend = 'underline'] | //tei:body//tei:note[@type = 'footnote'] | //tei:body//tei:del | //tei:body//tei:gap | //tei:body//tei:add">
                                    <div class="legend-broad card-body">
                                        <table>
                                            <colgroup>
                                                <col style="width: 30%;"/>
                                                <col style="width: 70%;"/>
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                  <th colspan="2">Legende</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <xsl:if test="//tei:body//tei:pb">
                                                  <tr>
                                                  <td>
                                                  <span class="badge bg-warning"
                                                  style="font-size: 10px; padding: 2px 4px; line-height: 1.5"
                                                  >n</span>
                                                  </td>
                                                  <td>Seitenbeginn</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:note[@type = 'foliation']">
                                                  <tr>
                                                  <td>
                                                  <span class="badge bg-secondary"
                                                  style="font-size: 10px; padding: 2px 4px; line-height: 1.5"
                                                  >n</span>
                                                  </td>
                                                  <td>Folierungsnummer des Archivs</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:note[@type = 'footnote']">
                                                  <tr>
                                                  <td>
                                                  <sup>
                                                  <span class="badge bg-primary">n</span>
                                                  </sup>
                                                  </td>
                                                  <td>Fußnote</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:lb[position() > 1]">
                                                  <tr>
                                                  <td>&#8629;</td>
                                                  <td>Zeilenwechsel</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:hi[@rend = 'underline']">
                                                  <tr>
                                                  <td>
                                                  <span style="text-decoration: underline;"
                                                  >Text</span>
                                                  </td>
                                                  <td>Unterstreichung</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:hi[@rend = 'mark']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="background-color: #ffedad; border-radius: 5px;"
                                                  >Text</span>
                                                  </td>
                                                  <td>Markierung</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:subst">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="border: black 1px dotted; border-radius: 5px;">
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px;"
                                                  >-Text</span>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  >+Text</span>
                                                  </span>
                                                  </td>
                                                  <td>Ersetzung</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:del[@rend = 'strikethrough'] | //tei:body//tei:gap[@reason = 'strikethrough']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px; text-decoration: line-through;"
                                                  >Text</span>
                                                  </td>
                                                  <td>Durchstreichung</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:del[@rend = 'overwritten'] | //tei:body//tei:gap[@reason = 'overwritten']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="background-color: #F9CBC8; border-radius: 5px; color: gray; text-decoration: line-through; text-decoration-style: wavy;"
                                                  >Text</span>
                                                  </td>
                                                  <td>Überschreibung</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:gap[@unit = 'char']">
                                                  <tr>
                                                  <td>▯</td>
                                                  <td>ein unlesbares Zeichen</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:gap[@unit = 'words']">
                                                  <tr>
                                                  <td>▭</td>
                                                  <td>ein unlesbares Wort</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:add[not(@place)]">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-right"/>Text</span>
                                                  </td>
                                                  <td>Einfügung in derselben Zeile bzw. über dem
                                                  alten Text</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:add[@place = 'above']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-up"/>Text</span>
                                                  </td>
                                                  <td>Einfügung über der Zeile</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if test="//tei:body//tei:add[@place = 'below']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-down"/>Text</span>
                                                  </td>
                                                  <td>Einfügung unter der Zeile</td>
                                                  </tr>
                                                </xsl:if>
                                                <xsl:if
                                                  test="//tei:body//tei:add[@place = 'margin']">
                                                  <tr>
                                                  <td>
                                                  <span
                                                  style="border-radius: 5px; background-color: #CBE1D1"
                                                  ><i class="bi bi-arrow-left"/>Text</span>
                                                  </td>
                                                  <td>Einfügung am Rand</td>
                                                  </tr>
                                                </xsl:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </xsl:if>
                                <!-- Legende wenn Breite unter 1810px Ende -->

                                <!-- Fußnoten Anfang -->
                                <xsl:if test="//tei:note[@type = 'footnote']">
                                    <hr/>
                                    <div id="footnotes" class="card-body">
                                        <h3>Fußnoten</h3>
                                        <ul class="list-unstyled">
                                            <xsl:for-each select="//tei:note[@type = 'footnote']">
                                                <xsl:variable name="filename"
                                                  select="substring-before(tokenize(base-uri(/), '/')[last()], '.xml')"/>
                                                <xsl:variable name="fnSign"
                                                  select="format-number(position(), '00')"/>
                                                <xsl:variable name="fnId"
                                                  select="concat('FN_', $filename, '_', $fnSign)"/>
                                                <li id="{$fnId}_app" href="#{$fnId}_con"
                                                  style="margin-bottom: 1rem;">
                                                  <sup>
                                                  <span class="badge bg-primary">
                                                  <xsl:value-of select="number($fnSign)"/>
                                                  </span>
                                                  </sup>&#160;<xsl:value-of
                                                  select="normalize-space(.)"/>&#160;<a
                                                  href="#{$fnId}_con"><i class="bi bi-arrow-up"
                                                  /></a>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </div>
                                </xsl:if>
                                <!-- Fußnoten Ende -->

                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="download_pdf"/>
                <xsl:call-template name="tooltip"/>
                <xsl:call-template name="position_annotation"/>
                <xsl:call-template name="highlight_annotation"/>
                <xsl:call-template name="scroll_offset"/>
                <xsl:call-template name="limit_toc_legend_div"/>
                <xsl:call-template name="toggle_view"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:seg[@type = 'subjectLine']" mode="col-10">
        <strong class="d-block mb-4" style="text-align: center">
            <xsl:apply-templates mode="col-10"/>
        </strong>
    </xsl:template>

    <!-- Am Dokumentbeginn Anfang -->

    <xsl:template match="tei:opener" mode="col-10">
        <div style="background-color: #fffbeb; border-radius: 5px;">
            <xsl:apply-templates mode="col-10"/>
        </div>
    </xsl:template>

    <!-- Am Dokumentbeginn Ende -->

    <!-- Am Dokumentende Anfang -->

    <xsl:template match="tei:closer" mode="col-10">
        <div
            style="margin-top: 75px; text-align: right; background-color: #fffbeb; border-radius: 5px;">
            <xsl:apply-templates mode="col-10"/>
        </div>
    </xsl:template>

    <!-- Unterschrift des Autors Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:signed" mode="col-10">
        <p>
            <em>
                <span style="font-weight: bold; border: 1px solid transparent;"
                    class="annotated-word">
                    <xsl:if test="@rend and @rend != 'align(right)'">
                        <xsl:attribute name="data-annotation">
                            <xsl:value-of select="generate-id()"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates mode="col-10"/>
                </span>
            </em>
        </p>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:signed" mode="col-2">
        <xsl:if test="@rend != 'align(right)'">
            <div class="annotation" style="border: 1px solid transparent;">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@rend"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Unterschrift des Autors Ende -->

    <!-- Am Dokumentende Ende -->

    <!-- Am Dokumentanfang und -ende Anfang -->

    <xsl:template match="tei:salute" mode="col-10">
        <p>
            <em>
                <xsl:apply-templates mode="col-10"/>
            </em>
        </p>
    </xsl:template>

    <!-- Am Dokumentanfang und -ende Ende -->

    <!-- Im Fließtext Anfang -->

    <xsl:template match="tei:head" mode="col-10">
        <strong>
            <xsl:apply-templates mode="col-10"/>
        </strong>
    </xsl:template>

    <xsl:template match="tei:p" mode="col-10">
        <p>
            <xsl:apply-templates mode="col-10"/>
        </p>
    </xsl:template>

    <xsl:template match="tei:list" mode="col-10">
        <ul style="list-style-type: none;">
            <xsl:apply-templates mode="col-10"/>
        </ul>
    </xsl:template>

    <xsl:template match="tei:list/tei:item" mode="col-10">
        <li style="margin-bottom: 1rem;">
            <xsl:apply-templates mode="col-10"/>
        </li>
    </xsl:template>

    <xsl:template match="tei:note[@type = 'footnote']" mode="col-10">
        <xsl:variable name="filename"
            select="substring-before(tokenize(base-uri(/), '/')[last()], '.xml')"/>
        <xsl:variable name="fnNumber">
            <xsl:number count="tei:note[@type = 'footnote']" level="any"/>
        </xsl:variable>
        <xsl:variable name="fnSign">
            <xsl:value-of select="format-number($fnNumber, '00')"/>
        </xsl:variable>
        <xsl:variable name="fnId" select="concat('FN_', $filename, '_', $fnSign)"/>
        <a class="footnote" id="{$fnId}_con" href="#{$fnId}_app" title="{normalize-space(.)}">
            <sup>
                <span class="badge bg-primary">
                    <xsl:value-of select="$fnNumber"/>
                </span>
            </sup>
        </a>
    </xsl:template>

    <!-- Im Fließtext Ende -->

    <!--Überall Anfang -->

    <xsl:template match="tei:lb[position() > 1]" mode="col-10">
        <span class="toggle-content">&#8629;<br/></span>
    </xsl:template>

    <xsl:template match="tei:pb" mode="col-10">
        <span class="badge bg-warning toggle-content"
            style="font-size: 10px; padding: 2px 4px; line-height: 1.5">
            <xsl:value-of select="@n"/>
        </span>
    </xsl:template>

    <!-- Überall Ende -->

    <!-- Zu Entstehungsprozess Anfang -->

    <!-- Archivfolierungsnummer Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:note[@type = 'foliation']" mode="col-10">
        <span class="badge bg-secondary annotated-word toggle-content"
            style="font-size: 10px; padding: 2px 4px; line-height: 1.5; border: 1px solid transparent;">
            <xsl:if test="@rend">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:note[@type = 'foliation']" mode="col-2">
        <xsl:if test="@rend">
            <div class="annotation" style="border: 1px solid transparent;">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@rend"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Archivfolierungsnummer Ende -->

    <!-- Unterstreichung Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:hi[@rend = 'underline']" mode="col-10">
        <span style="text-decoration: underline; border: 1px solid transparent;"
            class="annotated-word toggle-content">
            <xsl:if test="@hand">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:hi[@rend = 'underline']" mode="col-2">
        <xsl:if test="@hand">
            <div class="annotation" style="border: 1px solid transparent;">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@hand"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Unterstreichung Ende -->

    <!-- Markierung Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:hi[@rend = 'mark']" mode="col-10">
        <span style="background-color: #ffedad; border-radius: 5px; border: 1px solid transparent;"
            class="annotated-word toggle-content">
            <xsl:if test="@hand">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:hi[@rend = 'mark']" mode="col-2">
        <xsl:if test="@hand">
            <div class="annotation" style="border: 1px solid transparent;">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@hand"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Markierung Ende -->

    <!-- Ersetzung Anfang -->
    <xsl:template match="tei:subst" mode="col-10">
        <span class="toggle-content" style="border: black 1px dotted; border-radius: 5px;">
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- Ersetzung Ende -->

    <!-- Durchstreichung Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:del[not(tei:gap)]" mode="col-10">
        <span class="toggle-content"
            style="background-color: #F9CBC8; border-radius: 5px; text-decoration: line-through;">
            <xsl:if test="@rend = 'overwritten'">
                <xsl:attribute name="style">
                    <xsl:value-of
                        select="concat('background-color: #F9CBC8; text-decoration: line-through;', ' color: gray; text-decoration-style: wavy;')"
                    />
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:gap" mode="col-10">
        <xsl:variable name="style">
            <xsl:choose>
                <xsl:when test="@reason = 'strikethrough'">text-decoration: line-through;</xsl:when>
                <xsl:when test="@reason = 'overwritten'">color: gray; text-decoration: line-through;
                    text-decoration-style: wavy;</xsl:when>
                <xsl:otherwise>background-color: #F9CBC8;</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span style="background-color: #F9CBC8; border-radius: 5px; {$style}"
            class="annotated-word toggle-content">
            <xsl:variable name="quantity" select="@quantity"/>
            <xsl:choose>
                <xsl:when test="@unit = 'char'">
                    <xsl:for-each select="1 to $quantity">
                        <xsl:text>▯</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@unit = 'word'">
                    <xsl:for-each select="1 to $quantity">
                        <xsl:text>▭</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@reason = 'illegible' and not(@unit)">
                    <span style="color: gray;">unlesbar</span>
                </xsl:when>
            </xsl:choose>
        </span>
    </xsl:template>
    <!-- Durchstreichung Ende -->

    <!-- Einfügung Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:add" mode="col-10">
        <span class="annotated-word toggle-content"
            style="border-radius: 5px; background-color: #CBE1D1; border: 1px solid transparent;">
            <xsl:if test="@rend">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@place = 'above'">
                    <i class="bi bi-arrow-up toggle-content"/>
                </xsl:when>
                <xsl:when test="@place = 'below'">
                    <i class="bi bi-arrow-down toggle-content"/>
                </xsl:when>
                <xsl:when test="@place = 'margin'">
                    <i class="bi bi-arrow-left toggle-content"/>
                </xsl:when>
                <xsl:otherwise>
                    <i class="bi bi-arrow-right toggle-content"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:add" mode="col-2">
        <xsl:if test="@rend">
            <div class="annotation" style="border: 1px solid transparent;">
                <xsl:attribute name="data-annotation">
                    <xsl:value-of select="generate-id()"/>
                </xsl:attribute>
                <xsl:value-of select="@rend"/>
            </div>
        </xsl:if>
    </xsl:template>
    <!-- Einfügung Ende -->

    <!-- zu Entstehungsprozess - Ende -->

    <!-- vom Bearbeiter Anfang -->

    <!-- unclear Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:unclear" mode="col-10">
        <span class="annotated-word" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:unclear" mode="col-2">
        <div class="annotation" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>Unklare Lesung</div>
    </xsl:template>
    <!-- unclear Ende -->

    <!-- sic Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:sic" mode="col-10">
        <span class="annotated-word" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:sic" mode="col-2">
        <div class="annotation" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>sic</div>
    </xsl:template>
    <!-- sic Ende -->

    <!-- corr Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:corr" mode="col-10">
        <span class="annotated-word" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:corr" mode="col-2">
        <div class="annotation" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>Korrektur</div>
    </xsl:template>
    <!-- corr Ende -->

    <!-- Dechiffrierung Anfang -->
    <!-- col-10 -->
    <xsl:template match="tei:supplied[@reason = 'deciphering']" mode="col-10">
        <span class="annotated-word toggle-content" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:apply-templates mode="col-10"/>
        </span>
    </xsl:template>
    <!-- col-2 -->
    <xsl:template match="tei:supplied[@reason = 'deciphering']" mode="col-2">
        <div class="annotation" style="border: 1px solid transparent;">
            <xsl:attribute name="data-annotation">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>Dechiffrierung</div>
    </xsl:template>
    <!-- Dechiffrierung Ende -->

    <!-- vom Bearbeiter Ende -->

</xsl:stylesheet>

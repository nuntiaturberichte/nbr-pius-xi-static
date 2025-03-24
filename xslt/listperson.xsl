<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:param name="biographyFolder"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Kurzbiographien'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <style>
                    .card-text {
                        display: -webkit-box;
                        -webkit-line-clamp: 6;
                        -webkit-box-orient: vertical;
                        overflow: hidden;
                    }
                    
                    .card.mb-3 {
                        border: 1px #d2d2d2 solid;
                        border-radius: 5px;
                    }
                    
                    .card.mb-3:hover {
                        border: 1px solid black;
                        border-radius: 5px;
                    }</style>
            </head>
            <body>
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="header-container my-4">
                            <h1 class="text-center mb-0">Kurzbiographien</h1>
                        </div>
                        <div class="cardContainer">
                            <div class="row">
                                <xsl:variable name="biographyFiles"
                                    select="collection(concat($biographyFolder, '/?select=*.xml'))"/>
                                <xsl:for-each
                                    select="$biographyFiles/tei:TEI">
                                    <xsl:variable name="fileName"
                                        select="tokenize(base-uri(.), '/')[last()]"/>
                                    <xsl:variable name="htmlName"
                                        select="replace($fileName, '\.[^.]+$', '.html')"/>
                                    <div class="col-sm-12 col-md-6 col-lg-4"
                                        style="text-align: initial;">
                                        <a href="{$htmlName}"
                                            style="text-decoration: none; color: inherit; display: block;">
                                            <div class="card mb-3" style="height: 225px;">
                                                <div class="d-flex align-items-start">
                                                  <xsl:variable name="imgName"
                                                  select="replace($fileName, '\.[^.]+$', '.jpg')"/>
                                                  <xsl:choose>
                                                  <xsl:when test="$imgName ne 'wenzel_grosam.jpg'">
                                                  <img
                                                  style="height: 223px; margin-right: 1rem; border-radius: 5px;"
                                                  src="./images/{$imgName}"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <img
                                                  style="height: 223px; margin-right: 1rem; border-radius: 5px;"
                                                  src="./images/placeholder.jpg"/>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  <div class="flex-grow-1">
                                                  <div class="card-body">
                                                  <h5 class="card-title">
                                                  <xsl:value-of
                                                  select="descendant::tei:body/tei:div/tei:head"/>
                                                  </h5>
                                                  <p class="card-text">
                                                  <xsl:value-of
                                                  select="descendant::tei:div[@type = 'text']/tei:p"
                                                  />
                                                  </p>
                                                  </div>
                                                  </div>
                                                </div>
                                            </div>
                                        </a>
                                    </div>

                                </xsl:for-each>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>

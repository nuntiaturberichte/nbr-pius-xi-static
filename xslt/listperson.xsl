<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Kurzbiographien'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
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
                                <xsl:for-each
                                    select="collection('../../nbr-pius-xi-data/biographies/?select=*.xml')/tei:TEI">
                                    <div class="col-sm-12 col-md-6 col-lg-4">
                                        <div class="card mb-3" style="max-width: 540px;">
                                            <div class="row g-0">
                                                <div class="col-md-4">
                                                  <xsl:variable name="fileName"
                                                  select="tokenize(base-uri(.), '/')[last()]"/>
                                                  <xsl:variable name="imgName"
                                                  select="replace($fileName, '\.[^.]+$', '.jpg')"/>
                                                  <xsl:if test="$imgName ne 'wenzel_grosam.jpg'">
                                                  <img
                                                  style="max-width: 180px; float: left; border: 1px solid black; margin-right: 1rem; border-radius: 5px;"
                                                  src="./images/{$imgName}"/>
                                                  </xsl:if>
                                                </div>
                                                <div class="col-md-8">
                                                  <div class="card-body">
                                                  <h5 class="card-title">Card title</h5>
                                                  <p class="card-text">This is a wider card with
                                                  supporting text below as a natural lead-in to
                                                  additional content. This content is a little bit
                                                  longer.</p>
                                                  <p class="card-text">
                                                  <small class="text-body-secondary">Last updated 3
                                                  mins ago</small>
                                                  </p>
                                                  </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>



                        <div class="card mt-4">
                            <div class="card-body">
                                <ul>
                                    <li>
                                        <a href="./johannes_gfollner.html">Johannes Maria
                                            Gföllner</a>
                                    </li>
                                    <li>
                                        <a href="./karl_rudolf.html">Karl Rudolf</a>
                                    </li>
                                    <li>
                                        <a href="./ludwig_pastor.html">Ludwig von Pastor</a>
                                    </li>
                                    <li>
                                        <a href="./luigi_faidutti.html">Luigi Faidutti</a>
                                    </li>
                                    <li>
                                        <a href="./michael_pfliegler.html">Michael Pfliegler</a>
                                    </li>
                                    <li>
                                        <a href="./theodor_innitzer.html">Theodor Innitzer</a>
                                    </li>
                                    <li>
                                        <a href="./wenzel_grosam.html">Wenzel Grosam</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>

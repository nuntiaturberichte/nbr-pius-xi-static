<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
                        <div class="card mt-4">
                            <div class="card-header"
                                style="text-align:center; background-color: #ffedad;">
                                <h1 style="display:inline-block;margin-bottom:0;padding-right:5px;"
                                    >Kurzbiographien</h1>
                            </div>
                            <div class="card-body">
                                <!-- ev. tabelle mit geb datum... -->
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

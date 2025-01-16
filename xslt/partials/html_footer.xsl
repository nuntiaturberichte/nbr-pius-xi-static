<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:include href="./params.xsl"/>
    <xsl:template match="/" name="html_footer">
        <footer class="text-center text-lg-start bg-body-tertiary text-muted mt-5"
            style="border-top-left-radius: 20px; border-top-right-radius: 20px; border: 1px solid #666; box-shadow: 0px -5px 20px 0px rgba(0,0,0,0.35); overflow: clip;">
            <section
                class="d-flex justify-content-center justify-content-lg-between p-4 border-bottom" style="background-color: #FFE485;">
                <div class="container text-center text-md-start mt-5">
                    <!-- Grid row -->
                    <div class="row mt-3">
                        <!-- Grid column -->
                        <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                            <!-- Content -->
                            <h6 class="text-uppercase fw-bold mb-4" style="text-align: center;"
                                >Kontakt</h6>
                            <p>Austrian Centre for Digital Humanities and Cultural Heritage</p>
                            <p>Bäckerstraße 13</p>
                            <p>1010 Wien</p>
                            <p>T: +43 1 51581-2200</p>
                            <p>E: <a href="mailto:acdh-ch-helpdesk@oeaw.ac.at
                                ">acdh-ch-helpdesk@oeaw.ac.at</a></p>
                            <p style="text-align: center;">
                                <a href="https://www.oeaw.ac.at/acdh/acdh-ch-home/">
                                    <img src="./images/acdh-logo.png" width="32" height="32"
                                        alt="ACDH Logo"/>
                                </a>
                            </p>
                        </div>
                        <!-- Grid column -->



                        <!-- Grid column -->
                        <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                            <!-- Content -->
                            <h6 class="text-uppercase fw-bold mb-4" style="text-align: center;"
                                >Förderinstitution</h6>
                            <p>Österreichisches Historisches Institut Rom</p>
                            <p>Viale Bruno Buozzi 111-113</p>
                            <p>I-00197 Rom</p>
                            <p>T: +39 06 3608261</p>
                            <p>E: <a href="mailto:info@oehirom.it">info@oehirom.it</a></p>
                            <p style="text-align: center;">
                                <a href="https://www.austriacult.roma.it/de/">
                                    <img src="./images/oehi-logo.png" width="32" height="32"
                                        alt="ÖHI Rom Logo"/>
                                </a>
                            </p>
                        </div>
                        <!-- Grid column -->

                        <!-- Grid column -->
                        <div class="col-md-3 col-lg-4 col-xl-3 mx-auto mb-4">
                            <!-- Content -->
                            <h6 class="text-uppercase fw-bold mb-4" style="text-align: center;"
                                >Helpdesk</h6>
                            <p>Bei Fragen, Anmerkungen, Kritik, aber gerne auch Lob, wenden Sie sich
                                bitte an den ACDH-CH Helpdesk</p>
                            <p>E: <a href="mailto:acdh-ch-helpdesk@oeaw.ac.at"
                                    >acdh-ch-helpdesk@oeaw.ac.at</a></p>
                            <p>Sie können auch gerne Issues im <a
                                    href="https://github.com/nuntiaturberichte/nbr-pius-xi-static"
                                    >GitHub-Repository</a> erstellen.</p>
                        </div>
                        <!-- Grid column -->
                    </div>
                    <!-- Grid row -->
                </div>
            </section>
            <!-- Copyright -->
            <div class="text-center p-4" style="border: 1px solid #666; background-color: #F8C400">
                © Copyright: <a class="text-reset fw-bold" href="https://www.oeaw.ac.at/">OEAW</a> |
                    <a class="text-reset fw-bold" href="imprint.html">Impressum</a>
            </div>
            <!-- Copyright -->
        </footer>
        <!-- Footer -->
        <script src="https://code.jquery.com/jquery-3.6.3.min.js" integrity="sha256-pvPw+upLPUjgMXY0G+8O0xUf+/Im1MZjXxxgOcBQBXU=" crossorigin="anonymous"/>
    </xsl:template>
</xsl:stylesheet>

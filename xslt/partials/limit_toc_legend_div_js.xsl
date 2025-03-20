<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="limit_toc_legend_div">
        <script>
            document.addEventListener("scroll", function () {
            const toc = document.querySelector('.navigation');
            const legend = document.querySelector('.legend-slim');
            const card = document.querySelector('.card');
            
            const cardRect = card.getBoundingClientRect();
            const viewportHeight = window.innerHeight;
            
            // Berechne den Abstand zum unteren Rand des Viewports
            const cardBottomInViewport = cardRect.bottom - viewportHeight;
            
            // Für `.toc`
            if (cardBottomInViewport &lt;= 0) {
            toc.style.position = 'fixed';
            toc.style.top = 'auto'; // Deaktiviere top
            toc.style.bottom = `${-cardBottomInViewport}px`;
            } else {
            toc.style.position = 'fixed';
            toc.style.top = '148px';
            toc.style.bottom = 'auto'; // Deaktiviere bottom
            }
            
            // Für `.legend-slim`
            if (cardBottomInViewport &lt;= 0) {
            legend.style.position = 'fixed';
            legend.style.top = 'auto'; // Deaktiviere top
            legend.style.bottom = `${-cardBottomInViewport}px`;
            } else {
            legend.style.position = 'fixed';
            legend.style.top = '148px';
            legend.style.bottom = 'auto'; // Deaktiviere bottom
            }
            });
            
            </script>
    </xsl:template>
</xsl:stylesheet>

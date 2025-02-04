<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="tooltip">
        <script>
            document.addEventListener('DOMContentLoaded', function () {
            const button = document.getElementById('tooltip');
            const tooltip = new bootstrap.Tooltip(button);
            
            // Tooltip ausblenden, wenn der Button geklickt wird und nicht mehr gehovert wird
            button.addEventListener('click', () => {
            tooltip.hide(); // Tooltip manuell ausblenden
            });
            
            // Tooltip erneut anzeigen, wenn die Maus erneut hovert
            button.addEventListener('mouseenter', () => {
            tooltip.show();
            });
            
            // Tooltip ausblenden, wenn die Maus das Element verlässt
            button.addEventListener('mouseleave', () => {
            tooltip.hide();
            });
            });
        </script>

    </xsl:template>
</xsl:stylesheet>

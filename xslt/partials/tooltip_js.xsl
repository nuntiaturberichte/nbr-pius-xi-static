<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="tooltip">
        <script>
            document.addEventListener('DOMContentLoaded', function () {
            // Alle Tooltip-Elemente finden
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            
            // Tooltips initialisieren
            tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            const tooltip = new bootstrap.Tooltip(tooltipTriggerEl);
            
            // Zusätzliche Funktionalität: Tooltip ausblenden, wenn das Element geklickt wird
            tooltipTriggerEl.addEventListener('click', () => {
            tooltip.hide(); // Tooltip manuell ausblenden
            });
            
            // Tooltip erneut anzeigen, wenn die Maus erneut hovert
            tooltipTriggerEl.addEventListener('mouseenter', () => {
            tooltip.show();
            });
            });
            });
        </script>

    </xsl:template>
</xsl:stylesheet>

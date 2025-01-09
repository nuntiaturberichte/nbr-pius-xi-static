<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/" name="position_annotation">
        <script>
            document.querySelectorAll('.annotated-word').forEach(word => {
            const annotationId = word.dataset.annotation; // ID der Anmerkung
            const wordRect = word.getBoundingClientRect(); // Position des Wortes im Viewport
            const col10Rect = word.closest('.col-10').getBoundingClientRect(); // Position von col-10
            const annotation = document.querySelector(`.annotation[data-annotation="${annotationId}"]`);
            
            if (annotation) {
            // Berechnung der relativen Position des Wortes in der col-10
            const offsetTop = wordRect.top - col10Rect.top;
            
            // Anmerkung in col-2 platzieren
            annotation.style.top = `${offsetTop}px`;
            }
            });
        </script>
        
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="highlight_annotation">
        <script>document.querySelectorAll('[title="annotation"]').forEach(element => {
            element.addEventListener('mouseenter', () => {
            // Hole das zugehörige span basierend auf data-annotation
            const annotationValue = element.getAttribute('data-annotation');
            const relatedWord = document.querySelector(
            `span[title="annotated-word"][data-annotation="${annotationValue}"]`
            );
            
            // Füge die Highlight-Klasse hinzu
            if (relatedWord) {
            relatedWord.classList.add('highlight');
            }
            });
            
            element.addEventListener('mouseleave', () => {
            // Hole das zugehörige span basierend auf data-annotation
            const annotationValue = element.getAttribute('data-annotation');
            const relatedWord = document.querySelector(
            `span[title="annotated-word"][data-annotation="${annotationValue}"]`
            );
            
            // Entferne die Highlight-Klasse
            if (relatedWord) {
            relatedWord.classList.remove('highlight');
            }
            });
            });
            
        </script>

    </xsl:template>
</xsl:stylesheet>

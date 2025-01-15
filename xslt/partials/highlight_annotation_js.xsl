<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="highlight_annotation">
        <script>
            // Suche nach allen Elementen mit den Klassen "annotation" und "annotated-word"
            document.querySelectorAll('.annotation, .annotated-word').forEach(element => {
            element.addEventListener('mouseenter', () => {
            // Hole das zugehörige `data-annotation`-Attribut
            const annotationValue = element.getAttribute('data-annotation');
            
            // Finde alle passenden Elemente mit gleichem `data-annotation`-Wert
            const relatedElements = document.querySelectorAll(
            `[data-annotation="${annotationValue}"]`
            );
            
            // Füge die Highlight-Klasse hinzu
            relatedElements.forEach(relatedElement => {
            relatedElement.classList.add('highlight');
            });
            });
            
            element.addEventListener('mouseleave', () => {
            // Hole das zugehörige `data-annotation`-Attribut
            const annotationValue = element.getAttribute('data-annotation');
            
            // Finde alle passenden Elemente mit gleichem `data-annotation`-Wert
            const relatedElements = document.querySelectorAll(
            `[data-annotation="${annotationValue}"]`
            );
            
            // Entferne die Highlight-Klasse
            relatedElements.forEach(relatedElement => {
            relatedElement.classList.remove('highlight');
            });
            });
            });
        </script>
    </xsl:template>
</xsl:stylesheet>

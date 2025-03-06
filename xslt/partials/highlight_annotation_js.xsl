<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="highlight_annotation">
        <script>
            document.querySelectorAll('.annotation, .annotated-word').forEach(element => {
            element.addEventListener('mouseenter', () => {
            const annotationValue = element.getAttribute('data-annotation');
            
            // Hole alle `.annotated-word`-Elemente mit der gleichen data-annotation
            const relatedWords = document.querySelectorAll(`.annotated-word[data-annotation="${annotationValue}"]`);
            
            // Hole die erste (bestehende) `.annotation` mit diesem `data-annotation`-Wert
            const firstAnnotation = document.querySelector(`.col-2 .annotation[data-annotation="${annotationValue}"]`);
            
            // Falls eine erste Annotation existiert, füge sie zum Highlight hinzu
            if (firstAnnotation) {
            firstAnnotation.classList.add('highlight');
            }
            
            // Füge die Highlight-Klasse zu allen zugehörigen `.annotated-word`-Elementen hinzu
            relatedWords.forEach(word => {
            word.classList.add('highlight');
            });
            });
            
            element.addEventListener('mouseleave', () => {
            const annotationValue = element.getAttribute('data-annotation');
            
            // Entferne Highlight von allen `.annotated-word`-Elementen
            const relatedWords = document.querySelectorAll(`.annotated-word[data-annotation="${annotationValue}"]`);
            relatedWords.forEach(word => {
            word.classList.remove('highlight');
            });
            
            // Entferne Highlight von der ersten `.annotation` in `.col-2`
            const firstAnnotation = document.querySelector(`.col-2 .annotation[data-annotation="${annotationValue}"]`);
            if (firstAnnotation) {
            firstAnnotation.classList.remove('highlight');
            }
            });
            });
        </script>
    </xsl:template>
</xsl:stylesheet>

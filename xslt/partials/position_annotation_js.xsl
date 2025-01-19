<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="position_annotation">
        <script>
            function positionAnnotations() {
            const positions = []; // Liste der Positionen (Array)
            
            // Suche nach Annotationen mit der Klasse "annotation"
            document.querySelectorAll('.annotation').forEach(annotation => {
            const annotationId = annotation.getAttribute('data-annotation');
            
            // Suche nach den zugehörigen Wörtern mit der Klasse "annotated-word"
            const word = document.querySelector(`.annotated-word[data-annotation="${annotationId}"]`);
            
            if (word) {
            const wordRect = word.getBoundingClientRect();
            const col10Rect = word.closest('.col-10').getBoundingClientRect();
            const col2 = document.querySelector('.col-2');
            
            if (col2) {
            let offsetTop = wordRect.top - col10Rect.top - 2;
            
            // Sicherstellen, dass der Abstand von 24px eingehalten wird
            positions.forEach(existingTop => {
            if (Math.abs(existingTop - offsetTop) &lt; 24) {
            offsetTop = existingTop + 24; // Verschiebe die Position, um den Abstand einzuhalten
            }
            });
            
            // Element positionieren
            annotation.style.position = 'absolute';
            annotation.style.top = `${offsetTop}px`;
            
            // Neue Position speichern
            positions.push(offsetTop);
            }
            }
            });
            }
            
            // Initiale Positionierung der Annotationen
            positionAnnotations();
            
            // Event-Listener für Scrollen und Resizing
            window.addEventListener('resize', positionAnnotations);
            window.addEventListener('scroll', positionAnnotations);
        </script>
    </xsl:template>
</xsl:stylesheet>

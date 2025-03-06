<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="position_annotation">
        <script>
            
            function mergeConsecutiveAnnotations() {
            // Hole nur Annotationen aus der col-2 Spalte
            const annotations = document.querySelectorAll('.col-2 .annotation');
            
            let lastText = "";         // Speichert den vorherigen Annotationstext
            let firstOfGroup = null;   // Erste Annotation innerhalb einer Gruppe
            let firstOfGroupId = null; // Deren data-annotation Wert
            
            annotations.forEach((annotation) => {
            const annotationText = annotation.textContent.trim();
            const annotationId   = annotation.getAttribute('data-annotation');
            
            if (annotationText === lastText) {
            // 1) Wenn dieselbe Text-Annotation direkt aufeinander folgt:
            //    * Alle .annotated-word, die bisher auf dieses Duplikat zeigen,
            //      sollen auf das erste (behaltene) .annotation zeigen
            if (firstOfGroupId) {
            document.querySelectorAll(`.annotated-word[data-annotation="${annotationId}"]`)
            .forEach((word) => {
            // Wir ändern den data-annotation Wert auf das "erste" der Gruppe
            word.setAttribute('data-annotation', firstOfGroupId);
            });
            }
            // 2) Duplikat in col-2 entfernen
            annotation.remove();
            } else {
            // Anderer Text => Neue Gruppe
            lastText = annotationText;
            firstOfGroup = annotation;
            firstOfGroupId = annotationId;
            }
            });
            }
            
            
            function positionAnnotations() {
            mergeConsecutiveAnnotations(); // Entfernt direkt aufeinanderfolgende Duplikate
            const positions = []; // Liste der Positionen
            
            document.querySelectorAll('.annotation').forEach(annotation => {
            const annotationId = annotation.getAttribute('data-annotation');
            const word = document.querySelector(`.annotated-word[data-annotation="${annotationId}"]`);
            
            if (word) {
            const wordRect = word.getBoundingClientRect();
            const col10Rect = word.closest('.col-10').getBoundingClientRect();
            const col2 = document.querySelector('.col-2');
            
            if (col2) {
            let offsetTop = wordRect.top - col10Rect.top - 2;
            
            // Überlappungen vermeiden (24px Abstand)
            positions.forEach(existingTop => {
            if (Math.abs(existingTop - offsetTop) &lt; 24) {
            offsetTop = existingTop + 24;
            }
            });
            
            // Position setzen
            annotation.style.position = 'absolute';
            annotation.style.top = `${offsetTop}px`;
            
            // Position speichern
            positions.push(offsetTop);
            }
            }
            });
            }
            
            // Initial aufrufen
            positionAnnotations();
            
            // Event-Listener für Resize und Scroll
            window.addEventListener('resize', positionAnnotations);
            window.addEventListener('scroll', positionAnnotations);
        </script>
    </xsl:template>
</xsl:stylesheet>

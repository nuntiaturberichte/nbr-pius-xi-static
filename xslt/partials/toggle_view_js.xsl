<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="toggle_view">
        <script>
            // Annotierte Ansicht
            document.getElementById('showAnnotations').addEventListener('click', function () {
            const textColumn = document.querySelector('.text-column'); // Textspalte anhand einer festen Klasse auswählen
            const annotationColumn = document.querySelector('.col-2'); // Annotationen-Spalte auswählen
            const toggleElements = document.querySelectorAll('.toggle-content'); // Alle Toggle-Content-Elemente auswählen
            
            if (textColumn) {
            // Zurück zu col-10 (annotierte Ansicht)
            textColumn.classList.remove('col-12');
            textColumn.classList.add('col-10');
            }
            if (annotationColumn) {
            annotationColumn.style.display = 'block'; // Annotationen-Spalte einblenden
            }
            if (toggleElements) {
            toggleElements.forEach(el => {
            el.style.display = 'inline'; // Toggle-Content-Elemente einblenden
            });
            }
            
            // Buttons anpassen
            this.classList.add('btn-primary'); // Aktiver Button
            this.classList.remove('btn-secondary');
            document.getElementById('showReadingView').classList.add('btn-secondary');
            document.getElementById('showReadingView').classList.remove('btn-primary');
            });
            
            // Leseansicht
            document.getElementById('showReadingView').addEventListener('click', function () {
            const textColumn = document.querySelector('.text-column'); // Textspalte anhand einer festen Klasse auswählen
            const annotationColumn = document.querySelector('.col-2'); // Annotationen-Spalte auswählen
            const toggleElements = document.querySelectorAll('.toggle-content'); // Alle Toggle-Content-Elemente auswählen
            
            if (textColumn) {
            // Auf col-12 umstellen (Leseansicht)
            textColumn.classList.remove('col-10');
            textColumn.classList.add('col-12');
            }
            if (annotationColumn) {
            annotationColumn.style.display = 'none'; // Annotationen-Spalte ausblenden
            }
            if (toggleElements) {
            toggleElements.forEach(el => {
            el.style.display = 'none'; // Toggle-Content-Elemente ausblenden
            });
            }
            
            // Buttons anpassen
            this.classList.add('btn-primary'); // Aktiver Button
            this.classList.remove('btn-secondary');
            document.getElementById('showAnnotations').classList.add('btn-secondary');
            document.getElementById('showAnnotations').classList.remove('btn-primary');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>

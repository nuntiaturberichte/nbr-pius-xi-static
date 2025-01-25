<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="toggle_view">
        <script>// Map zum Speichern der ursprünglichen Werte von data-annotation
            const annotationValues = new Map();
            
            // Initialisierung: Werte von data-annotation speichern
            document.addEventListener('DOMContentLoaded', () => {
            const annotatedElements = document.querySelectorAll('[data-annotation]');
            annotatedElements.forEach(el => {
            const value = el.getAttribute('data-annotation');
            if (value !== null) {
            annotationValues.set(el, value); // Originalwert speichern
            }
            });
            });
            
            // Annotierte Ansicht
            document.getElementById('showAnnotations').addEventListener('click', function () {
            const textColumn = document.querySelector('.text-column');
            const annotationColumn = document.querySelector('.col-2');
            const toggleElements = document.querySelectorAll('.toggle-content');
            
            if (textColumn) {
            textColumn.classList.remove('col-12');
            textColumn.classList.add('col-10');
            }
            if (annotationColumn) {
            annotationColumn.style.display = 'block';
            }
            if (toggleElements) {
            toggleElements.forEach(el => {
            el.classList.remove('no-annotations');
            });
            }
            
            // Werte von data-annotation aus der Map wiederherstellen
            annotationValues.forEach((value, el) => {
            if (document.body.contains(el)) { // Nur wenn das Element noch im DOM existiert
            el.setAttribute('data-annotation', value);
            }
            });
            
            // Buttons anpassen
            this.classList.add('btn-dark');
            this.classList.remove('btn-outline-dark');
            document.getElementById('showReadingView').classList.add('btn-outline-dark');
            document.getElementById('showReadingView').classList.remove('btn-dark');
            });
            
            // Leseansicht
            document.getElementById('showReadingView').addEventListener('click', function () {
            const textColumn = document.querySelector('.text-column');
            const annotationColumn = document.querySelector('.col-2');
            const toggleElements = document.querySelectorAll('.toggle-content');
            const annotatedElements = document.querySelectorAll('[data-annotation]');
            
            if (textColumn) {
            textColumn.classList.remove('col-10');
            textColumn.classList.add('col-12');
            }
            if (annotationColumn) {
            annotationColumn.style.display = 'none';
            }
            if (toggleElements) {
            toggleElements.forEach(el => {
            el.classList.add('no-annotations');
            });
            }
            
            // Werte von data-annotation speichern und Attribut entfernen
            annotatedElements.forEach(el => {
            const value = el.getAttribute('data-annotation');
            if (value !== null) {
            annotationValues.set(el, value); // Originalwert speichern
            }
            el.removeAttribute('data-annotation');
            });
            
            // Buttons anpassen
            this.classList.add('btn-dark');
            this.classList.remove('btn-outline-dark');
            document.getElementById('showAnnotations').classList.add('btn-outline-dark');
            document.getElementById('showAnnotations').classList.remove('btn-dark');
            });
        </script>
    </xsl:template>
</xsl:stylesheet>

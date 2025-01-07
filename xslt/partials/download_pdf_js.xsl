<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/" name="download_pdf">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"/>
        <script>
            document.getElementById('downloadPdf').addEventListener('click', function () {
            var letterBody = document.getElementById('letter-body').innerHTML;
            var documentTitle = document.title;
            
            // Erstelle ein neues div für den PDF-Inhalt
            var combinedDiv = document.createElement('div');
            
            // Füge die Überschrift und den Body-Inhalt in das Div ein
            combinedDiv.innerHTML = '<h1>' + documentTitle + '</h1>' + '<hr/>' + letterBody;
            
            // Wende CSS nur auf das `combinedDiv` an, damit es nur den PDF-Inhalt betrifft
            combinedDiv.style.fontSize = '80%'; // Verkleinere die Schriftgröße nur im PDF-Inhalt
            
            // Erstelle ein style-Element, um CSS-Regeln für den PDF-Inhalt hinzuzufügen
            var style = document.createElement('style');
            style.innerHTML = `
            /* Verhindere das Abschneiden innerhalb wichtiger Blöcke */
            h1, h2, h3, h4, h5, h6, p, li, em {
            page-break-inside: avoid;
            }
            `;
            
            // Hänge das style-Element an das combinedDiv an
            combinedDiv.appendChild(style);
            
            var pdfFileName = document.getElementById('pdfFileName').textContent.trim();
            
            // Optionen für html2pdf inklusive Scale-Anpassung
            var options = {
            margin: 25.4,
            filename: pdfFileName,
            image: { type: 'jpeg', quality: 0.98 },
            html2canvas: {
            scale: 4, // Bessere Auflösung für das verkleinerte Layout
            dpi: 300,
            letterRendering: true
            },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };
            
            // Konvertiere das combinedDiv zu PDF
            html2pdf().set(options).from(combinedDiv).save();
            });
        </script>
    </xsl:template>
    
    
    
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="download_pdf">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"/>
        <script>
            document.getElementById('downloadPdf').addEventListener('click', function () {
            var loader = document.getElementById('loader');
            loader.style.display = 'block'; // Zeigt den Loader an
            
            setTimeout(() => { // Warten, um den Loader sichtbar zu machen
            loader.style.display = 'none'; // Loader ausblenden, bevor PDF erstellt wird
            
            var letterBody = document.getElementById('letter-body').innerHTML;
            var documentTitle = document.title;
            var contextualization = "Digitale Briefedition – Nuntiaturberichte Pius XI.";
            
            var combinedDiv = document.createElement('div');
            combinedDiv.innerHTML = contextualization + '<h1>' + documentTitle + '</h1>' + '<hr/>' + letterBody;
            combinedDiv.style.fontSize = '80%';
            
            var style = document.createElement('style');
            style.innerHTML = `
            h1, h2, h3, h4, h5, h6, p, li, em {
            page-break-inside: avoid;
            }`;
            combinedDiv.appendChild(style);
            
            var pdfFileName = document.getElementById('pdfFileName').textContent.trim();
            
            var options = {
            margin: 25.4,
            filename: pdfFileName,
            image: { type: 'jpeg', quality: 0.7 },
            html2canvas: {
            scale: 1.75,
            dpi: 96,
            letterRendering: false
            },
            jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
            };
            
            html2pdf().set(options).from(combinedDiv).save().then(() => {
            loader.style.display = 'none'; // Sicherstellen, dass der Loader ausgeblendet bleibt
            }).catch(() => {
            loader.style.display = 'none';
            alert("Beim Erstellen des PDFs ist ein Fehler aufgetreten.");
            });
            
            }, 250); // 100ms Verzögerung für besseren Übergang
            });
        </script>
    </xsl:template>



</xsl:stylesheet>

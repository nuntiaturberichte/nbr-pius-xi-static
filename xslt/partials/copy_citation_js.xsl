<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/" name="copy_citation">
        <script>
            function copyToClipboard(id, button) {
            var element = document.getElementById(id);
            if (element) {
            var text = element.innerText;
            navigator.clipboard.writeText(text).then(function() {
            // Icons und Texte umschalten
            var clipboardIcon = button.querySelector('.bi-clipboard');
            var checkIcon = button.querySelector('.bi-clipboard-check');
            var copyText = button.querySelector('span:first-of-type');
            var copiedText = button.querySelector('span:last-of-type');
            
            clipboardIcon.style.display = "none";
            checkIcon.style.display = "inline";
            copyText.style.display = "none";
            copiedText.style.display = "inline";
            
            // Nach 2 Sekunden zurücksetzen
            setTimeout(function() {
            clipboardIcon.style.display = "inline";
            checkIcon.style.display = "none";
            copyText.style.display = "inline";
            copiedText.style.display = "none";
            }, 2000);
            
            }).catch(function(err) {
            alert("Fehler beim Kopieren: " + err);
            });
            } else {
            alert("Element nicht gefunden.");
            }
            }
        </script>
    </xsl:template>
</xsl:stylesheet>

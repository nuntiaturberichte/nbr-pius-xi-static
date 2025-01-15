<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:template match="/" name="scroll_offset">
        <script>
            // Funktion für Scroll-Offset
            function scrollToHash(hash) {
            const target = document.querySelector(hash.replace('.', '\\.'));
            if (target) {
            const offset = 95; // Höhe der Navbar
            const targetPosition = target.getBoundingClientRect().top + window.scrollY - offset;
            window.scrollTo({ top: targetPosition, behavior: 'smooth' });
            }
            }
            
            // Für interne Klicks auf Anker-Links
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
            e.preventDefault();
            scrollToHash(this.getAttribute('href'));
            });
            });
            
            // Für direkte Links mit Hash (z. B. brief.html#note1)
            window.addEventListener('load', () => {
            if (window.location.hash) {
            setTimeout(() => scrollToHash(window.location.hash), 100); // Verzögerung hinzufügen
            }
            });
        </script>
        
        
        
        
        
    </xsl:template>
    
</xsl:stylesheet>

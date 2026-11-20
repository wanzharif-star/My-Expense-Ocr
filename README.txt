MY EXPENSE OCR - FIRST WORKING VERSION

Files:
- index.html: the application
- manifest.json: Home Screen/PWA settings
- sw.js: basic offline app-shell cache
- icon.svg: app icon

QUICK TEST ON A COMPUTER
1. Extract this ZIP.
2. In the extracted folder run a local web server, for example: python3 -m http.server 8000
3. Open http://localhost:8000

USE ON IPHONE
1. Host these four files on any HTTPS static host, such as GitHub Pages, Netlify, Cloudflare Pages, or your own web server.
2. Open the HTTPS address in Safari.
3. Tap Share > Add to Home Screen.
4. Allow camera/photo access when prompted.

OCR NOTE
OCR uses Tesseract.js loaded from jsDelivr. The first scan therefore needs internet access. Expense data and compressed receipt images are stored in Safari local storage on that device. Clear Safari website data only if you accept losing the records. Export CSV regularly as a backup.

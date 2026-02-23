$jsFile = "e:/ramras/script.js"
$appendContent = @"

// Handle URL Status (Success/Error) from PHP redirection
window.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const status = urlParams.get('status');
    
    if (status === 'success' || status === 'error') {
        const modal = document.getElementById('status-modal-overlay');
        const title = document.getElementById('status-title');
        const msg = document.getElementById('status-message');
        const icon = document.getElementById('status-icon');
        const closeBtn = document.querySelector('.modal-close');
        
        if (modal && title && msg && icon) {
            modal.classList.add('active');
            
            if (status === 'success') {
                title.textContent = 'Thank You!';
                msg.textContent = 'Your inquiry has been sent successfully. We will get back to you soon.';
                icon.className = 'status-icon success';
                icon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';
            } else {
                title.textContent = 'Submission Failed';
                msg.textContent = 'There was a problem sending your inquiry. Please try again.';
                icon.className = 'status-icon error';
                icon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>';
            }

            // Close Logic
            if (closeBtn) {
                closeBtn.addEventListener('click', () => {
                    modal.classList.remove('active');
                    // Remove param from URL without refresh
                    window.history.replaceState({}, document.title, window.location.pathname);
                });
            }
            
            // Close on outside click
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    modal.classList.remove('active');
                    window.history.replaceState({}, document.title, window.location.pathname);
                }
            });
        }
    }
});
"@

Add-Content -Path $jsFile -Value $appendContent -Encoding utf8
Write-Host "Appended logic to script.js"

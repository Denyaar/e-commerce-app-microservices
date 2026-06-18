const SANDBOX_DASHBOARD_URL = (typeof window.SANDBOX_DASHBOARD_URL === 'string' && window.SANDBOX_DASHBOARD_URL)
    ? window.SANDBOX_DASHBOARD_URL
    : '/';

let injected = false;

function findSecurityItem() {
    // "Account security" is a nav group rendered as a <button>, not an <a>.
    // Search all top-level nav items by their link's text content.
    const items = document.querySelectorAll('.pf-v5-c-nav__list > .pf-v5-c-nav__item');
    for (const item of items) {
        const link = item.querySelector('.pf-v5-c-nav__link');
        if (link && link.textContent.toLowerCase().includes('account security')) {
            return item;
        }
    }
    return null;
}

function injectDashboardLink() {
    if (injected) return;

    // Guard: bail early if nav list isn't in the DOM yet
    if (!document.querySelector('.pf-v5-c-nav__list')) return;

    const securityItem = findSecurityItem();
    if (!securityItem) return;

    // Don't inject twice if React re-renders
    if (document.querySelector('[data-eco-nav="dashboard"]')) {
        injected = true;
        observer.disconnect();
        return;
    }

    const li = document.createElement('li');
    li.className = 'pf-v5-c-nav__item';

    const a = document.createElement('a');
    a.href = SANDBOX_DASHBOARD_URL;
    a.className = 'pf-v5-c-nav__link';
    a.target = '_blank';
    a.rel = 'noopener noreferrer';
    a.setAttribute('data-eco-nav', 'dashboard');

    const label = document.createTextNode('Back to Dashboard ');
    const icon = document.createElement('span');
    icon.setAttribute('aria-hidden', 'true');
    icon.style.cssText = 'font-size:11px;opacity:0.6;';
    icon.textContent = '↗';

    a.appendChild(label);
    a.appendChild(icon);
    li.appendChild(a);

    securityItem.insertAdjacentElement('afterend', li);
    injected = true;
    observer.disconnect();
}

const observer = new MutationObserver(injectDashboardLink);
observer.observe(document.body, { childList: true, subtree: true });
injectDashboardLink();

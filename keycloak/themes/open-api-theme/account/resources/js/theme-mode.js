(function () {
    var DARK_CLASS  = "pf-v5-theme-dark";
    var STORAGE_KEY = "eco-theme";

    /* ---- Theme switching ---- */
    function applyMode(dark) {
        if (dark) {
            document.documentElement.classList.add(DARK_CLASS);
        } else {
            document.documentElement.classList.remove(DARK_CLASS);
        }
    }

    // 1. URL query param  ?theme=dark | ?theme=light  (passed by the portal)
    var param = new URLSearchParams(window.location.search).get("theme");
    if (param === "dark" || param === "light") {
        sessionStorage.setItem(STORAGE_KEY, param);
    }

    // 2. Persisted value for SPA navigation within the session
    var stored = sessionStorage.getItem(STORAGE_KEY);
    if (stored === "dark" || stored === "light") {
        applyMode(stored === "dark");
    } else {
        // 3. OS / browser preference fallback
        var mq = window.matchMedia("(prefers-color-scheme: dark)");
        applyMode(mq.matches);
        mq.addEventListener("change", function (e) {
            if (!sessionStorage.getItem(STORAGE_KEY)) applyMode(e.matches);
        });
    }

    /* ---- Hide Applications nav item ---- */
    function hideApplications() {
        document.querySelectorAll(".pf-v5-c-nav__link").forEach(function (link) {
            if (/applications/i.test(link.textContent)) {
                var item = link.closest(".pf-v5-c-nav__item");
                if (item) item.style.display = "none";
            }
        });
    }

    /* ---- Lock First Name & Last Name fields ---- */
    function lockNameFields() {
        ["firstName", "lastName"].forEach(function (field) {
            var input = document.querySelector(
                'input[name="' + field + '"], #' + field
            );
            if (input && !input.hasAttribute("readonly")) {
                input.setAttribute("readonly", "readonly");
                input.setAttribute("tabindex", "-1");
                input.classList.add("eco-readonly-field");
            }
        });
    }

    // Both functions need to run after React renders the page content
    document.addEventListener("DOMContentLoaded", function () {
        hideApplications();
        lockNameFields();
    });

    var observer = new MutationObserver(function () {
        hideApplications();
        lockNameFields();
    });
    observer.observe(document.body || document.documentElement, {
        childList: true,
        subtree: true
    });
    setTimeout(function () { observer.disconnect(); }, 5000);
})();

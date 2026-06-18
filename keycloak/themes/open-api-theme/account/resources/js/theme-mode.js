(function () {
    var DARK_CLASS  = "pf-v5-theme-dark";
    var STORAGE_KEY = "eco-theme";

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
})();

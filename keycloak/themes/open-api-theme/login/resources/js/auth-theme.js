(function () {
    var STORAGE_KEY = "eco-theme";
    var root = document.documentElement;

    function getThemeFromQuery() {
        var param = new URLSearchParams(window.location.search).get("theme");
        return param === "dark" || param === "light" ? param : null;
    }

    function applyTheme(theme) {
        root.classList.toggle("dark", theme === "dark");
        root.style.colorScheme = theme === "dark" ? "dark" : "light";
    }

    var theme = getThemeFromQuery();
    if (theme) {
        sessionStorage.setItem(STORAGE_KEY, theme);
        applyTheme(theme);
        return;
    }

    theme = sessionStorage.getItem(STORAGE_KEY);
    if (theme === "dark" || theme === "light") {
        applyTheme(theme);
    }
})();

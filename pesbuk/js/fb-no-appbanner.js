// ==UserScript==
// @include https://m.facebook.com/*
// ==/UserScript==

// Ensure that the facebook mobile site never shows its app banner, which
// suggests installing a native Android/iOS application based on naïve
// parsing of the UA string.

// The banner does not currently have any class or id that would make sure we
// can identify it easily. But we know that it does always appear just before
// the login form, so we find it that way.

var login = document.getElementsByClassName("mobile-login-form");
if (login.length === 1) {
    var appbanner = login[0].previousSibling;
    if (appbanner) {
        appbanner.parentNode.removeChild(appbanner);
    }
}

// justypdocs site interactions.
(function () {
  document.documentElement.classList.add("jtd-js");

  var currentScript = document.currentScript;
  var iconHref = currentScript && currentScript.src
    ? currentScript.src.replace(/assets\/js\/site\.js(?:\?.*)?$/, "assets/icons/symbols.svg")
    : "/assets/icons/symbols.svg";

  function icon(name) {
    var svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    var use = document.createElementNS("http://www.w3.org/2000/svg", "use");
    svg.setAttribute("class", "jtd-icon jtd-icon-" + name);
    svg.setAttribute("aria-hidden", "true");
    use.setAttribute("href", iconHref + "#" + name);
    svg.appendChild(use);
    return svg;
  }

  function init() {
    var menuButton = document.getElementById("menu-button");
    var sideBar = document.querySelector(".side-bar");
    var storageKey = "justypdocs.navState";

    function loadNavState() {
      try {
        return JSON.parse(localStorage.getItem(storageKey) || "{}");
      } catch (error) {
        return {};
      }
    }

    function saveNavState(state) {
      try {
        localStorage.setItem(storageKey, JSON.stringify(state));
      } catch (error) {
        // Ignore storage failures; nav toggles should still work per page.
      }
    }

    var navState = loadNavState();

    if (menuButton && sideBar) {
      menuButton.addEventListener("click", function () {
        var expanded = menuButton.getAttribute("aria-expanded") === "true";
        menuButton.setAttribute("aria-expanded", String(!expanded));
        sideBar.classList.toggle("nav-open", !expanded);
      });
    }

    document.querySelectorAll(".jtd-nav-section-toggle").forEach(function (toggle) {
      var item = toggle.closest(".jtd-nav-item");
      var id = item ? item.getAttribute("data-nav-id") : null;
      var hasActiveChild = item ? item.querySelector(".jtd-nav-link.active") !== null : false;

      function syncItem() {
        if (item) {
          item.classList.toggle("is-collapsed", toggle.getAttribute("aria-expanded") !== "true");
        }
      }

      if (id && Object.prototype.hasOwnProperty.call(navState, id) && !hasActiveChild) {
        toggle.setAttribute("aria-expanded", String(navState[id]));
      }

      if (hasActiveChild) {
        toggle.setAttribute("aria-expanded", "true");
      }

      syncItem();

      toggle.addEventListener("click", function () {
        var expanded = toggle.getAttribute("aria-expanded") === "true";
        toggle.setAttribute("aria-expanded", String(!expanded));
        if (id) {
          navState[id] = !expanded;
          saveNavState(navState);
        }
        syncItem();
      });
    });

    document.querySelectorAll("pre").forEach(function (pre) {
      if (!pre.hasAttribute("tabindex")) {
        pre.setAttribute("tabindex", "0");
      }

      if (!navigator.clipboard || pre.parentElement.classList.contains("jtd-code-wrap")) {
        return;
      }

      var wrap = document.createElement("div");
      wrap.className = "jtd-code-wrap";
      pre.parentNode.insertBefore(wrap, pre);
      wrap.appendChild(pre);

      var button = document.createElement("button");
      button.className = "jtd-copy-code";
      button.type = "button";
      button.appendChild(icon("copy"));
      button.appendChild(document.createTextNode("Copy"));
      wrap.appendChild(button);

      button.addEventListener("click", function () {
        navigator.clipboard.writeText(pre.innerText).then(function () {
          button.replaceChildren(icon("check"), document.createTextNode("Copied"));
          window.setTimeout(function () {
            button.replaceChildren(icon("copy"), document.createTextNode("Copy"));
          }, 1500);
        });
      });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();

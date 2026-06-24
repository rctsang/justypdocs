// justypdocs site interactions.
(function () {
  document.documentElement.classList.add("jtd-js");

  var menuButton = document.getElementById("menu-button");
  var sideBar = document.querySelector(".side-bar");

  if (menuButton && sideBar) {
    menuButton.addEventListener("click", function () {
      var expanded = menuButton.getAttribute("aria-expanded") === "true";
      menuButton.setAttribute("aria-expanded", String(!expanded));
      sideBar.classList.toggle("nav-open", !expanded);
    });
  }

  document.querySelectorAll(".jtd-nav-section-toggle").forEach(function (toggle) {
    var item = toggle.closest(".jtd-nav-item");

    function syncItem() {
      if (item) {
        item.classList.toggle("is-collapsed", toggle.getAttribute("aria-expanded") !== "true");
      }
    }

    syncItem();

    toggle.addEventListener("click", function () {
      var expanded = toggle.getAttribute("aria-expanded") === "true";
      toggle.setAttribute("aria-expanded", String(!expanded));
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
    button.textContent = "Copy";
    wrap.appendChild(button);

    button.addEventListener("click", function () {
      navigator.clipboard.writeText(pre.innerText).then(function () {
        button.textContent = "Copied";
        window.setTimeout(function () {
          button.textContent = "Copy";
        }, 1500);
      });
    });
  });
})();

chrome.devtools.panels.create "Shell", "terminalIcon.png", "shell.html", (panel) ->
        panel.onShown.addListener (win) -> win.focus

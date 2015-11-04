tabId = chrome.devtools.inspectedWindow.tabId
err = document.getElementById 'error'
editor = ace.edit "editor"
editor.setTheme "ace/theme/twilight"
editor.session.setMode "ace/mode/powershell"
editor.session.setUseSoftTabs true
editor.session.setTabSize 2
editor.setShowPrintMargin false
editor.renderer.setShowGutter false

preparePromt = ->
    editor.session.doc.insert '\n> '

requestServer = (command, successFn) ->
    console.log command
    request = new XMLHttpRequest
    request.open 'POST', 'http://localhost:8080', true
    request.setRequestHeader 'Content-Type', \
        'application/json; charset=UTF-8'

    request.onload = ->
        if request.status >= 200 && request.status < 400
            # Success!
            data = JSON.parse request.responseText
            successFn data
        else
            # We reached our target server, but it returned an error
            console.log 'error in error'

    request.onerror = (e) ->
        # There was a connection error of some sort
        console.log 'connection error' + e.target.status

    request.send JSON.stringify script: command

document.addEventListener 'keypress', (event) ->
    if event.keyCode == 13 # if <ret> is pressed
        cursor = editor.selection.getCursor!
        console.log cursor
        commandText = editor.session.getLine cursor.row
        requestServer commandText, (result) ->
            console.log result
            editor.session.doc.insertMergedLines \
                row: cursor.row + 1 \
                column: 0, \
                [result['stdout'], '']

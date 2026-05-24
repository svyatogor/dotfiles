tell application "Safari"
    activate
    set found to false
    repeat with w in windows
        if name of w starts with "UF" then
            set index of w to 1
            set found to true
            exit repeat
        end if
    end repeat
end tell

if not found then
    tell application "System Events"
        tell process "Safari"
            click menu item "New UF Window" of menu "New Window" of menu item "New Window" of menu "File" of menu bar 1
        end tell
    end tell
end if

#!/bin/bash
# Hook: Notification
# 데스크톱 알림 (Linux/WSL 호환)
#
# 설정:
# "Notification": [{ "matcher": "", "command": "bash .claude/hooks/post-bash-notify.sh" }]

MESSAGE="${CLAUDE_NOTIFICATION:-Claude Code 작업 완료}"

# Linux (libnotify)
if command -v notify-send &>/dev/null; then
    notify-send "Claude Code" "$MESSAGE" --icon=dialog-information 2>/dev/null
# WSL → Windows 알림
elif command -v powershell.exe &>/dev/null; then
    powershell.exe -Command "
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        \$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
        \$textNodes = \$template.GetElementsByTagName('text')
        \$textNodes.Item(0).AppendChild(\$template.CreateTextNode('Claude Code')) | Out-Null
        \$textNodes.Item(1).AppendChild(\$template.CreateTextNode('$MESSAGE')) | Out-Null
        \$toast = [Windows.UI.Notifications.ToastNotification]::new(\$template)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$toast)
    " 2>/dev/null
# macOS
elif command -v osascript &>/dev/null; then
    osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\"" 2>/dev/null
fi

exit 0

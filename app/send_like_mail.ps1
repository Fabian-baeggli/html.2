param(
    [string]$to,
    [string]$username,
    [string]$liker
)

$smtpServer = "smtp.deinserver.de"  # HIER ANPASSEN!
$smtpFrom = "no-reply@datingapp.local"
$subject = "Du hast einen neuen Like auf DatingApp!"
$body = @"
Hallo $username,

Du hast soeben einen neuen Like von '$liker' erhalten!
Logge dich jetzt ein und schau nach, wer dich geliked hat.

Viel Spaß beim Flirten!

Dein DatingApp-Team
"@

Send-MailMessage -To $to -From $smtpFrom -Subject $subject -Body $body -SmtpServer $smtpServer 
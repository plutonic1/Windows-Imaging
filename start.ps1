Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function apply($type, $user){ 

    if ($user -eq "@"){
        Write-Host "capture"
        Start-Process -Filepath cmd -NoNewWindow -Wait -ArgumentList "/c net use N: \\10.0.2.2\Netzwerktausch"
        $date = Get-Date -Format "dd.MM.yyyy_HH.mm"
        Start-Process -Filepath imagex -NoNewWindow -Wait -ArgumentList "/capture C: N:\image_$date.wim ""Windows 10 Custom"""
        wpeutil shutdown
    }elseif($user -eq "+"){
        Write-Host "exit to shell"
        $window.Dispose()
    }else{
        Write-Host "Windows 10 Installation"

        Start-Process -Filepath diskpart -Wait -ArgumentList "/s D:\diskpart.txt"
        Start-Process -Filepath imagex -Wait -ArgumentList "/apply D:\image.wim 1 C:"
        Start-Process -Filepath bcdboot -Wait -ArgumentList "C:\Windows /l de-De /s S: /F ALL"
        wpeutil reboot
    }
}

$window = New-Object System.Windows.Forms.Form
$window.Width = 275
$window.Height = 175
$window.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$window.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$window.MaximizeBox = $False
#$window.Text = "Windows 10 Installation"

$Label = New-Object System.Windows.Forms.Label
$Label.Location = New-Object System.Drawing.Size(10,10)
$Label.Text = "neuer Benutzername:"
$Label.AutoSize = $True

$txtUser = New-Object System.Windows.Forms.TextBox
$txtUser.Location = New-Object System.Drawing.Size(10,30)
$txtUser.Size = New-Object System.Drawing.Size(230,200)
 
$btnEFI = New-Object System.Windows.Forms.Button
$btnEFI.Location = New-Object System.Drawing.Size(10,60)
$btnEFI.Size = New-Object System.Drawing.Size(100,50)
$btnEFI.Text = "EFI Installation"
$btnEFI.Add_Click({
    $btnEFI.Enabled = $False
    $btnLegacy.Enabled = $False

    apply "efi" $txtUser.Text
    #$window.Dispose()
})

$btnLegacy = New-Object System.Windows.Forms.Button
$btnLegacy.Location = New-Object System.Drawing.Size(120,60)
$btnLegacy.Size = New-Object System.Drawing.Size(120,50)
$btnLegacy.Text = "Legacy Installation"
$btnLegacy.Add_Click({
    $btnEFI.Enabled = $False
    $btnLegacy.Enabled = $False

    apply "legacy" $txtUser.Text
    #$window.Dispose()
})

$window.Controls.Add($Label)
$window.Controls.Add($txtUser)
$window.Controls.Add($btnEFI)
$window.Controls.Add($btnLegacy)

[void]$window.ShowDialog()
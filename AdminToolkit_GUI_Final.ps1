
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# === Настройки автообновления ===
$AutoUpdateEnabled = $true
$LocalVersion = "1.0.0"
$GitHubUser = "Ovcherenkoas"
$GitHubRepo = "AdminToolkit"
$VersionURL = "https://raw.githubusercontent.com/$GitHubUser/$GitHubRepo/main/version.txt"
$ScriptURL = "https://raw.githubusercontent.com/$GitHubUser/$GitHubRepo/main/latest/AdminToolkit_GUI.ps1"
$LogDir = "$PSScriptRoot\Logs"

# === Создание формы ===
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Admin Toolkit v$LocalVersion"
$form.Size = New-Object System.Drawing.Size(430, 450)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true

# === Функция логирования ===
function Write-Log {
    param([string]$Message)
    if (!(Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir | Out-Null }
    $date = Get-Date -Format "yyyy-MM-dd"
    $logPath = Join-Path $LogDir "$date.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp`t$Message" | Out-File -Append -FilePath $logPath
}

function Run-Command {
    param([string]$cmd, [string]$label)
    Write-Log "=== [$label] ==="
    try {
        $output = Invoke-Expression $cmd
        Write-Log $output
        [System.Windows.Forms.MessageBox]::Show("[$label] завершено.", "Готово", "OK", "Information")
    } catch {
        Write-Log "Ошибка: $_"
        [System.Windows.Forms.MessageBox]::Show("Ошибка при выполнении [$label]", "Ошибка", "OK", "Error")
    }
}

# === Кнопки ===
function Add-Button($text, $top, $action) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object System.Drawing.Size(360, 30)
    $btn.Location = New-Object System.Drawing.Point(30, $top)
    $btn.Add_Click($action)
    $form.Controls.Add($btn)
}

Add-Button "Проверка системы (sfc)" 30 { Run-Command "sfc /scannow" "Проверка системных файлов" }
Add-Button "Очистка временных файлов" 70 { Run-Command 'Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue' "Очистка временных файлов" }
Add-Button "Сброс сети" 110 { Run-Command 'ipconfig /flushdns; netsh int ip reset; netsh winsock reset' "Сброс сети" }
Add-Button "Обновление Windows" 150 { Run-Command 'wuauclt /detectnow; wuauclt /reportnow' "Обновление Windows" }

# === Обновление ===
Add-Button "Проверить обновление (GitHub)" 200 {
    if (-not $AutoUpdateEnabled) {
        [System.Windows.Forms.MessageBox]::Show("Автообновление отключено.", "Обновление", "OK", "Warning")
        return
    }
    try {
        $remoteVersion = Invoke-RestMethod -Uri $VersionURL -UseBasicParsing
        if ($remoteVersion -ne $LocalVersion) {
            $choice = [System.Windows.Forms.MessageBox]::Show("Доступна новая версия $remoteVersion. Обновить?", "Обновление", "YesNo", "Information")
            if ($choice -eq "Yes") {
                Invoke-WebRequest -Uri $ScriptURL -OutFile $PSCommandPath -UseBasicParsing
                Start-Process powershell -ArgumentList "-NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`""
                $form.Close()
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("Вы используете последнюю версию ($LocalVersion).", "Обновление", "OK", "Information")
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Ошибка при проверке обновления: $_", "Ошибка", "OK", "Error")
    }
}

# === Выход ===
Add-Button "Выход" 250 { $form.Close() }

# === Отображение даты обновления ===
$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "Последнее обновление: $(Get-Date -Format 'dd.MM.yyyy HH:mm')"
$lbl.AutoSize = $true
$lbl.Location = New-Object System.Drawing.Point(30, 300)
$form.Controls.Add($lbl)

# === Запуск формы ===
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()

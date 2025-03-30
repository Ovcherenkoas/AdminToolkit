
[Setup]
AppName=Admin Toolkit
AppVersion=1.0.0
DefaultDirName={pf}\AdminToolkit
DefaultGroupName=Admin Toolkit
OutputDir=.
OutputBaseFilename=AdminToolkit_Setup
SetupIconFile=AdminToolkit.ico
Compression=lzma
SolidCompression=yes

[Files]
; Убедитесь, что AdminToolkit.exe лежит в той же папке, что и этот .iss-файл
Source: "AdminToolkit.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "AdminToolkit.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Admin Toolkit"; Filename: "{app}\AdminToolkit.exe"; IconFilename: "{app}\AdminToolkit.ico"
Name: "{commondesktop}\Admin Toolkit"; Filename: "{app}\AdminToolkit.exe"; IconFilename: "{app}\AdminToolkit.ico"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "Создать ярлык на рабочем столе"; GroupDescription: "Дополнительные значки:"

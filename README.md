# 🛠 Windows Admin Toolkit

Универсальный GUI-инструмент для системного администратора на PowerShell.

## 💡 Возможности
- Проверка целостности системы (sfc /scannow)
- Очистка временных файлов
- Сброс сетевых настроек
- Обновление Windows
- Автоматическое логирование и архивация
- Автообновление через GitHub

## 📦 Структура репозитория

```
AdminToolkit/
├── AdminToolkit.exe                ← Скомпилированное .exe
├── AdminToolkit_GUI_Final.ps1     ← Исходник GUI
├── AdminToolkit.ico               ← Иконка
├── AdminToolkit_Setup.exe         ← Установщик
├── version.txt                    ← Актуальная версия
├── latest/
│   └── AdminToolkit_GUI.ps1       ← Обновляемый скрипт
```

## 🚀 Обновление
Программа автоматически сверяет локальную версию с `version.txt`.  
Если выходит новая версия, скачивается файл из `/latest/` и программа перезапускается.

## 🔗 GitHub: [Ovcherenkoas](https://github.com/Ovcherenkoas)

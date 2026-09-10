@echo off

set "VIM_DIR=%USERPROFILE%\"
copy /Y .\vim\_vimrc "%VIM_DIR%"
copy /Y .\vim\win\_gvimrc "%VIM_DIR%"

set "VIM_DIR=%USERPROFILE%\vimfiles\"
xcopy /E /I /Y .\vim\vimfiles\ "%VIM_DIR%"

set "NVIM_DIR=%USERPROFILE%\AppData\Local\nvim\"
if not exist "%NVIM_DIR%" (
    md "%NVIM_DIR%"
)

set "NVIM_DIR=%USERPROFILE%\AppData\Local\nvim\init.vim"
copy /Y .\vim\_vimrc "%NVIM_DIR%"

set "NVIM_DIR=%USERPROFILE%\AppData\Local\nvim\ginit.vim"
copy /Y .\vim\nvim\ginit.vim "%NVIM_DIR%"

@echo off
setlocal

:: ���Python�Ƿ��Ѱ�װ�����û�������
:check_python
echo ===============================
echo Checking if Python is installed and configured...
echo ===============================

:: ���Ե���python��������֤�Ƿ����
where python >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not added to the system PATH.
    echo Please install Python and ensure it is added to your system's PATH environment variable.
    echo You can download Python from https://www.python.org/downloads/
    pause
    exit /b 1
) else (
    echo Python is installed and configured.
)

:: ����Python��pip·�������Python����ϵͳ���������У�
:: set PYTHON_PATH=C:\Path\To\Python\python.exe
:: set PIP_PATH=C:\Path\To\Python\Scripts\pip.exe

:: ���Python��pip�Ѿ��ڻ��������У�����ֱ��ʹ���������
set PYTHON_PATH=python
set PIP_PATH=pip


:: ����pip
:upgrade_pip
echo ===============================
echo Upgrading pip...
echo ===============================
%PYTHON_PATH% -m pip install --upgrade pip
if errorlevel 1 (
    echo ERROR: Failed to upgrade pip. Please check your internet connection or permissions.
    pause
    exit /b 1
) else (
    echo Pip has been successfully upgraded.
)


:: ��鲢��װ����Ŀ�
:check_install
echo ===============================
echo Checking and installing required libraries...
echo ===============================

python.exe -m pip install --upgrade pip


for %%i in (tkinter Pillow jieba wordcloud python-docx pywin32 numpy pyinstaller) do (
    echo.
    echo ----------------------------------------
    echo Checking for %%i...
    %PYTHON_PATH% -c "import %%i" >nul 2>&1
    if errorlevel 1 (
        echo %%i not found. Installing...
        %PIP_PATH% install --upgrade %%i
        if errorlevel 1 (
            echo ERROR: Failed to install %%i. Please check your internet connection or permissions.
            pause
            exit /b 1
        ) else (
            echo %%i installed successfully.
        )
    ) else (
        echo %%i is already installed.
    )
)

echo.
echo ===============================
echo All dependencies are satisfied.
echo ===============================

:: ʹ��pyinstaller���Python�ű�
echo.
echo Preparing to build the executable using PyInstaller...
echo Running command:
echo It will generate a standalone executable file from Cloud.py.

:: ִ��pyinstaller����
pyinstaller --onefile --noconsole --add-data "mask_png/*;images" --icon="mask_png/cloud.ico" Cloud.py

if errorlevel 1 (
    echo ERROR: There was a problem building the executable. Please check the output above for details.
    pause
    exit /b 1
) else (
    echo Executable file has been successfully generated.
)

:: �������ɵ�exe�ļ�����ǰĿ¼
echo.
echo Copying Cloud.exe to the current directory...
copy dist\Cloud.exe .\

if errorlevel 1 (
    echo ERROR: Failed to copy wordcoud.exe. Please check if the file exists and you have the necessary permissions.
    pause
    exit /b 1
) else (
    echo Cloud.exe copied successfully.
)

:: ������Ҫ���ļ��к��ļ�
echo.
echo Cleaning up unnecessary files and folders...

:: ɾ��build�ļ���
if exist build (
    rmdir /s /q build
    if exist build (
        echo WARNING: Failed to delete the build folder.
    ) else (
        echo build folder deleted successfully.
    )
) else (
    echo build folder does not exist.
)

:: ɾ��dist�ļ���
if exist dist (
    rmdir /s /q dist
    if exist dist (
        echo WARNING: Failed to delete the dist folder.
    ) else (
        echo dist folder deleted successfully.
    )
) else (
    echo dist folder does not exist.
)

:: ɾ��Cloud.spec�ļ�
if exist Cloud.spec (
    del /q Cloud.spec
    if exist Cloud.spec (
        echo WARNING: Failed to delete end4.spec.
    ) else (
        echo Cloud.spec deleted successfully.
    )
) else (
    echo Cloud.spec does not exist.
)

echo.
echo ===============================
echo Build process completed successfully.
echo ===============================
 
:: ������Cloud.exeΪWordCloud.exe
echo Renaming Cloud.exe to WordCloud.exe...
ren "Cloud.exe" "WordCloud.exe"
 
:: ����������Ƿ�ɹ�����ѡ���裬�������ڵ��ԣ�
if exist "WordCloud.exe" (
    echo Rename successful.
) else (
    echo Rename failed. Cloud.exe not found.
    exit /b 1
)
 
:: ѯ���û��Ƿ���Ҫ����WordCloud
echo.
set /p run_WordCloud=Do you want to run the WordCloud now? (Y/N): 
if /i "%run_WordCloud%"=="Y" (
    echo Running WordCloud.exe...
    start "" "WordCloud.exe"
) else (
    echo Skipping execution of WordCloud.exe.
)
endlocal
pause
wget https://chromedriver.storage.googleapis.com/2.38/chromedriver_win32.zip
wget https://github.com/mozilla/geckodriver/releases/download/v0.24.0/geckodriver-v0.24.0-win64.zip
unzip -o *.zip
cp .\geckodriver.exe D:\workspaceUtils\Poste-Virtuel\bin
cp .\chromedriver.exe D:\workspaceUtils\Poste-Virtuel\bin
del geckodriver*
del chromedriver*
pause
@echo off
rem ============================================================
rem  Compila o Refina para dist\Refina\Refina.exe
rem  Rode este arquivo na mesma pasta do app.py
rem ============================================================
cd /d "%~dp0"

echo [1/2] Instalando dependencias...
python -m pip install -r requirements.txt || goto :erro

echo [2/2] Gerando o executavel...
python -m PyInstaller --noconfirm --clean --windowed --name Refina ^
  --hidden-import openpyxl ^
  --hidden-import pyarrow ^
  --hidden-import duckdb ^
  --hidden-import python_calamine ^
  --exclude-module tkinter ^
  --exclude-module matplotlib ^
  --exclude-module streamlit ^
  app.py || goto :erro

echo.
echo Pronto! Executavel em: dist\Refina\Refina.exe
echo Para distribuir, copie a pasta dist\Refina inteira.
pause
exit /b 0

:erro
echo.
echo Falha na compilacao. Veja as mensagens acima.
pause
exit /b 1

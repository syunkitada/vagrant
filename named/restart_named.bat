@echo off

rem -------------------------------------------------
rem DNSリスタート
rem -------------------------------------------------


rem ■ 変数 ■
rem *** named サービス名 ***
set SERVICE="named"

rem *** BINDのetcディレクトリのパス
set target="C:\Program Files\ISC BIND 9\etc"

rem *** ログ ***
cd /d %~dp0
set LOG=%CD%\service.log



rem ---------------------------

echo ---------- >> %LOG%
date /t >> %LOG%
time /t >> %LOG%


rem ■etcフォルダをコピー
xcopy /Y %CD%\etc %target% >> %LOG%


rem ---------------------------

rem ■サービスの停止
net stop %SERVICE% >> %LOG%

if %errorlevel%==0 goto OK
rem エラーの場合は後の処理を中止
echo エラーが発生しました。 >> %LOG%
time /t >> %LOG%
echo. >> %LOG%
exit

:OK
echo 処理終了時刻 >> %LOG%
time /t >> %LOG%
echo. >> %LOG%


rem ■サービスの開始
net start %SERVICE% >> %LOG%
echo 処理終了時刻 >> %LOG%
time /t >> %LOG%
echo. >> %LOG%
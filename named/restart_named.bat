@echo off

rem -------------------------------------------------
rem DNS���X�^�[�g
rem -------------------------------------------------


rem �� �ϐ� ��
rem *** named �T�[�r�X�� ***
set SERVICE="named"

rem *** BIND��etc�f�B���N�g���̃p�X
set target="C:\Program Files\ISC BIND 9\etc"

rem *** ���O ***
cd /d %~dp0
set LOG=%CD%\service.log



rem ---------------------------

echo ---------- >> %LOG%
date /t >> %LOG%
time /t >> %LOG%


rem ��etc�t�H���_���R�s�[
xcopy /Y %CD%\etc %target% >> %LOG%


rem ---------------------------

rem ���T�[�r�X�̒�~
net stop %SERVICE% >> %LOG%

if %errorlevel%==0 goto OK
rem �G���[�̏ꍇ�͌�̏����𒆎~
echo �G���[���������܂����B >> %LOG%
time /t >> %LOG%
echo. >> %LOG%
exit

:OK
echo �����I������ >> %LOG%
time /t >> %LOG%
echo. >> %LOG%


rem ���T�[�r�X�̊J�n
net start %SERVICE% >> %LOG%
echo �����I������ >> %LOG%
time /t >> %LOG%
echo. >> %LOG%
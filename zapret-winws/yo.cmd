set FILES=%~dp0files\
set GENERAL_LIST=list-general.txt
set DISCORD_IPSET=ipset-discord.txt
set QUIC_BIN=quic_initial_www_google_com.bin

set GENERAL_PATH="%FILES%%GENERAL_LIST%"
set DISCORD_PATH="%FILES%%DISCORD_IPSET%"
set QUIC_PATH="%FILES%%QUIC_BIN%"

set ARGS=^
--filter-udp=443 --hostlist=%GENERAL_PATH% --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic=%QUIC_PATH%
@REM --filter-udp=50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new ^
@REM --filter-tcp=80 --hostlist=%GENERAL_PATH% --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
@REM --filter-tcp=443 --hostlist=%GENERAL_PATH% --dpi-desync=fake,split --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-quic=%QUIC_PATH%
@REM --wf-tcp=80,443 --wf-udp=443,50000-50099 ^
@REM --filter-tcp=80 --hostlist=%GENERAL_PATH% --dpi-desync=fakedsplit --dpi-desync-ttl=4 --dpi-desync-repeats=16 --dpi-desync-fooling=md5sig --new ^
@REM --filter-tcp=443 --hostlist=%GENERAL_PATH% --dpi-desync=fakedsplit --dpi-desync-split-pos=1,midsld --dpi-desync-ttl=4 --dpi-desync-repeats=16 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=padencap --dpi-desync-fake-tls=%QUIC_PATH% --new ^
@REM --filter-udp=443 --hostlist=%GENERAL_PATH% --dpi-desync=fake --dpi-desync-repeats=16 --dpi-desync-fake-quic=%QUIC_PATH% --new ^
@REM --filter-udp=50000-50099 --hostlist=%DISCORD_PATH% --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol --dpi-desync-cutoff=n4
call :srvinst winws1
goto :eof

:srvinst
net stop %1
sc delete %1
sc create %1 binPath= "\"%~dp0winws.exe\" %ARGS%" DisplayName= "zapret DPI bypass : %1" start= auto
sc description %1 "zapret DPI bypass software"
sc start %1

cmd /k
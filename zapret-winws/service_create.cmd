set ARGS=^
--wf-tcp=80,443 --wf-udp=443,50000-50100 ^
--filter-tcp=80 --dpi-desync=fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist=\"%~dp0files\list-youtube.txt\" --dpi-desync=multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new ^
--filter-tcp=443 --dpi-desync=multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=6 --dpi-desync-fooling=badseq,md5sig --new ^
--filter-udp=443 --hostlist=\"%~dp0files\list-youtube.txt\" --dpi-desync=fakedsplit --dpi-desync-repeats=11 --dpi-desync-fake-quic=\"%~dp0files\quic_initial_www_google_com.bin\" --new ^
--filter-udp=443 --dpi-desync=multidisorder --dpi-desync-repeats=11 --new ^
--filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake

call :srvinst winws1
goto :eof

:srvinst
net stop %1
sc delete %1
sc create %1 binPath= "\"%~dp0winws.exe\" %ARGS%" DisplayName= "zapret DPI bypass : %1" start= auto
sc description %1 "zapret DPI bypass software"
sc start %1

cmd /k
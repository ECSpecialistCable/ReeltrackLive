#!/usr/bin/env bash
#cd ???
java -cp .:../web/WEB-INF/lib/*:../web/WEB-INF/classes com.reeltrack.echo.EchoSync >> transaction_log.txt

MsgBox, Select game to get ID
MouseGetPos,,, id
WinGetPos , WinX, WinY, , , ahk_id %id%

MsgBox, Window is X %WinX% Y %WinX%`nSelect game, select this window, hover mouse on inside of zero
MouseGetPos, StartX, StartY

EndX := StartX + 500
PixelSearch, FirstWhiteX, FirstWhiteY, StartX, StartY, EndX, StartY, 0xFFFFFF

MsgBox, X %FirstWhiteX%`nY %FirstWhiteY%
MouseMove, FirstWhiteX, FirstWhiteY

i := 1

while i < 10 {
	MouseGetPos, CurX, CurY
	RelX := CurX - FirstWhiteX
	RelY := CurY - FirstWhiteY
	FileAppend, %RelX% %RelY%  `n, RecordedPositions.txt
	MsgBox, Move mouse to a point within the white circle and press enter
	i++
}


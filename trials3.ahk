MsgBox, Trials Evolution AI

FileReadLine, line, C:\Users\Kyle\Desktop\Organisms.txt, 1
if (!fileExist("Organisms.txt")){
	MsgBox, Organism list does not exist, generating a new species.
} else {
	MsgBox, Organism list loaded.
}

Sleep (500)
SplashImage, C:\Users\Kyle\Desktop\trials.jpg,,,,,
Sleep (500)
SplashImage, Off



MouseGetPos, OX, OY,,,

organism := ""

Array := Object()

i := 1

while i < StrLen(line) + 1 {
	Array.Insert(SubStr(line, i, 1))
	; MsgBox % Array[i]
	i++
}

i := 1
; Exit

while i < StrLen(line) + 1 {
	CurMove := Array[i]
	if % CurMove == 0
	{
		Send {Up Down}
		Sleep (500)
		Send {Up Up}
		organism := organism . "0"
	} else if % CurMove == 1 {
		Sleep (500)
		organism := organism . "1"
	} else if % CurMove == 2 {
		Send {Left Down}
		Sleep (500)
		Send {Left Up}
		organism := organism . "2"
	} else if % CurMove == 3 {
		Send {Right Down}
		Sleep (500)
		Send {Right Up}
		organism := organism . "3"
	}
	GetKeyState, state, NumpadAdd, P
	if state = D
	{
		Break
	}
	ImageSearch, FoundX, FoundY, 0,0, 1920, 1080, C:\Users\Kyle\Desktop\checkers.png
	if FoundX > 10
	{
		FileAppend, %organism%  `n, C:\Users\Kyle\Desktop\Organisms3.txt
		MsgBox, , "Checks detected", , 3
		MouseMove, OX, OY
		Sleep (500)
		Send {Left Down}
		Sleep (500)
		Send {Left Up}
		Sleep (500)
		Send {Left Down}
		Sleep (500)
		Send {Left Up}
		Sleep (500)
		Send {Enter Down}
		Sleep (500)
		Send {Enter Up}
		organism := ""
		; MsgBox "Found checkers, exiting"
		; Exit
	}
	i++
}
MsgBox, End Of Program
MsgBox, Trials Evolution AI


if (!fileExist("Organisms.txt")){
	MsgBox, Organism list does not exist, generating a new species.
	Exit
} else {
	MsgBox, Organism list loaded.
}

Sleep (500)
SplashImage, trials.jpg, b
Sleep (500)
SplashImage, Off

; SplashImage, trials.jpg, , , , Reference


; MsgBox, Welcome to the Trials AI setup!`nPlease place the mouse above "Stats" and press enter
; MouseGetPos, StatsX, StatsY
StatsX := 870
StatsY := 870

; MsgBox, Finally`, place the mouse above the taskbar and press enter
; MouseGetPos, TaskbarX, TaskbarY
TaskbarX := 1000
TaskbarY := 1020

MsgBox, Click "OK" to start the AI!
WinActivate, Trials Evolution Gold Edition
Sleep (2000)

RestartRace()

organism := ""

curLineNumber := 1
while (curLineNumber < 7) {
	FileReadLine, line, Organisms.txt, %curLineNumber%
	; Load organism into array
	Array := Object()

	
	if (SubStr(line, 1, 1) == "f"){
		MsgBox, Found end of file
		Exit
	}
	index := 1
	while index < StrLen(line) + 1 {
		Array.Insert(SubStr(line, index, 1))
		; MsgBox % Array[i]
		index++
	}

	while i < StrLen(line) + 1 {
		CurMove := Array[i]
		if % CurMove == 0
		{
			; Go forward
			Send {Up Down}
			Sleep (500)
			Send {Up Up}
			organism := organism . "0"
		} else if % CurMove == 1 {
			; Do nothing
			Sleep (500)
			organism := organism . "1"
		} else if % CurMove == 2 {
			; Lean left
			Send {Left Down}
			Sleep (500)
			Send {Left Up}
			organism := organism . "2"
		} else if % CurMove == 3 {
			; Lean Right
			Send {Right Down}
			Sleep (500)
			Send {Right Up}
			organism := organism . "3"
		}
		GetKeyState, state, NumpadAdd, P
		if state = D
		{
			MsgBox, Escape detected, ending without saving organism
			Exit
		}
		
		; If the checkers is found, check the score and finish running the organism
		ImageSearch, FoundX, FoundY, 0,0, 1920, 1080, checkers.png
		if FoundX > 10
		{
			MouseMove, 1190, 851, 10
			Sleep (1000)
			Click down
			Sleep (200)
			Click up
			Sleep (500)
			DllCall("SetCursorPos", int, %TaskbarX%, int, %TaskbarY%)
			MouseMove, TaskbarX, TaskbarY
			Click
			Score := ReadScore()
			FileAppend, %organism%`t%Score%`n, Organisms2.txt
			organism := ""
			WinActivate, Trials Evolution Gold Edition
			Sleep (1000)
			RestartRace()
			Break
		}
		i++
	}
	curLineNumber++
	; MsgBox, CurLineNumber is %curLineNumber%
}
MsgBox, End Of Program

RestartRace(){
	WinActivate, Trials Evolution Gold Edition
	MouseMove, 292, 870, 100
	Sleep (2000)
	Click down
	Sleep (200)
	Click up
	Sleep (7000)
}

class organism {
	DNA := Object()
	Score := 0
}

ReadScore(){
	Sleep (1000)
	
	PixelSearch, FirstOrangeX, , 400, -787, 500, -787, 0x00ACFF
	
	val := -1
	if (FirstOrangeX == 452) {
		val := CheckRegion(738, -787)
	} else if (FirstOrangeX == 435) {
		val := CheckRegion(721, -787)
		val *= 10
		val2 := CheckRegion(755, -787)
		val += val2
	} else if (FirstOrangeX == 418) {
		val := CheckRegion(704, -787)
		val *= 100
		val2 := CheckRegion(738, -787)
		val2 *= 10
		val += val2
		val3 := CheckRegion(772, -787)
		val += val3
	} else {
		MsgBox, Distance could not be found!
	}

	return val
}

CheckRegion(PosX, PosY){
	if (CheckLikenessOf(PosX, PosY, 8)){
		return 8
	} else if (CheckLikenessOf(PosX, PosY, 9)){
		return 9
	} else if (CheckLikenessOf(PosX, PosY, 6)){
		return 6
	} else if (CheckLikenessOf(PosX, PosY, 0)){
		return 0
	} else if (CheckLikenessOf(PosX, PosY, 3)){
		return 3
	} else if (CheckLikenessOf(PosX, PosY, 5)){
		return 5
	} else if (CheckLikenessOf(PosX, PosY, 4)){
		return 4
	} else if (CheckLikenessOf(PosX, PosY, 2)){
		return 2
	} else if (CheckLikenessOf(PosX, PosY, 7)){
		return 7
	} else if (CheckLikenessOf(PosX, PosY, 1)){
		return 1
	} else {
		MsgBox, Number could not be read!
		Exit
		return -1
	}
}

CheckLikenessOf(DigitX, DigitY, NumToCheck)
{
	Loop, Read, Positions_%NumToCheck%.txt
	{
		Line := Trim(A_LoopReadLine)
		Line := StrSplit(Line, " ", "`n")
		CurX := Line[1]
		CurY := Line[2]
		TranslatedX := CurX + DigitX
		TranslatedY := CurY + DigitY
		
		PixelGetColor, ActualColor, TranslatedX, TranslatedY
		White := 0xFFFFFF
		; MouseMove, TranslatedX, TranslatedY
		if (ActualColor == White)
		{
			; MsgBox, Looks good for %NumToCheck%
		} else {
			; MsgBox, Looks bad for %NumToCheck% at`n%CurX% %CurY%
			return false
		}
	}
	; MsgBox, Looks good for %NumToCheck%
	return true
}

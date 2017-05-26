MsgBox, Trials Evolution AI

if (!fileExist("UntestedOrganisms.txt")){
	MsgBox, Organism list does not exist, closing.
	Exit
} else {
	MsgBox, Organism list loaded.
}

ifWinNotExist, Trials Evolution Gold Edition
{
	MsgBox, Trials is not open; please open the game before running this program
	Exit
}

Sleep (500)
SplashImage, program.png, b
Sleep (500)
SplashImage, Off

; MsgBox, Welcome to the Trials AI setup!`nPlease place the mouse above "Stats" and press enter
; MouseGetPos, StatsX, StatsY
StatsX := 870
StatsY := 870

; MsgBox, Finally`, place the mouse above the taskbar and press enter
; MouseGetPos, TaskbarX, TaskbarY
TaskbarX := 1000
TaskbarY := 1020

MsgBox, 4,, Click "Yes" to start the AI!'
IfMsgBox No
	Exit
	
WinActivate, Trials Evolution Gold Edition
Sleep (2000)

RestartRace()

organism := ""

curLineNumber := 1
Loop, read, UntestedOrganisms.txt
{
	line := A_LoopReadLine
	
	; Load organism into array
	Array := Object()
	
	if (SubStr(line, 1, 1) == "f"){
		MsgBox, Found end of file
		Exit
	}
	index := 1
	while index < StrLen(line) + 1 {
		Array.Insert(SubStr(line, index, 1))
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
			; Lean right
			Send {Right Down}
			Sleep (500)
			Send {Right Up}
			organism := organism . "3"
		} else if % CurMove == 4 {
			; Lean right, go forward
			Send {Right Down}
			Send {Up Down}
			Sleep (500)
			Send {Right Up}
			Send {Up Up}
			organism := organism . "4"
		} else if % CurMove == 5 {
			; Lean left, go forward
			Send {Left Down}
			Send {Up Down}
			Sleep (500)
			Send {Left Up}
			Send {Up Up}
			organism := organism . "5"
		} else if % CurMove == 6 {
			; Stop
			Send {Down Down}
			Sleep (500)
			Send {Down Up}
			organism := organism . "6"
		} else if % CurMove == 7 {
			; Lean right, stop
			Send {Right Down}
			Send {Down Down}
			Sleep (500)
			Send {Right Up}
			Send {Down Up}
			organism := organism . "7"
		} else if % CurMove == 8 {
			; Lean left, stop
			Send {Right Down}
			Send {Down Down}
			Sleep (500)
			Send {Right Up}
			Send {Down Up}
			organism := organism . "8"
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
			MouseMove, 1200, 851, 10
			MouseMove, 1200, 900, 10
			MouseMove, 1200, 851, 10
			Sleep (1000)
			Click down
			Sleep (200)
			Click up
			Sleep (5000)
			DllCall("SetCursorPos", int, %TaskbarX%, int, %TaskbarY%)
			MouseMove, TaskbarX, TaskbarY
			Click
			Score := ReadScore()
			FileAppend, %organism%`t%Score%`n, TestedOrganisms.txt
			organism := ""
			WinActivate, Trials Evolution Gold Edition
			Sleep (1000)
			RestartRace()
			Break
		}
		i++
	}
	curLineNumber++
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
	MouseMove, FirstOrangeX, 15, 10
	
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
		Exit
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
		MouseMove, TranslatedX, TranslatedY, 10
		if (ActualColor == White)
		{
		} else {
			return false
		}
	}
	return true
}

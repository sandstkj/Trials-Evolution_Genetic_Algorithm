MsgBox, Select the game, the taskbar, then this window and press enter

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
	Exit
}

MsgBox, The number is %val%

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
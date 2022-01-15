; ##### User Config #####

AbsoluteSwitch := "."
ShowGrid := True
PartialGrid := False

Hyper := "#!^+"

ChordX1 := "1"
ChordX2 := "2"
ChordX3 := "3"
ChordX4 := "4"
ChordX5 := "5"
ChordX6 := "6"
ChordX7 := "7"
ChordX8 := "8"
ChordX9 := "9"

ChordY1 := "a"
ChordY2 := "b"
ChordY3 := "c"
ChordY4 := "e"
ChordY5 := "f"
ChordY6 := "g"
ChordY7 := "h"
ChordY8 := "i"
ChordY9 := "j"

WriteLogs := False
GridSize := 9
StartAtLowerLeft := True

; ##### End User Config #####



CoordMode "Mouse", "Screen"
ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / GridSize
BlockHeight := ScreenHeight / GridSize
InAbsolute := false
SetupOverlay()
SetupChordKeys()

; Without * or $, IsActive fails while held. & is less aggressive, so modifier combos treat the key normally
;Hotkey "$" Leader, StartMouseMode

;InMouseMode := False

Log(message) {
    if (WriteLogs)
        OutputDebug message
}

SetupChordKeys(*) {
    for key in [ChordX1, ChordX2, ChordX3, ChordX4, ChordX5, ChordX6, ChordX7, ChordX8, ChordX9, ChordY1, ChordY2, ChordY3, ChordY4, ChordY5, ChordY6, ChordY7, ChordY8, ChordY9] {
        Hotkey Hyper key, StartChording, true
    }
}

StartChording(*) {
    if (InAbsolute)
        return
    Log "Enter Chord Mode"
    
    global InAbsolute := true
    global ChordKeysPressed := 0
    ShowOverlay()
    SetTimer(EventLoop, 25)
}


EventLoop() {
    Log Format("Event Loop")

    finishedChord := (ChordKeysPressed > 0 and GetActiveChordKeys() = 0)
    if (finishedChord) {
        Log "Exiting Absolute"
        HideOverlay()
        global ChordKeysPressed := 0
        global InAbsolute := false
        ExitChording()
    }
    if (GetActiveChordKeys() > ChordKeysPressed) {
        HandleAbsolute()
    }
}

ExitChording() {
    Log "Exit Mouse Mode"
    SetTimer(EventLoop, 0)
    HideOverlay()
}

SetupOverlay() {
    Log("Setup Overlay")
    if (not ShowGrid)
        return
    global MyGui := Gui()
    MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow -DPIScale") ; On top, no caption, don't put in start bar or alt-tab
    MyGui.MarginX := 0
    MyGui.MarginY := 0
    MyGui.BackColor := "EEAA99" ; The random color that will be made invisible
    MyGui.SetFont("s15") ; sXX = point size
    transAmount := 75 ; out of 255
    WinSetTransColor(MyGui.BackColor " " transAmount, MyGui) ; 50 is translucent
    DrawAbsBlockMarks()
 }

AddBlockMark(x, y, label, alternate := false) {
    ; E0x200 gives sunken edge border that shows up ok[]
    back := (alternate) ? "000000" : "303030"
    MyGui.Add("Text", Format("x{1} y{2} w{3} h{4} cAA0000 center background{5}", x, y, BlockWidth, BlockHeight, back), label)
}

ShowOverlay() {
    if (not ShowGrid)
        return
    Log "Show Overlay"
    MyGui.Show(Format("x0 y0 NoActivate", ScreenWidth, ScreenHeight)) ; Keep current win activated
}

HideOverlay() {
    if (not ShowGrid)
        return
    MyGui.Hide()
}

HandleAbsolute() {
    Log("Handle Absolute")
    global ChordKeysPressed := GetActiveChordKeys()
    xKeys := [ChordX1, ChordX2, ChordX3, ChordX4, ChordX5, ChordX6, ChordX7, ChordX8, ChordX9]
    xBlock := CheckDimension(xKeys)

    yKeys := [ChordY1, ChordY2, ChordY3, ChordY4, ChordY5, ChordY6, ChordY7, ChordY8, ChordY9]
    yBlock := CheckDimension(yKeys)
    
    GoToBlock(xBlock, yBlock)
}

GetActiveChordKeys() {
    total := 0
    for key in [ChordX1, ChordX2, ChordX3, ChordX4, ChordX5, ChordX6, ChordX7, ChordX8, ChordX9, ChordY1, ChordY2, ChordY3, ChordY4, ChordY5, ChordY6, ChordY7, ChordY8, ChordY9] {
        total += IsActive(key)
    }
    return total
}

DrawAbsBlockMarks() {
    alternate := False
    for nX in Range(1, GridSize) {
        for nY in Range(1, GridSize) {
            if (PartialGrid and !(nX = 1 or nX = 9 or nY = 1 or nY = 9 or (nX = 5 and nY = 5)))
                Continue
            xPos := ((nX - 1) * BlockWidth)
            yPos := ((nY - 1) * BlockHeight)
            yPos := ScreenHeight-yPos-BlockHeight ; Paint from lower left instead of upper left
            ; Log Format("x{1}: {2}, y{3}: {4}", nX, xPos, nY, yPos)
            AddBlockMark(xPos, yPos, nX "," nY, alternate)
            alternate := !alternate
        }
        if (not IsEven(GridSize))
            alternate := !alternate
    }
}

IsEven(n) {
    return Mod(n, 2) = 0
}

Range(start, end, step := 1) {
    range := []
    current := start - step

    return (&v) => (
        &v := current, current += step, v <= end
    )
}

CheckDimension(keys) {
    if (MatchMask(keys, [1, 0, 0, 0, 0, 0, 0, 0, 0]))
        return 1
    if (MatchMask(keys, [0, 1, 0, 0, 0, 0, 0, 0, 0]))
        return 2
    if (MatchMask(keys, [0, 0, 1, 0, 0, 0, 0, 0, 0]))
        return 3
    if (MatchMask(keys, [0, 0, 0, 1, 0, 0, 0, 0, 0]))
        return 4
    if (MatchMask(keys, [0, 0, 0, 0, 1, 0, 0, 0, 0]))
        return 5
    if (MatchMask(keys, [0, 0, 0, 0, 0, 1, 0, 0, 0]))
        return 6
    if (MatchMask(keys, [0, 0, 0, 0, 0, 0, 1, 0, 0]))
        return 7
    if (MatchMask(keys, [0, 0, 0, 0, 0, 0, 0, 1, 0]))
        return 8
    if (MatchMask(keys, [0, 0, 0, 0, 0, 0, 0, 0, 1]))
        return 9
    return 0
}

MatchMask(keys, masks) {
    return IsActive(keys[1]) = masks[1] and IsActive(keys[2]) = masks[2] and IsActive(keys[3]) = masks[3] and IsActive(keys[4]) = masks[4] and IsActive(keys[5]) = masks[5] and IsActive(keys[6]) = masks[6] and IsActive(keys[7]) = masks[7] and IsActive(keys[8]) = masks[8] and IsActive(keys[9]) = masks[9]
}

IsActive(key) {
    return GetKeyState(key, "P")
}

GoToBlock(blockX, blockY) {
    MouseGetPos &currentX, &currentY

    x := (blockX != 0) ? ((blockX - 1) * BlockWidth) + (BlockWidth / 2) : currentX
    y := ((blockY - 1) * BlockHeight) + (BlockHeight / 2)
    y := (blockY != 0) ? ScreenHeight-y : currentY ; Paint from lower left instead of upper left

    MouseMove x, y
}

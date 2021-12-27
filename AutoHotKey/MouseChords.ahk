; ##### User Config #####

Leader := "["
LClick := "Space"
RClick := "/"

AbsoluteSwitch := "\"
StartAtLowerLeft := true
ShowGrid := True
PartialGrid := False
ChordXNull := "z"
ChordYNull := "v"
ChordX1 := "a"
ChordX2 := "s"
ChordX3 := "q"
ChordX4 := "w"
ChordY1 := "d"
ChordY2 := "f"
ChordY3 := "e"
ChordY4 := "r"

Movement := "]"
MoveDown := "d"
MoveUp := "e"
MoveLeft := "s"
MoveRight := "f"
WheelUp := "w"
WheelDown := "c"

WriteLogs := false

; ##### End User Config #####



CoordMode "Mouse", "Screen"
ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

SetupOverlay()
Hotkey "*" Leader, StartMouseMode

InMouseMode := false

Log(message) {
    if (WriteLogs)
        OutputDebug message
}

StartMouseMode(*) {
    if (InMouseMode)
        return
    Log "Enter Mouse Mode"
    
    global InMouseMode := true
    global DidSomething := false
    global InRelative := true
    global InAbsolute := false
    global ChordKeysPressed := 0
    global AbsoluteSwitchLifted := false

    SetTimer(EventLoop, 50)
}


EventLoop() {
    SetSecondaryHotkeys("On")
    Log Format("Event Loop")
    if (IsActive(AbsoluteSwitch)) {
        global DidSomething := True
        if (not InAbsolute) {
            Log "Entering Absolute"
            global InRelative := False
            global InAbsolute := True
            global AbsoluteSwitchLifted := false
            ShowOverlay()
            if (StartAtLowerLeft)
                GoToBlock(1, 1)
        }
    }

    if (InAbsolute) {
        if (not IsActive(AbsoluteSwitch))
            global AbsoluteSwitchLifted := True
        finishedChord := (ChordKeysPressed > 0 and GetActiveChordKeys() = 0)
        rePressedSwitch := (AbsoluteSwitchLifted and IsActive(AbsoluteSwitch))
        if (finishedChord or rePressedSwitch) {
            Log "Exiting Absolute"
            HideOverlay()
            global ChordKeysPressed := 0
            global InAbsolute := false
            global InRelative := true
            if (rePressedSwitch)
                KeyWait AbsoluteSwitch ; Prevent immediately reactivating it
        }
        if (GetActiveChordKeys() > ChordKeysPressed)
            HandleAbsolute()
    }

    if (InRelative) {
        global DidSomething := True
        if (IsActive(MoveLeft))
            DoMove(-1, 0)
        if (IsActive(MoveRight))
            DoMove(1, 0)
        if (IsActive(MoveUp))
            DoMove(0, -1)
        if (IsActive(MoveDown))
            DoMove(0, 1)
        if (IsActive(WheelDown))
            DoWheel(True)
        if (IsActive(WheelUp))
            DoWheel(False)
    }

    if (IsActive(Movement)) {
        global DidSomething := True
    }

    if (not IsActive(Leader)) {
        Log "Exit Mouse Mode"
        SetTimer(EventLoop, 0)
        HideOverlay()
        SetSecondaryHotkeys("Off")
        global InMouseMode := false
        if (not DidSomething) {
            Send Leader
        }
    }
}

SetupOverlay() {
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
    global ChordKeysPressed := GetActiveChordKeys()
    xKeys := [ChordX1, ChordX2, ChordX3, ChordX4]
    xBlock := (!IsActive(ChordXNull)) ? CheckDimension(xKeys) : 1

    yKeys := [ChordY1, ChordY2, ChordY3, ChordY4]
    yBlock := (!IsActive(ChordYNull)) ? CheckDimension(yKeys) : 1
    
    GoToBlock(xBlock, yBlock)
}

GetActiveChordKeys() {
    total := 0
    for key in [ChordX1, ChordX2, ChordX3, ChordX4, ChordY1, ChordY2, ChordY3, ChordY4, ChordXNull, ChordYNull] {
        total += IsActive(key)
    }
    return total
}

DrawAbsBlockMarks() {
    alternate := False
    oneToNine := [1, 2, 3, 4, 5, 6, 7, 8, 9]
    for nX in oneToNine {
        for nY in oneToNine {
            if (PartialGrid and !(nX = 1 or nX = 9 or nY = 1 or nY = 9 or (nX = 5 and nY = 5)))
                Continue
            xPos := ((nX - 1) * BlockWidth)
            yPos := ((nY - 1) * BlockHeight)
            yPos := ScreenHeight-yPos-BlockHeight ; Paint from lower left instead of upper left
            ; Log Format("x{1}: {2}, y{3}: {4}", nX, xPos, nY, yPos)
            AddBlockMark(xPos, yPos, nX "," nY, alternate)
            alternate := !alternate
        }
    }
}

CheckDimension(keys) {
    ; if (IsActive(ChordNull))
    ;     return 1
    ; if (MatchMask(keys, [0, 0, 0, 0]))
    ;     return 1
    if (MatchMask(keys, [1, 0, 0, 0]))
        return 2
    if (MatchMask(keys, [0, 1, 0, 0]))
        return 3
    if (MatchMask(keys, [1, 0, 0, 1]))
        return 4
    if (MatchMask(keys, [1, 1, 0, 0]))
        return 5
    if (MatchMask(keys, [0, 0, 1, 0]))
        return 6
    if (MatchMask(keys, [0, 0, 0, 1]))
        return 7
    if (MatchMask(keys, [0, 1, 1, 0]))
        return 8
    if (MatchMask(keys, [0, 0, 1, 1]))
        return 9
    return 0
}

MatchMask(keys, masks) {
    return IsActive(keys[1]) = masks[1] and IsActive(keys[2]) = masks[2] and IsActive(keys[3]) = masks[3] and IsActive(keys[4]) = masks[4]
}

DoMove(x, y) {
    MouseMove (x * (BlockWidth / 9)), (y * (BlockHeight / 9)), , "Relative"
}
DoWheel(isDown) {
    ; Using this still scrolls too much: MouseClick "WheelDown",,, 1
    direction := isDown ? -1 : 1
    MouseGetPos &mouseX, &mouseY, &mouseWin

    amount := 50 * direction
    mousewheel_code := 0x20A
    PostMessage mousewheel_codex, amount<<16, mouseX|(mouseY<<16),, "ahk_id " mouseWin
}

Nada := (*) => ""

IsActive(key) {
    return GetKeyState(key, "P")
}

SetSecondaryHotkeys(state) {
    Hotkey "*" LClick, DoLeftClick, state
    Hotkey "*" RClick, DoRightClick, state

    for key in [AbsoluteSwitch, ChordXNull, ChordX1, ChordX2, ChordX3, ChordX4, ChordYNull, ChordY1, ChordY2, ChordY3, ChordY4, WheelDown, WheelUp] {
        Hotkey "*" key, Nada, state
    }
}

DoLeftClick(*) {
    Click "Left"
}

DoRightClick(*) {
    Click "Right"
}

GoToBlock(blockX, blockY) {
    MouseGetPos &currentX, &currentY

    x := (blockX != 0) ? ((blockX - 1) * BlockWidth) + (BlockWidth / 2) : currentX
    y := ((blockY - 1) * BlockHeight) + (BlockHeight / 2)
    y := (blockY != 0) ? ScreenHeight-y : currentY ; Paint from lower left instead of upper left

    MouseMove x, y
}

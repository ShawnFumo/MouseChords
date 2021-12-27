CoordMode "Mouse", "Screen"

ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

Leader := "["
LClick := "Space"
RClick := "/"

Absolute := "\"
; ChordNull := "g"
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
MoveLeftAlt := "z"
MoveDownAlt := "x"
MoveUpAlt := "c"
MoveRightAlt := "v"

SetupOverlay()
Hotkey "*" Leader, HandleChord

HandleChord(*) {
    SetSecondaryHotkeys("On")
    DidSomething := False
    InAbs := false

    Loop {
        if (IsActive(Absolute)) {
            DidSomething := True
            if (not InAbs) {
                InAbs := True
                ShowOverlay()
            }
            HandleAbsolute()
        } else {
            if (InAbs) {
                InAbs := false
                HideOverlay()
            }
        }

        if (IsActive(Movement)) {
            DidSomething := True
        }

        if (not IsActive(Leader)) {
            SetSecondaryHotkeys("Off")
            if (not DidSomething) {
                Send Leader
            }
            break
        }
    }
}

SetupOverlay() {
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
    MyGui.Show(Format("x0 y0 NoActivate w{1} h{2}", ScreenWidth, ScreenHeight)) ; Keep current win activated
}

HideOverlay() {
    MyGui.Hide()
}

HandleAbsolute() {
    xKeys := [ChordX1, ChordX2, ChordX3, ChordX4]
    xBlock := (!IsActive(ChordXNull)) ? CheckDimension(xKeys) : 1

    yKeys := [ChordY1, ChordY2, ChordY3, ChordY4]
    yBlock := (!IsActive(ChordYNull)) ? CheckDimension(yKeys) : 1
    
    GoToBlock(xBlock, yBlock)
}

DrawAbsBlockMarks() {
    alternate := False
    oneToNine := [1, 2, 3, 4, 5, 6, 7, 8, 9]
    for nX in oneToNine {
        for nY in oneToNine {
            xPos := ((nX - 1) * BlockWidth)
            yPos := ((nY - 1) * BlockHeight)
            yPos := ScreenHeight-yPos-BlockHeight ; Paint from lower left instead of upper left
            ; OutputDebug Format("x{1}: {2}, y{3}: {4}", nX, xPos, nY, yPos)
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

DoMoveDown(*) {
    DoMove(0, 1)
}
DoMoveUp(*) {
    DoMove(0, -1) 
}
DoMoveLeft(*) {
    DoMove(-1, 0)
}
DoMoveRight(*) {
    DoMove(1, 0) 
}

DoMove(x, y) {
    MouseMove (x * (BlockWidth / 5)), (y * (BlockHeight / 5)), , "Relative"
}

Nada := (*) => ""

IsActive(key) {
    return GetKeyState(key, "P")
}

SetSecondaryHotkeys(state) {
    Hotkey "*" LClick, DoLeftClick, state
    Hotkey "*" RClick, DoRightClick, state

    for key in [Absolute, ChordXNull, ChordX1, ChordX2, ChordX3, ChordX4, ChordYNull, ChordY1, ChordY2, ChordY3, ChordY4] {
        Hotkey "*" key, Nada, state
    }

    Hotkey Movement " & " MoveDown, DoMoveDown, state
    Hotkey Movement " & " MoveUp, DoMoveUp, state
    Hotkey Movement " & " MoveLeft, DoMoveLeft, state
    Hotkey Movement " & " MoveRight, DoMoveRight, state
    ; Hotkey "*" MoveDownAlt, DoMoveDown, state
    ; Hotkey "*" MoveUpAlt, DoMoveUp, state
    ; Hotkey "*" MoveLeftAlt, DoMoveLeft, state
    ; Hotkey "*" MoveRightAlt, DoMoveRight, state
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

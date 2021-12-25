CoordMode "Mouse", "Screen"

ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

Leader := "\"
Absolute := "]"
ChordX1 := "r"
ChordX2 := "f"
ChordX3 := "e"
ChordX4 := "d"
ChordY1 := "w"
ChordY2 := "s"
ChordY3 := "q"
ChordY4 := "a"

Hotkey "*" Leader, HandleChord

HandleChord(*) {
    SetSecondaryHotkeys("On")
    DidSomething := False

    Loop {
        if (IsActive(Absolute)) {
            DidSomething := True
            xKeys := [ChordX1, ChordX2, ChordX3, ChordX4]
            xBlock := CheckDimension(xKeys)

            yKeys := [ChordY1, ChordY2, ChordY3, ChordY4]
            yBlock := CheckDimension(yKeys)
            
            GoToBlock(xBlock, yBlock)
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

CheckDimension(keys) {
    if (MatchMask(keys, [0, 0, 0, 0]))
        return 1
    if (MatchMask(keys, [1, 0, 0, 0]))
        return 2
    if (MatchMask(keys, [0, 1, 0, 0]))
        return 3
    if (MatchMask(keys, [0, 0, 1, 0]))
        return 4
    if (MatchMask(keys, [1, 0, 1, 0]))
        return 5
    if (MatchMask(keys, [0, 1, 1, 0]))
        return 6
    if (MatchMask(keys, [0, 0, 0, 1]))
        return 7
    if (MatchMask(keys, [1, 0, 0, 1]))
        return 8
    if (MatchMask(keys, [0, 1, 0, 1]))
        return 9
    return 1
}

MatchMask(keys, masks) {
    return IsActive(keys[1]) = masks[1] and IsActive(keys[2]) = masks[2] and IsActive(keys[3]) = masks[3] and IsActive(keys[4]) = masks[4]
}

Nada(*) {
    return
}

IsActive(key) {
    return GetKeyState(key, "P")
}

SetSecondaryHotkeys(state) {
    for key in [Absolute, ChordX1, ChordX2, ChordX3, ChordX4, ChordY1, ChordY2, ChordY3, ChordY4] {
        Hotkey "*" key, Nada, state
    }
}

GoToBlock(blockX, blockY) {
    x := ((blockX - 1) * BlockWidth) + (BlockWidth / 2)
    y := ((blockY - 1) * BlockHeight)
    MouseMove x, y
}

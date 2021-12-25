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

Hotkey "*" Leader, HandleChord

HandleChord(*) {
    SetSecondaryHotkeys("On")
    DidSomething := False

    Loop {
        if (IsActive(Absolute)) {
            DidSomething := True
            if (not IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 1
            }
            if (IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 2
            }
            if (not IsActive(ChordX1) and IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 3
            }
            if (not IsActive(ChordX1) and not IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 4
            }
            if (IsActive(ChordX1) and not IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 5
            }
            if (not IsActive(ChordX1) and IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
                xBlock := 6
            }
            if (not IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
                xBlock := 7
            }
            if (IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
                xBlock := 8
            }
            if (not IsActive(ChordX1) and IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
                xBlock := 9
            }

            GoToBlock(xBlock, 1)
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

Nada(*) {
    return
}
IsActive(key) {
    return GetKeyState(key, "P")
}
SetSecondaryHotkeys(state) {
    for key in [Absolute, ChordX1, ChordX2, ChordX3, ChordX4] {
        Hotkey "*" key, Nada, state
    }
}

GoToBlock(blockX, blockY) {
    x := ((blockX - 1) * BlockWidth) + (BlockWidth / 2)
    y := ((blockY - 1) * BlockHeight)
    MouseMove x, y
}

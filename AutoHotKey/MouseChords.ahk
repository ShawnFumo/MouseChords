CoordMode "Mouse", "Screen"

ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

Leader := "\"
Leader2 := "]"
ChordX1 := "r"
ChordX2 := "f"
ChordX3 := "e"
ChordX4 := "d"

Hotkey Leader " & " Leader2, HandleChord
Hotkey Leader2 " & " Leader, HandleChord
Hotkey Leader " & " ChordX1, HandleChord
Hotkey Leader " & " ChordX2, HandleChord
Hotkey Leader " & " ChordX3, HandleChord
Hotkey Leader " & " ChordX4, HandleChord
Hotkey Leader, LeaderNormal

LeaderNormal(*) {
    Send Leader
}

HandleChord(*) {
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
IsActive(key) {
    return GetKeyState(key, "P")
}

GoToBlock(blockX, blockY) {
    x := ((blockX - 1) * BlockWidth) + (BlockWidth / 2)
    y := ((blockY - 1) * BlockHeight)
    MouseMove x, y
}

CoordMode "Mouse", "Screen"

ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

Leader := "\"
ChordX1 := "r"
ChordX2 := "f"
ChordX3 := "e"
ChordX4 := "d"

Hotkey Leader " & " ChordX1, HandleChord
Hotkey Leader " & " ChordX2, HandleChord
Hotkey Leader " & " ChordX3, HandleChord
Hotkey Leader " & " ChordX4, HandleChord
Hotkey Leader, LeaderNormal

LeaderNormal(*) {
    Send Leader
}

/*
00
01
02
10
11
12
20
21
22
*/

HandleChord(*) {
    if (not IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 1)
    }
    if (IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 2)
    }
    if (not IsActive(ChordX1) and IsActive(ChordX2) and not IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 3)
    }
    if (not IsActive(ChordX1) and not IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 4)
    }
    if (IsActive(ChordX1) and not IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 5)
    }
    if (not IsActive(ChordX1) and IsActive(ChordX2) and IsActive(ChordX3) and not IsActive(ChordX4)) {
        GoToBlock(1, 6)
    }
    if (not IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
        GoToBlock(1, 7)
    }
    if (IsActive(ChordX1) and not IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
        GoToBlock(1, 8)
    }
    if (not IsActive(ChordX1) and IsActive(ChordX2) and not IsActive(ChordX3) and IsActive(ChordX4)) {
        GoToBlock(1, 9)
    }
    ; OutputDebug "f: " GetKeyState("f", "P")
    ; OutputDebug "r: " GetKeyState("r", "P") 
}
IsActive(key) {
    return GetKeyState(key, "P")
}

GoToBlock(blockX, blockY) {
    x := ((blockX - 1) * BlockWidth)
    y := ((blockY - 1) * BlockHeight)
    MouseMove x, y
}

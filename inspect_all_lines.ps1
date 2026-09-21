Add-Type -AssemblyName System.Drawing

$bmp = [System.Drawing.Bitmap]::FromFile("C:\Users\HLC2023\.factory\temp\images\2e050b59\fbdb6261-a8ce-4e9e-9285-3eb0f6357a31.png")

# Let's inspect each line on the table:
# Header 1X2 at top left:
# Fulham: 3.55 | Draw: 3.76 | Man United: 2.03

# Asian Handicap (Left & Right):
# Fulham +0/0.5 vs Man United -0/0.5
# Fulham +0.5 vs Man United -0.5
# Fulham +0.5/1.0 vs Man United -0.5/1.0
# Fulham +1.0 vs Man United -1.0

# Over/Under (Tài/Xỉu bàn thắng):
# Tài 2.5 @ 1.62 | Xỉu 2.5 @ 2.39 (or let's check)
# Tài 2.5/3.0 (2.75) | Xỉu 2.5/3.0
# Tài 3.0 | Xỉu 3.0
# Tài 3.0/3.5 (3.25) | Xỉu 3.0/3.5
# Tài 3.5 | Xỉu 3.5

# Cược tổng số bàn thắng (Total Goals band):
# 0-1 bàn, 2-3 bàn, 4-6 bàn, 7 bàn trở lên? Or:
# Tài 0.5, Tài 1.5, Tài 2.5, Tài 3.5, Tài 4.5, Tài 5.5, Tài 6.5?

# Both Teams to Score (BTTS):
# Có (Yes) @ 1.51 | Không (No) @ 2.55

# Corners:
# Tài 10.0 @ 1.94 | Xỉu 10.0 @ 1.86

# Let's write a script to crop and read the exact text and numbers for:
# 1. Asian Handicap lines
# 2. Over/Under lines (Tài/Xỉu 2.5/3.0, 3.0, etc.)
# 3. 1X2 lines

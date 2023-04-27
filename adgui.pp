unit adgui;

{$I-}

interface

procedure PrintInfo;

procedure PrintAsyaDrawLogo;

procedure MessageScaleScreen(ScrnWidth, ScrnHeight: integer);

procedure PrintStartScreen;

procedure ShowReadString(mes: string; x, y: integer);

procedure PrintFilename(filename: string);

procedure IOResultOpenFile;

procedure IOResultWriteFile;

procedure IOResultCreateFile;

procedure IOResultReadFile;

implementation
uses crt;

procedure PrintAnyMes(color, back, x, y: integer; var mes: string);
begin
	TextColor(color);
	TextBackground(back);
	GotoXY(x, y);
	write(mes)
end;

procedure PrintInfo;
var
	symb: string = '|Symbol: ';
	info: string = '| AsyaDraw is a free simple ASCII graphics editor using Free Pascal |';
begin
	PrintAnyMes(White, Black, 1, 1, symb);
	PrintAnyMes(White, Black, 12, 1, info);
end;

{$I-}

procedure PrintAsyaDrawLogo;
var
	cX, cY: integer;
	s1: string = '    ___                     ____                     ';
	s2: string = '   /   |  _______  ______ _/ __ \_________ __      __';
	s3: string = '  / /| | / ___/ / / / __ `/ / / / ___/ __ `/ | /| / /';
	s4: string = ' / ___ |(__  ) /_/ / /_/ / /_/ / /  / /_/ /| |/ |/ / ';
	s5: string = '/_/  |_/____/\__, /\__,_/_____/_/   \__,_/ |__/|__/  ';
	s6: string = '            /____/                                   ';
begin
	cX := ScreenWidth div 2 - Length(s1) div 2 + 1;
	cY := 1;
	PrintAnyMes(LightCyan, Black, cX, cY, s1);
	PrintAnyMes(LightCyan, Black, cX, cY + 1, s2);
	PrintAnyMes(LightCyan, Black, cX, cY + 2, s3);
	PrintAnyMes(LightCyan, Black, cX, cY + 3, s4);
	PrintAnyMes(LightCyan, Black, cX, cY + 4, s5);
	PrintAnyMes(LightCyan, Black, cX, cY + 5, s6);
end;

procedure PrintFrame(x, y, sizeX, sizeY: integer);
var
	i: integer;
begin
	TextColor(LightGray);
	for i := 0 to sizeX do
	begin
		GotoXY(x + i, y);
		Write('#')
	end;
	for i := 0 to sizeX do
	begin
		GotoXY(x + i, y + SizeY);
		Write('#')
	end;
	for i := 0 to SizeY do
	begin
		GotoXY(x, y + i);
		Write('#')
	end;
	for i := 0 to SizeY do
	begin
		GotoXY(x + sizeX, y + i);
		write('#')
	end
end;

procedure MessageCantOpenFile;
var
	x, y: integer;
	sizeX, sizeY: integer;
	mes: string = 'Couldn''t open the file';
begin
	sizeX := 29;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
	PrintFrame(x, y, sizeX, sizeY);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageCantCreateFile;
var
	x, y: integer;
	sizeX, sizeY: integer;
	mes: string = 'Couldn''t create the file';
begin
	sizeX := 29;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
	PrintFrame(x, y, sizeX, sizeY);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageCantReadFile;
var
	x, y: integer;
	sizeX, sizeY: integer;
	mes: string = 'Couldn''t read to the file';
begin
	sizeX := 35;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
	PrintFrame(x, y, sizeX, sizeY);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageCantWriteFile;
var
	x, y: integer;
	sizeX, sizeY: integer;
	mes: string = 'Couldn''t write to the file';
begin
	sizeX := 36;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
	PrintFrame(x, y, sizeX, sizeY);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageScaleScreen(ScrnWidth, ScrnHeight: integer);
var
	x, y: integer;
	sizeX, sizeY: integer;
	mes1: string = 'The size of this image is ';
	mes2: string = 'The size of your screen workspace is ';
	mes3: string = 'Scale the workspace to the size of the image';
begin
	sizeX := 51;
	sizeY := 8;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - (sizeY div 2);
	PrintFrame(x, y, sizeX, sizeY);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2) - 2, mes1);
	GotoXY(x + 4, y + (sizeY div 2) - 1);
	write(ScrnWidth, 'X', ScrnHeight);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes2);
	GotoXY(x + 4, y + (sizeY div 2) + 1);
	write(ScreenWidth, 'X',	ScreenHeight - 1);
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2) + 2, mes3);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure PrintStartScreen;
var
	cX, cY, dX: integer;
	article: string = 'AsyaDraw is a free simple ASCII graphics editor using Free Pascal';
	tabp: string = 'tab + ';
	bblack: string = 'b - Black';
	ublue: string = 'u - blUe';
	ggren: string = 'g - Green';
	ccyan: string = 'c - Cyan';
	rred: string = 'r - Red';
	mmagen: string = 'm - Magenta';
	obrown: string = 'o - broWn';
	lgray: string = 'l - Lightgray';
	dgray: string = 'd - Darkgray';
	hblue: string = 'h - ligHtblue';
	ngren: string = 'n -lightgreeN';
	acyan: string = 'a - lightcyAn';
	ered: string = 'e - lightrEd';
	tmagen: string = 't - lighTmagenTa';
	yyelow: string = 'y - Yellow';
	wwhite: string = 'w - White';
	control: string = 'Arrows - Move; Any key - Brush; Space - Draw; Backspace - delete';
	vers: string = 'V0.1.2 (2023.04.27)';
	project: string = 'New/Open File: ';
begin
	cX := ScreenWidth div 2;
	cY := ScreenHeight div 2;
	PrintAsyaDrawLogo;
	PrintAnyMes(LightCyan, Black,cX - Length(article) div 2, 8, article);
	dX := -36;
	PrintAnyMes(White, Black, cX + dX, cY + 4, tabp);
	dX := -30;
	PrintAnyMes(Black, LightGray, cX + dX, cY + 4, bblack);
	PrintAnyMes(Blue, Black, cX + dX, cY + 5, ublue);
	PrintAnyMes(Green, Black, cX + dX, cY + 6, ggren);
	PrintAnyMes(Cyan, Black, cX + dX, cY + 7, ccyan);
	dX := -16;
	PrintAnyMes(Red, Black, cX + dX, cY + 4, rred);
	PrintAnyMes(Magenta, Black, cX + dX, cY + 5, mmagen);
	PrintAnyMes(Brown, Black, cX + dX, cY + 6, obrown);
	PrintAnyMes(LightGray, Black, cX + dX, cY + 7, lgray);
	dX := 2;
	PrintAnyMes(DarkGray, Black, cX + dX, cY + 4, dgray);
	PrintAnyMes(LightBlue, Black, cX + dX, cY + 5, hblue);
	PrintAnyMes(LightGreen, Black, cX + dX, cY + 6, ngren);
	PrintAnyMes(LightCyan, Black, cX + dX, cY + 7, acyan);
	dX := 20;
	PrintAnyMes(LightRed, Black, cX + dX, cY + 4, ered);
	PrintAnyMes(LightMagenta, Black, cX + dX, cY + 5, tmagen);
	PrintAnyMes(Yellow, Black, cX + dX, cY + 6, yyelow);
	PrintAnyMes(White, Black, cX + dX, cY + 7, wwhite);
	dX := -33;
	PrintAnyMes(Black, LightGray, cX + dX, cY + 10, control);
	dX := -4;
	PrintAnyMes(White, Black, ScreenWidth - Length(vers) + dX, ScreenHeight, vers);
	dX := -36;
	PrintAnyMes(White, Black, cX + dX, cY, project);
end;

procedure ShowReadString(mes: string; x, y: integer);
var
	s: string = ' ';
	i: integer;
begin
	for i := 0 to Length(mes) do
	begin
		PrintAnyMes(White, Black, x + i, y, s);
	end;
	PrintAnyMes(White, Black, x, y, mes)
end;

procedure PrintFilename(filename: string);
var
	mes: string = ' File: ';
begin
	PrintAnyMes(White, Black, 1, ScreenHeight, mes);
	ShowReadString(filename, 8, ScreenHeight);
end;

procedure IOResultOpenFile;
begin
	if IOResult <> 0 then
	begin
		MessageCantOpenFile;
		halt(1)
	end
end;

procedure IOResultCreateFile;
begin
	if IOResult <> 0 then
	begin
		MessageCantCreateFile;
		halt(1)
	end
end;

procedure IOResultWriteFile;
begin
	if IOResult <> 0 then
	begin
		MessageCantWriteFile;
		halt(1)
	end
end;

procedure IOResultReadFile;
begin
	if IOResult <> 0 then
	begin
		MessageCantReadFile;
		halt(1)
	end
end;

end.

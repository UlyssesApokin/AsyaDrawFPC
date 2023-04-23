program AsyaDraw;
uses crt;

const
	{GetKey code}				{ASCII symbol}
	up = -72;							{up_arrow}
	left = -75;						{left_arrow}
	down = -80;						{down_arrow}
	right = -77;					{right_arrow}
	cexit = 27;						{esc}
	cdraw = 32;						{space}
	cdelete = 8;					{backspace}
	ccolor = 9;						{tab}
	cblack = 98;					{b}
	cblue = 117;					{u}
	cgreen = 103;					{g}
	ccyan = 99;						{c}
	cred = 114;						{r}
	cmagenta = 109;				{m}
	cbrown = 111;					{o}
	clightgray = 108;			{l}
	cdarkgray = 100;			{d}
	clightblue = 104;			{h}
	clightgreen = 110;		{n}
	clightcyan = 97;			{a}
	clightred = 101;			{e}
	clightmagenta = 116;	{t}
	cyellow = 121;				{y}
	cwhite = 119;					{w}

type
	cursor = record
		X, Y, dX, dY: integer;
		DRColor, DRSymbol: integer;
	end;

{A unit of measurement that stores information 
	about a single screen text character}
type
	image = record
		color, symbol: integer;
	end;

type
	ImageArray = array of array of image;

type 
	ImageFile = file of image;

{Handling keyboard input}
procedure GetKey(var code: integer);
var
	c: char;
begin
	c := ReadKey;
	if c = #0 then
	begin
		c := ReadKey;
		code := - ord(c)
	end
	else
	begin
		code := ord(c)
	end
end;

procedure DrawSymbol(var cur: cursor; code: integer);
begin
	if (code >= 33) and (code <= 126) then
	begin
		cur.DRSymbol := code
	end
end;

procedure DrawColor(var cur: cursor; code: integer);
var
	c: integer;
begin
	if code = ccolor then
	begin
		GetKey(c);
		if c = cblack then
			cur.DRColor := Black
		else if c = cblue then
			cur.DRColor := Blue
		else if c = cgreen then
			cur.DRColor := Green
		else if c = ccyan then
			cur.DRColor := Cyan
		else if c = cred then
			cur.DRColor := Red
		else if c = cmagenta then
			cur.DRcolor := Magenta
		else if c = cbrown then
			cur.DRColor := Brown
		else if c = clightgray then
			cur.DRColor := LightGray
		else if c = cdarkgray then
			cur.DRColor := DarkGray
		else if c = clightblue then
			cur.DRColor := LightBlue
		else if c = clightgreen then
			cur.DRColor := LightGreen
		else if c = clightcyan then
			cur.DRColor := LightCyan
		else if c = clightred then
			cur.DRColor := LightRed
		else if c = clightmagenta then
			cur.DRColor := LightMagenta
		else if c = cyellow then
			cur.DRColor := Yellow
		else if c = cwhite then
			cur.DRColor := White
	end;
	TextColor(cur.DRColor)
end;

procedure ShowCursor(var cur: cursor);
begin
	{Symbol preview in the upper left corner}
	GotoXY(10, 1);
	TextColor(cur.DRColor);
	write(chr(cur.DRSymbol));
	GotoXY(cur.X, cur.Y);
end;

procedure CurWithinBorders(var cur: cursor);
begin
	if cur.X > (ScreenWidth) then
		cur.X := ScreenWidth
	else if cur.X < 1 then
		cur.X := 1;
	if cur.Y > (ScreenHeight - 1) then
		cur.Y := ScreenHeight - 1
	else if cur.Y < 2 then
		cur.Y := 2
end;

procedure MoveCursor(var cur: cursor; var code: integer);
begin
	if code = right then
		cur.X := cur.X + cur.dX
	else if code = left then
		cur.X := cur.X - cur.dX
	else if code = down then
		cur.Y := cur.Y + cur.dY
	else if code = up then
		cur.Y := Cur.Y - cur.dY;
	CurWithinBorders(cur);
	ShowCursor(cur)
end;

procedure InitCursor(var cur: cursor);
begin
	cur.X := ScreenWidth div 2;
	cur.Y := ScreenHeight div 2;
	cur.dX := 1;
	cur.dY := 1;
	cur.DRColor := White;
	cur.DRSymbol := 38;
	TextColor(cur.DRColor)
end;

procedure InitScreen(var screen: ImageArray);
var
	coordX, coordY: integer;
begin
	clrscr;
	SetLength(screen, ScreenWidth + 1, ScreenHeight);
	for coordX := 1 to ScreenWidth do
		for coordY := 1 to ScreenHeight - 1 do
		begin
			screen[coordX, coordY].color := White;
			screen[coordX, coordY].symbol := 32
		end
end;

{Change the contents of ImageArray according to user actions}
procedure SynchronizeScreen(var screen: ImageArray; cur: cursor; code: integer);
var
	coordX, coordY: integer;
begin
	coordX := WhereX;
	coordY := WhereY;
	if code = cdraw then
	begin
		screen[coordX, coordY].color := cur.DRColor;
		screen[coordX, coordY].symbol := cur.DRSymbol
	end;
	if code = cdelete then
	begin
		screen[coordX, coordY].color := White;
		screen[coordX, coordY].symbol := 32
	end
end;

{Screen rendering}
procedure FullUpdateScreen(var screen: ImageArray);
var
	coordX, coordY: integer;
begin
	for coordX := 1 to ScreenWidth do
		for coordY := 1 to ScreenHeight - 1 do
		begin
			GotoXY(coordX, coordY);
			TextColor(screen[coordX, coordY].color);
			write(chr(screen[coordX, coordY].symbol))
		end
end;

procedure UpdateScreenUnderCur(var screen: ImageArray; cur: cursor);
begin
	GotoXY(cur.X, cur.Y);
	TextColor(screen[cur.X, cur.Y].color);
	write(chr(screen[cur.X, cur.Y].symbol))
end;

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

procedure MessageCantOpenFile;
var
	i: integer;
	x, y: integer;
	sizeX, sizeY: integer;
	mes: string = 'Couldn''t open the file';
begin
	sizeX := 29;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
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
	end;
	PrintAnyMes(Yellow, Black, x + 4, y + (sizeY div 2), mes);
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageCantReadFile;
var
	i: integer;
	x, y: integer;
	sizeX, sizeY: integer;
begin
	sizeX := 35;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
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
	end;
	TextColor(Yellow);
	GotoXY(x + 4, y + (sizeY div 2));
	write('Couldn''t read to the file');
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure MessageCantWriteFile;
var
	i: integer;
	x, y: integer;
	sizeX, sizeY: integer;
begin
	sizeX := 36;
	sizeY := 6;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
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
	end;
	TextColor(Yellow);
	GotoXY(x + 4, y + (sizeY div 2));
	write('Couldn''t write to the file');
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure IOResultOpenFile;
begin
	if IOResult <> 0 then
	begin
		MessageCantOpenFile;
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

procedure NewFile(var f: ImageFile; filename: string; var screen: ImageArray);
var
	ScrnRes: image;
	coordX, coordY: integer;
	n: integer = 1;
begin
	assign(f, filename);
	rewrite(f);
	IOResultOpenFile;
	{Writing meta information to a file}
	ScrnRes.color := ScreenWidth;
	ScrnRes.symbol := ScreenHeight - 1;
	seek(f, 0);
	write(f, ScrnRes);
	IOResultWriteFile;
	for coordX := 1 to ScreenWidth do
		for coordY := 1 to ScreenHeight - 1 do
		begin
			seek(f, n);
			write(f, screen[coordX, coordY]);
			IOResultWriteFile;
			n := n + 1
		end;
		close(f)
end;

procedure MessageScaleScreen(ScrnRes: image);
var
	i: integer;
	x, y: integer;
	sizeX, sizeY: integer;
begin
	sizeX := 51;
	sizeY := 8;
	x := (ScreenWidth div 2) - (sizeX div 2);
	y := (ScreenHeight div 2) - 1 - (sizeY div 2);
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
	end;
	TextColor(Yellow);
	GotoXY(x + 4, y + (sizeY div 2) - 2);
	write('The size of this image is ');
	GotoXY(x + 4, y + (sizeY div 2) - 1);
	write(ScrnRes.color, 'X', ScrnRes.symbol);
	GotoXY(x + 4, y + (sizeY div 2));
	write('The size of your screen workspace is ');
	GotoXY(x + 4, y + (sizeY div 2) + 1);
	write(ScreenWidth, 'X',	ScreenHeight - 1);
	GotoXY(x + 4, y + (sizeY div 2) + 2);
	write('Scale the workspace to the size of the image');
	PrintAsyaDrawLogo;
	TextColor(White);
	GotoXY(1, ScreenHeight);
end;

procedure OpenFile(var f: ImageFile; filename: string; var screen: ImageArray);
var
	ScrnRes: image;
	coordX, coordY: integer;
	n: integer = 1;
begin
	assign(f, filename);
	reset(f);
	IOResultOpenFile;
	{Reading meta information from a file}
	seek(f, 0);
	read(f,ScrnRes);
	IOResultReadFile;
	if (ScrnRes.color <> ScreenWidth) and (ScrnRes.symbol <> ScreenHeight -1) then
	begin
		MessageScaleScreen(ScrnRes);
		halt(1);
		exit;
	end;
	for coordX := 1 to ScreenWidth do
		for coordY := 1 to ScreenHeight - 1 do
		begin
			seek(f, n);
			read(f, screen[coordX, coordY]);
			IOResultReadFile;
			n := n + 1
		end;
	close(f)
end;

procedure SynchronizeFile(var f: ImageFile; var screen: ImageArray;
																										code: integer);
var
	coordX, coordY: integer;
	n: integer;
begin
	if (code = cdraw) or (code = cdelete) then
	begin
		coordX := WhereX;
		coordY := WhereY;
		n := ((coordX - 1) * (ScreenHeight - 1)) + coordY;
		seek(f, n);
		write(f, screen[CoordX, CoordY]);
		IOResultWriteFile
	end
end;

procedure ReadString(code: integer; var s: string);
var
	c: char;
	i: integer;
begin
	if	{A..z or 0..9 or ./}
	((code >= 65) and (code <= 122)) or
	((code >= 48) and (code <= 57)) or
	((code >= 46) and (code <= 47)) then
	begin
		c := chr(code);
		s := s + c
	end;
	if (code = 8) and (Length(s) >= 1)	then {backspace}
	begin
		s[Length(s)] := #0;
		i := ord(s[0]) - 1;
		s[0] := chr(i)
	end
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

procedure GetFilename(s: string; var filename: string);
begin
	filename := s;
end;

function FileIsExist(var f: ImageFile; name: string): boolean;
begin
	assign(f, name);
	filemode := 0;
	reset(f);
	if IOResult = 0 then
		FileIsExist := true
	else
		FileIsExist := false;
	filemode := 2;
end;

procedure InitFile(var f: ImageFile; name: string; scrn: ImageArray );
begin
	if FileIsExist(f, name) then
		OpenFile(f, name, scrn)
	else
		NewFile(f, name, scrn)
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
	vers: string = 'V0.1.1 (2023.04.23)';
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

procedure PrintFilename(filename: string);
begin
	GotoXY(1, ScreenHeight);
	Write( ' File: ');
	ShowReadString(filename, 8, ScreenHeight);
end;

var
	code: integer;
	cur: cursor;
	screen: ImageArray;
	AsyaDrawFile: ImageFile;
	filename, enter: string;
BEGIN
	InitCursor(cur);
	InitScreen(screen);
	PrintStartScreen;
	repeat
		GetKey(code);
		ReadString(code, enter);
		ShowReadString(enter,ScreenWidth div 2 - 21 , ScreenHeight div 2);
		GetFilename(enter, filename);
		if code = cexit then
		begin
			clrscr;
			halt(1);
		end;
	until code = 13;
	clrscr;
	PrintFilename(filename);
	InitFile(AsyaDrawFile, filename, screen);
	assign(AsyaDrawFile, filename);
	reset(AsyaDrawFile);
	IOResultOpenFile;
	FullUpdateScreen(screen);
	TextColor(White);
	PrintInfo;
	repeat
		GetKey(code);
		DrawColor(cur, code);
		DrawSymbol(cur, code);
		PrintInfo;
		UpdateScreenUnderCur(screen, cur);
		MoveCursor(cur, code);
		SynchronizeScreen(screen, cur, code);
		SynchronizeFile(AsyaDrawFile, screen, code);
	until code = cexit;
	close(AsyaDrawFile);
	InitScreen(screen)
END.

program AsyaDraw;
uses crt, adgui;

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
    else if c = ccolor then
    begin
      if cur.DRColor < 15 then
        cur.DRColor := cur.DRColor + 1
      else
        cur.DRColor := 1
    end
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
procedure SyncScreen(var screen: ImageArray; cur: cursor; code: integer);
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

{$I-}

procedure NewFile(var f: ImageFile; filename: string;
															var screen: ImageArray);
var
	ScrnRes: image;
	coordX, coordY: integer;
	n: integer = 1;
begin
	assign(f, filename);
	rewrite(f);
	IOResultCreateFile;
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

procedure OpenFile(var f: ImageFile; filename: string;
															var screen: ImageArray);
var
	ScrnRes: image;
	coordX, coordY: integer;
	n: integer = 1;
  x, y: integer;
begin
	assign(f, filename);
	reset(f);
	IOResultOpenFile;
	{Reading meta information from a file}
	seek(f, 0);
	read(f,ScrnRes);
	IOResultReadFile;
	if (ScrnRes.color <> ScreenWidth) 
	and (ScrnRes.symbol <> ScreenHeight -1) then
	begin
    x := ScrnRes.color;
    y := ScrnRes.symbol;
		MessageScaleScreen(x, y);
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

procedure SyncFile(var f: ImageFile; var screen: ImageArray;
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
	filemode := 2
end;

procedure InitFile(var f: ImageFile; name: string; scrn: ImageArray);
begin
	if FileIsExist(f, name) then
		OpenFile(f, name, scrn)
	else
		NewFile(f, name, scrn)
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
    if enter = '/about' then
    begin
      clrscr;
      PrintAboutPage;
      GetKey(code);
      clrscr;
      PrintStartScreen;
      code := 0;
      enter := ''
    end;
		if code = cexit then
		begin
			clrscr;
			halt(1);
		end;
	until code = 13;
	clrscr;
  GetFilename(enter, filename);
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
		SyncScreen(screen, cur, code);
		SyncFile(AsyaDrawFile, screen, code);
	until code = cexit;
	close(AsyaDrawFile);
	InitScreen(screen)
END.

program Cp852Decoder;
{$APPTYPE CONSOLE}

uses
   SysUtils;

resourcestring
   SCannotConvert = 'Unicode code point $%x has no equivalent in %s';

type
   AnsiCharHighMap = array[$80..$FF] of WideChar;

{ Numery unicode gornej polowki kodowania Cp852 }
const
  CP852Map : AnsiCharHighMap = (
      #$00C7, #$00FC, #$00E9, #$00E2, #$00E4, #$016F, #$0107, #$00E7,
      #$0142, #$00EB, #$0150, #$0151, #$00EE, #$0179, #$00C4, #$0106,
      #$00C9, #$0139, #$013A, #$00F4, #$00F6, #$013D, #$013E, #$015A,
      #$015B, #$00D6, #$00DC, #$0164, #$0165, #$0141, #$00D7, #$010D,
      #$00E1, #$00ED, #$00F3, #$00FA, #$0104, #$0105, #$017D, #$017E,
      #$0118, #$0119, #$00AC, #$017A, #$010C, #$015F, #$00AB, #$00BB,
      #$2591, #$2592, #$2593, #$2502, #$2524, #$00C1, #$00C2, #$011A,
      #$015E, #$2563, #$2551, #$2557, #$255D, #$017B, #$017C, #$2510,
      #$2514, #$2534, #$252C, #$251C, #$2500, #$253C, #$0102, #$0103,
      #$255A, #$2554, #$2569, #$2566, #$2560, #$2550, #$256C, #$00A4,
      #$0111, #$0110, #$010E, #$00CB, #$010F, #$0147, #$00CD, #$00CE,
      #$011B, #$2518, #$250C, #$2588, #$2584, #$0162, #$016E, #$2580,
      #$00D3, #$00DF, #$00D4, #$0143, #$0144, #$0148, #$0160, #$0161,
      #$0154, #$00DA, #$0155, #$0170, #$00FD, #$00DD, #$0163, #$00B4,
      #$00AD, #$02DD, #$02DB, #$02C7, #$02D8, #$00A7, #$00F7, #$00B8,
      #$00B0, #$00A8, #$02D9, #$0171, #$0158, #$0159, #$25A0, #$00A0);

function CharFromHighMap(const Ch: WideChar; const Map: AnsiCharHighMap;
    const Encoding: string): AnsiChar;
var I : Byte;
    P : PWideChar;
begin
  if Ord(Ch) < $80 then
    begin
      Result := AnsiChar(Ch);
      Exit;
    end;
  if Ch = #$FFFF then
    raise EConvertError.CreateFmt(SCannotConvert, [Ord(Ch), Encoding]);
  P := @Map;
  for I := $80 to $FF do
    if P^ <> Ch then
      Inc(P)
    else
      begin
        Result := AnsiChar(I);
        Exit;
      end;
  raise EConvertError.CreateFmt(SCannotConvert, [Ord(Ch), Encoding]);
end;

{ Przyjmuje znak w kodzie cp852 i zwaraca jego kod w utf-16 }
function CP852DecodeChar(const P: AnsiChar) : WideChar;
begin
  if Ord(P) < $80 then
    Result := WideChar(P)
  else
    Result := CP852Map[Ord(P)];
end;

{ Przyjmuje znak utf-16 i zwaraca kod znaku w cp852 }
function CP852EncodeChar(const Ch: WideChar) : AnsiChar;
begin
  Result := CharFromHighMap(Ch, CP852Map, 'IBM852');
end;

{ Przyjmuje string w utf-16 i zwraca w kodowaniu cp852 }
function CP852Encode(WStr: WideString) : AnsiString;
var
   i : Integer;
begin
   SetLength(Result, Length(WStr));
   for i := 1 to Length(WStr) do
      Result[i] := CP852EncodeChar(WStr[i]);
end;

{ Przyjmuje string w cp852 i zwraca w kodowaniu utf-16 }
function CP852Decode(Str: AnsiString) : WideString;
var
   i : Integer;
begin
   SetLength(Result, Length(Str));
   for i := 1 to Length(Str) do
      Result[i] := CP852DecodeChar(Str[i]);
end;                      

{
procedure Quit;
begin
   WriteLn('Wyjscie z programu! Nacisnij dowolny klawisz aby zakonczyc!');
   ReadLn;
end;

procedure WriteChars(Str: AnsiString);
var
   i : Integer;
begin
   for i := 1 to Length(Str) do
      WriteLn(i, ': ', Str[i]);
end;
}

procedure Main;
var
   TestStr : AnsiString;
begin
   ReadLn(TestStr);
   //WriteLn('Before:');
   //WriteChars(TestStr);
   //WriteLn(TestStr);
   //WriteLn('After:');
   //WriteChars(TestStr);

   { Wyslij na wyjscie jako AnsiString w kodowaniu utf-8 }
   WriteLn(Utf8Encode(CP852Decode(TestStr)));
   //Quit;
end;

begin
   Main;
end.


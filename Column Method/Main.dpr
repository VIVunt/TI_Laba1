program Main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GeneralCryptography in '..\GeneralCryptography.pas';

type
  TCell = record
    number: integer;
    c: char;
  end;
  TKey = array of TCell;
  TMatrix = array of array of char;

var
  PlainText, CipherText: string;
  Key: TKey;
  max, min: integer;
  ExitFlag: boolean;
  switch: integer;

procedure ToPrintMatrix(var Matrix: TMatrix);
var i, j: integer;
begin

  for i := Low(Matrix) to High(Matrix) do
  begin
    for j := Low(Matrix[i]) to High(Matrix[i]) do
    begin
      write(Matrix[i,j]+'  ');
    end;
    writeln;
    writeln;
  end;

end;

function GenerateKey(min, max: integer): TKey;
var i, k: integer;
    Str: string;
    Key: TKey;
    c: char;
begin

//  ????????? ?????
  Str := GenerateStringKey(min, max);
  SetLength(Key, Length(Str));
  for i := Low(Str) to High(Str) do
  begin
    Key[i-1].c := Str[i];
    Key[i-1].number := -1;
  end;

//  ????????? ?????
  k := 1;
  for c := 'a' to 'z' do
    for i := Low(Key) to High(Key) do
    begin
      if Key[i].number = -1 then
      begin
        if Key[i].c = c then
        begin
          Key[i].number := k;
          inc(k);
        end;
      end;
    end;

  result := Key;

end;

procedure PrintKeyString(var Key: TKey);
var i: integer;
begin

  for i := Low(Key) to High(Key) do
  begin
    write(Key[i].c);
  end;
  writeln;

end;

procedure PrintKeyNumbers(var Key: TKey);
var i: integer;
begin

  for i := Low(Key) to High(Key) do
  begin
    write(Key[i].number);
  end;
  writeln;

end;

function Encipher(var PlainText: string; Key: TKey): string;
var i, j, l, n: integer;
    CipherText: string;
    Matrix: TMatrix;
begin

//  ????????? ???????
  i := Length(PlainText) div Length(Key);
  j := Length(PlainText) mod Length(Key);
  if j > 0 then inc(i);

  SetLength(CipherText, i*Length(Key));

  SetLength(Matrix, i, Length(Key));

//  ?????????? ???????
  l := Low(PlainText);
  for i := Low(Matrix) to High(Matrix) do
    for j := Low(Matrix[i]) to High(Matrix[i])  do
    begin
      if l <= Length(PlainText) then
      begin
        Matrix[i,j] := PlainText[l];
        inc(l);
      end
      else
      begin
        Matrix[i,j] := ' ';
      end;
    end;

//  ?????????? ??????
  l := Low(CipherText);
  for j := 1 to Length(Key) do
    for i := Low(Key) to High(Key) do
    begin
      if j = Key[i].number then
      begin
        for n := Low(Matrix) to High(Matrix) do
        begin
          CipherText[l] := Matrix[n,i];
          inc(l);
        end;
      end;
    end;

  result := CipherText;

end;

function Decipher(var CipherText: string; Key: TKey): string;
var i, j, l, n: integer;
    PlainText: string;
    Matrix: TMatrix;
begin

//  ????????? ???????
  i := Length(CipherText) div Length(Key);

  SetLength(PlainText, i*Length(Key));

  SetLength(Matrix, i, Length(Key));


//  ?????????? ???????
  l := High(CipherText);
  for j := Length(Key) downto 1 do
    for i := High(Key) downto Low(Key) do
    begin
      if j = Key[i].number then
      begin
        for n := High(Matrix) downto Low(Matrix) do
        begin
          Matrix[n,i] := CipherText[l];
          dec(l);
        end;
      end;
    end;

//  ??????????? ???????????
  l := Low(PlainText);
  for i := Low(Matrix) to High(Matrix) do
    for j := Low(Matrix[i]) to High(Matrix[i])  do
    begin
      PlainText[l] := Matrix[i,j];
      inc(l);
    end;

  result := PlainText;

end;

begin
  min := 5;
  max := 10;

  SetLength(PlainText, 0);
  SetLength(CipherText, 0);
  Key := nil;

  ExitFlag := false;

  while not(ExitFlag) do
  begin
    writeln('1. Type plain text');
    writeln('2. Encrypt key');
    writeln('3. Decrypt key');
    writeln('4. Output data');
    writeln('0. Exit');
    writeln;

    readln(switch);
    writeln;

    case switch of

      1: begin

           Key := GenerateKey(min, max);
           SetLength(CipherText, 0);
           write('Text: ');readln(PlainText);
           writeln;

         end;

      2: begin

           if (Length(PlainText) = 0) or (Key = nil) then writeln('Encryption failed')
           else
           begin
             CipherText := Encipher(PlainText, Key);
             writeln('Encryption was successful');
           end;
           writeln;

         end;

      3: begin

           if (Length(CipherText) = 0) or (Key = nil) then writeln('Decryption failed')
           else
           begin
             PlainText := Decipher(CipherText, Key);
             writeln('Decryption was successful');
           end;
           writeln;

         end;

      4: begin

           if (Length(PlainText) = 0) or (Length(CipherText) = 0) or (Key = nil) then
           begin
             writeln('You entered the data incorrectly');
             writeln;
           end
           else
           begin
             write('Plain text:  '); writeln(PlainText);  writeln;
             write('Key:         '); PrintKeyString(Key);
             write('             '); PrintKeyNumbers(Key); writeln;
             write('Cipher text: '); writeln(CipherText); writeln
           end;

         end;

      0: begin

          ExitFlag := true;

         end;

    else begin

           writeln('You entered an invalid choice');
           writeln;

         end;

    end;

  end;

end.

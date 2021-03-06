program Main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GeneralCryptography in '..\GeneralCryptography.pas';

type
  TMatrix = array['a'..'z', 'a'..'z'] of char;

var PlainText, CipherText, Key: string;
    Matrix: TMatrix;
    max, min: integer;
    ExitFlag: boolean;
    switch: integer;

function ToExpandKey(var Key:string; n:integer): string;
var Prev, Curr:integer;
begin
  result := Key;

  Curr := Length(result) + 1;
  Prev := 1;

  SetLength(result, n);

  while Curr <= Length(result) do
  begin
    result[Curr] := Chr((Ord(result[Prev]) - Ord('a') + 1) mod (Ord('z') - Ord('a') + 1) + Ord('a'));

    inc(Prev);
    inc(Curr);
  end;

end;

procedure ToFillMatrix(var Matrix: TMatrix);
var i, j, c: char;
begin

  for i := Low(Matrix) to High(Matrix) do
  begin
    c := i;
    for j := Low(Matrix[i]) to High(Matrix[i]) do
    begin
      Matrix[i,j] := c;
      c := Chr((Ord(c) - Ord('a') + 1) mod (Ord('z') - Ord('a') + 1) + Ord('a'));
    end;
  end;

end;

procedure ToPrintMatrix(var Matrix: TMatrix);
var i, j: char;
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

function Encipher(var Plaintext, Key: string; var Matrix: TMatrix): string;
var i:integer;
    CipherText, ExKey: string;
begin
  ExKey := ToExpandKey(Key, Length(PlainText));

  SetLength(CipherText, Length(Plaintext));

  for i := Low(Plaintext) to High(Plaintext) do
  begin

    if (Ord(PlainText[i]) >= Ord('a')) and (Ord(PlainText[i]) <= Ord('z')) then
    begin
      CipherText[i] := Matrix[ExKey[i], PlainText[i]];
    end
    else
    begin
      CipherText[i] := PlainText[i];
    end;

  end;

  result := CipherText;

end;

function Decipher(var CipherText, Key: string; var TMatrix: TMatrix): string;
var i:integer;
    c:char;
    PlainText, ExKey: string;
begin
  ExKey := ToExpandKey(Key, Length(CipherText));

  SetLength(PlainText, Length(CipherText));

  for i := Low(ExKey) to High(ExKey) do
  begin

    if (Ord(CipherText[i]) >= Ord('a')) and (Ord(CipherText[i]) <= Ord('z')) then
    begin
      for c := Low(Matrix[ExKey[i]]) to High(Matrix[ExKey[i]]) do
      begin
        if CipherText[i] = Matrix[ExKey[i],c] then
        begin
          PlainText[i] := c;
        end;
      end;
    end
    else
    begin
      PlainText[i] := CipherText[i];
    end;
  end;

  result := PlainText;

end;

begin
  min := 5;
  max := 10;

  SetLength(PlainText, 0);
  SetLength(CipherText, 0);
  SetLength(Key, 0);
  ToFillMatrix(Matrix);

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

           Key := GenerateStringKey(min, max);
           SetLength(CipherText, 0);
           write('Text: ');readln(PlainText);
           PlainText := LowerCase(PlainText);
           writeln;

         end;

      2: begin

           if (Length(PlainText) = 0) or (Length(Key) = 0) then writeln('Encryption failed')
           else
           begin
             CipherText := Encipher(PlainText, Key, Matrix);
             writeln('Encryption was successful');
           end;
           writeln;

         end;

      3: begin

           if (Length(CipherText) = 0) or (Length(Key) = 0) then writeln('Decryption failed')
           else
           begin
             PlainText := Decipher(CipherText, Key, Matrix);
             writeln('Decryption was successful');
           end;
           writeln;

         end;

      4: begin

           if (Length(PlainText) = 0) or (Length(CipherText) = 0) or (Length(Key) = 0) then
           begin
             writeln('You entered the data incorrectly');
             writeln;
           end
           else
           begin
             write('Plain text:  '); writeln(PlainText);  writeln;
             write('Key:         '); writeln(Key); writeln;
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

unit GeneralCryptography;

interface

type
  TDynamicMas = array of integer;

procedure MixMas(var Mas: TDynamicMas);

function GenerateMas(min, max: integer): TDynamicMas;

procedure PrintMas(var Mas: TDynamicMas);

function GenerateStringKey(min, max: integer): string;

implementation

procedure MixMas(var Mas: TDynamicMas);
var i, n, nSqr: integer;
    ind1, ind2: integer;
    temp: integer;
begin

  randomize;

  n := Length(Mas);
  nSqr := n * n;

  for i := 1 to nSqr do
  begin
    ind1 := random(n);
    ind2 := random(n);
    temp := Mas[ind1];
    Mas[ind1] := Mas[ind2];
    Mas[ind2] := temp;
  end;
end;

function GenerateMas(min, max: integer): TDynamicMas;
var n, i: integer;
    Mas: TDynamicMas;
begin
  randomize;
  n := random(max - min + 1) + min;
  SetLength(Mas, n);

  for i := Low(Mas) to High(Mas) do
  begin
    Mas[i] := i + 1;
  end;

  MixMas(Mas);

  result := Mas;
end;

procedure PrintMas(var Mas: TDynamicMas);
var i: integer;
begin

  for i := Low(Mas) to High(Mas) do
  begin
    write(Mas[i],'  ');
  end;
  writeln;
  writeln;

end;

function GenerateStringKey(min, max: integer): string;
var n, i: integer;
    Key: string;
    c:char;
begin
  randomize;
  n := random(max - min + 1) + min;
  SetLength(Key, n);

  for i := Low(Key) to High(Key) do
  begin
    Key[i] := Chr(random(Ord('z') - Ord('a') + 1) + Ord('a'));
  end;

  result := Key;
end;

end.

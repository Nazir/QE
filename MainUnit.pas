unit MainUnit;

{$mode objfpc}{$H+}

{******************************************************************************}
{                                                                              }
{  Unit: Main window                                                           }
{  Модуль: Главное окно программы                                              }
{  Copyright: Nazir © 2002-2017                                                }
{  Development: Nazir K. Khusnutdinov (aka Naziron or Wild Pointer)            }
{  Разработчик: Хуснутдинов Назир Каримович  (Naziron or Wild Pointer)         }
{                                                                              }
{  Email: Nazir@Nazir.pro                                                      }
{  Website: http://Nazir.pro                                                   }
{                                                                              }
{  Email: naziron@gmail.com                                                    }
{  Git: https://github.com/Nazir                                               }
{                                                                              }
{  Created: 21.05.2004 [Delphi]                                                }
{  Modified: 17.12.2007, 15.01.2008, 25.01.2008, 08.04.2008, 08.03.2009        }
{  Modified: 23.05.2009, 06.06.2009                                            }
{  Created: 09.07.2017 [Lazarus (Free Pascal)]                                 }
{                                                                              }
{******************************************************************************}

interface

uses
  Forms, Windows, SysUtils, Graphics,
  ExtCtrls, StdCtrls, Buttons, Controls, Classes, Dialogs,
  gettext, translations,
  LCLTranslator, LCLType;

type

  { TMainForm }

  TMainForm = class(TForm)
    gbEnterFactors: TGroupBox;
    ed_a: TLabeledEdit;
    ed_b: TLabeledEdit;
    ed_c: TLabeledEdit;
    ed_D: TLabeledEdit;
    gb_f: TGroupBox;
    ed_f: TEdit;
    gbDecisionInfo: TGroupBox;
    lbDecisionInfo: TLabel;
    gbDecision: TGroupBox;
    ed_x1: TLabeledEdit;
    ed_x2: TLabeledEdit;
    sbAbout: TSpeedButton;
    lblCalculateInfo: TLabel;
    sbCalculate: TSpeedButton;
    procedure sbCalculateClick(Sender: TObject);
    procedure FactorKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure sbAboutClick(Sender: TObject);
    procedure FactorEnter(Sender: TObject);
    procedure SetFunctionView;
    procedure FactorChange(Sender: TObject);
  private
  public
    procedure Decision;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.Decision;
// Решение
var
  a,b,c,           // Коэфициенты уравнения
  D,               // Дискреминант
  X1,X2: Extended; // Искомые неизвестные
begin
  X1 := 0;
  X2 := 0;
  ed_x1.Text := 'Нет корня';
  ed_x2.Text := 'Нет корня';
  SetFunctionView;
  a := StrToFloatDef(ed_a.Text, 0);
  b := StrToFloatDef(ed_b.Text, 0);
  c := StrToFloatDef(ed_c.Text, 0);
  D := Sqr(b) - 4*a*c;
  ed_D.Text := FloatToStr(D);
  if D >= 0 then
  begin
    lbDecisionInfo.Font.Color := clNavy;
    lbDecisionInfo.Caption := 'Ошибок нет!';
    if a <> 0 then
    begin
      X1 := (-b + Sqrt(D))/(2*a);
      X2 := (-b - Sqrt(D))/(2*a);
      ed_x1.Text := FloatToStr(X1);
    end
    else
      if b <> 0 then
      begin
        X1 := (-c)/(b);
        ed_x1.Text := FloatToStr(X1);
      end
      else
        if c = 0 then
          ed_x1.Text := '0';

    if (D <> 0) and (a <> 0) then
      ed_x2.Text := FloatToStr(X2);
  end
  else
  begin
    lbDecisionInfo.Font.Color := clRed;
    lbDecisionInfo.Caption := 'Дискрименант меньше нуля!'
  end;
end;

procedure TMainForm.sbCalculateClick(Sender: TObject);
begin
  Decision;
end;

procedure TMainForm.FactorKeyPress(Sender: TObject; var Key: Char);
var
  KeySet: set of Char;
begin
  KeySet := ['.', ','];

  if Key in KeySet then
    Key := DefaultFormatSettings.DecimalSeparator;

  KeySet := ['0'..'9', #8, #13, DefaultFormatSettings.DecimalSeparator];

  if Key = #13 then
  begin
    if TLabeledEdit(Sender).Text = '-' then
      TLabeledEdit(Sender).Text := '0';
    Decision;
    Exit;
  end;

  if Key = '-' then
  begin
    if (Pos('-', TLabeledEdit(Sender).Text) = 0)
      and (TLabeledEdit(Sender).SelStart = 0) then
      KeySet := KeySet + ['-'];
  end;

  {if Key = '0' then
  begin
    if (Pos('0', TLabeledEdit(Sender).Text) <> 1)
      and (TLabeledEdit(Sender).SelStart <> 0) then
      KeySet := KeySet + ['0'];
  end; //}


  if not (Key in KeySet) then
  begin
    Key := #0;
    MessageBeep(mb_IconAsterisk);
  end;
end;

procedure TMainForm.FactorEnter(Sender: TObject);
begin
  TLabeledEdit(Sender).SelectAll;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Decision;
end;

procedure TMainForm.sbAboutClick(Sender: TObject);
var
  sAbout: string;
  AboutForm: TForm;
//  Msg: LPMSGBOXPARAMS;
begin
  sAbout := 'Квадратное уравнение 2.0 (09.07.2017)'#13 +
            'Статус: Freeware'#13 +
            'Разработчик: Хуснутдинов Назир Каримович'#13 +
            'Nazir © 2002-2017'#13 +
            'Website: http://Nazir.pro'#13 +
            'Git: https://github.com/Nazir';


  AboutForm := CreateMessageDialog(sAbout, mtInformation, [mbOK]);
  AboutForm.Icon.Assign(Application.Icon);
  with AboutForm do
  begin
    Caption := 'О программе...';
    Position := poOwnerFormCenter;
    AboutForm.ShowModal;
  end;
end;

procedure TMainForm.SetFunctionView;
// Уравнение имеет вид
var
  quad, multiply: string;
  s_a, s_b, s_c: string;
  e_a, e_b, e_c: Extended;
begin
  //quad := '^2';
  quad := '²'; //Номер в Юникоде: U+00B2
  //multiply := '*';
  multiply := '•';

  e_a := StrToFloatDef(ed_a.Text, 0);
  e_b := StrToFloatDef(ed_b.Text, 0);
  e_c := StrToFloatDef(ed_c.Text, 0);
  s_a := FloatToStr(e_a);
  s_b := FloatToStr(e_b);
  s_c := FloatToStr(e_c);
  //ed_f.Font.Charset := TURKISH_CHARSET;
  if (e_a = 0) and (e_b = 0) and (e_c = 0) then
  begin
    ed_f.Text := 'a' + multiply + 'x' + quad + ' + b' + multiply + 'x + c = 0';
    Exit;
  end;

  if e_a = 0 then
    ed_f.Text := ''
  else
    ed_f.Text := s_a + multiply + 'x' + quad;

  if e_b >= 0 then
  begin
    if e_b = 0 then
      ed_f.Text := ed_f.Text
    else
    begin
      if e_a = 0 then
        ed_f.Text := ed_f.Text + s_b + multiply + 'x'
      else
        ed_f.Text := ed_f.Text + ' + ' + s_b + multiply + 'x';
    end;
  end
  else
  begin
    if e_a = 0 then
      ed_f.Text := ed_f.Text + '-' + Copy(s_b, 2, Length(s_b)) + multiply + 'x'
    else
      ed_f.Text := ed_f.Text + ' - ' + Copy(s_b, 2, Length(s_b)) + multiply + 'x';
  end;

  if e_c >= 0 then
  begin
    if e_c = 0 then
      ed_f.Text := ed_f.Text + ' = 0'
    else
    begin
      if (e_a = 0) and (e_b = 0) then
        ed_f.Text := ed_f.Text + s_c + ' = 0'
      else
        ed_f.Text := ed_f.Text + ' + ' + s_c + ' = 0'
    end;
  end
  else
  begin
    if (e_a = 0) and (e_b = 0) then
      ed_f.Text := ed_f.Text +  '-' + Copy(s_c, 2, Length(s_c)) + ' = 0'
    else
      ed_f.Text := ed_f.Text +  ' - ' + Copy(s_c, 2, Length(s_c)) + ' = 0';
  end;
end;

procedure TMainForm.FactorChange(Sender: TObject);
begin
  if Trim(TLabeledEdit(Sender).Text) = EmptyStr then
  begin
    TLabeledEdit(Sender).Text := '0';
    TLabeledEdit(Sender).SelectAll;
  end;
  SetFunctionView;
end;

end.

program QuadraticEquation;

{$mode objfpc}{$H+}

{******************************************************************************}
{                                                                              }
{  Project: QuadraticEquation (Quadratic equation)                             }
{  Проект: QuadraticEquation (Квадратное уравнение)                            }
{                                                                              }
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
{  Created: 21.05.2004 [Delphi]  gi                                              }
{  Modified: 17.12.2007, 15.01.2008, 23.05.2009                                }
{  Created: 09.07.2017 [Lazarus (Free Pascal)]                                 }
{                                                                              }
{******************************************************************************}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm}
  {  can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

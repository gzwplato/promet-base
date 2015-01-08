{*******************************************************************************
  Copyright (C) Christian Ulrich info@cu-tec.de

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or commercial alternative
  contact us for more information

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
Created 01.06.2006
*******************************************************************************}
unit uBaseApplication;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, CustApp, eventLog
  {$IFDEF LCL}
  ,PropertyStorage
  {$ENDIF}
  ;
type
  TBaseApplicationClass = class of TCustomApplication;

  { IBaseApplication }
  IBaseApplication = interface['{F8CB41DF-69F1-40C2-ADAA-C8BDCCB28CDD}']
    function GetAppName: string;
    function GetApprevision: Integer;
    function GetAppVersion: real;
    function GetOurConfigDir : string;
    function GetLog: TEventLog;
    function GetSingleInstance : Boolean;
    function GetLanguage: string;
    function GetMessageManager : TThread;
    procedure SetAppname(AValue: string);
    procedure SetAppRevision(AValue: Integer);
    procedure SetAppVersion(AValue: real);
    procedure SetLanguage(const AValue: string);
    procedure SetConfigName(aName : string);
    procedure RestoreConfig;
    procedure SaveConfig;
    function Login : Boolean;
    function ChangePasswort : Boolean;
    procedure Logout;
    procedure Log(aType : string;aMsg : string);
    procedure Log(aMsg : string);
    procedure Info(aMsg : string);
    function GetQuickHelp: Boolean;
    procedure SetQuickhelp(AValue: Boolean);
    procedure Warning(aMsg : string);
    procedure Error(aMsg : string);
    procedure Debug(aMsg : string);
    procedure DoExit;
    property Language : string read GetLanguage write SetLanguage;
    property SingleInstance : Boolean read GetSingleInstance;
    property Appname : string read GetAppName write SetAppname;
    property AppVersion : real read GetAppVersion write SetAppVersion;
    property AppRevision : Integer read GetApprevision write SetAppRevision;
    property EventLog : TEventLog read GetLog;
    property QuickHelp : Boolean read GetQuickHelp write SetQuickhelp;
    function GetInternalTempDir : string;
  end;
var
  TBaseApplicationType : TBaseApplicationClass;
  BaseApplication : TCustomApplication;
implementation
initialization
  BaseApplication := nil;
end.

unit Services_Cliente;

interface

uses
  System.SysUtils, System.Classes, Providers_Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections;

type
  TServicesCliente = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisastatus: TSmallintField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrostatus: TSmallintField;
  private
    { Private declarations }
  public
    { Public declarations }
    function ListAll(const AParams: TDictionary<string, string>) : TFDQuery; override;
  end;

var
  ServicesCliente: TServicesCliente;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicesCliente }

function TServicesCliente.ListAll(const AParams: TDictionary<string, string>): TFDQuery;
begin
  if AParams.ContainsKey('id') then
  begin
    qryPesquisa.SQL.Add('and id = :pid');
    qryPesquisa.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;

    qryRecordCount.SQL.Add('and id = :pid');
    qryRecordCount.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;
  end;

  if AParams.ContainsKey('nome') then
  begin
    qryPesquisa.SQL.Add('and lower(nome) like :pnome');
    qryPesquisa.ParamByName('pnome').AsString := '%'+AParams.Items['nome'].ToLower + '%';

    qryRecordCount.SQL.Add('and lower(nome) like :pnome');
    qryRecordCount.ParamByName('pnome').AsString := '%'+AParams.Items['nome'].ToLower + '%';
  end;

  if AParams.ContainsKey('status') then
  begin
    qryPesquisa.SQL.Add('and status = :pstatus');
    qryPesquisa.ParamByName('pstatus').AsSmallInt := AParams.Items['status'].ToInteger;

    qryRecordCount.SQL.Add('and status = :pstatus');
    qryRecordCount.ParamByName('pstatus').AsSmallInt := AParams.Items['status'].ToInteger;
  end;
  qryPesquisa.SQL.Add('order by id');

  Result := inherited ListAll(AParams);
end;

end.


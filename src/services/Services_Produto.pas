unit Services_Produto;

interface

uses
  System.SysUtils, System.Classes, Providers_Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.VCLUI.Wait,
  System.Generics.Collections;

type
  TServicesProduto = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisavalor: TFMTBCDField;
    qryPesquisastatus: TSmallintField;
    qryPesquisaestoque: TFMTBCDField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrovalor: TFMTBCDField;
    qryCadastrostatus: TSmallintField;
    qryCadastroestoque: TFMTBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
    function ListAll(const AParams: TDictionary<string, string>) : TFDQuery; override;
  end;

var
  ServicesProduto: TServicesProduto;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicesProduto }

function TServicesProduto.ListAll(
  const AParams: TDictionary<string, string>): TFDQuery;
begin
  if AParams.ContainsKey('id') then
  begin
    qryPesquisa.sql.Add('and id = :pid');
    qryPesquisa.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;

    qryRecordCount.sql.Add('and id = :pid');
    qryRecordCount.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;
  end;

  if AParams.ContainsKey('nome') then
  begin
    qryPesquisa.SQL.Add('and lower(nome) like :pnome');
    qryPesquisa.ParamByName('pnome').AsString := '%' + AParams.Items['nome'].ToLower + '%';

    qryRecordCount.SQL.Add('and lower(nome) like :pnome');
    qryRecordCount.ParamByName('pnome').AsString := '%' + AParams.Items['nome'].ToLower + '%';
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




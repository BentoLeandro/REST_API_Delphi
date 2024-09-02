unit Services_Pedido;

interface

uses
  System.SysUtils, System.Classes, Providers_Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections;

type
  TServicesPedido = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisaid_cliente: TLargeintField;
    qryPesquisaid_usuario: TLargeintField;
    qryPesquisadata: TSQLTimeStampField;
    qryCadastroid: TLargeintField;
    qryCadastroid_cliente: TLargeintField;
    qryCadastroid_usuario: TLargeintField;
    qryCadastrodata: TSQLTimeStampField;
    qryPesquisanome_cliente: TWideStringField;
    qryCadastronome_cliente: TWideStringField;
    procedure qryCadastroAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetById(const AId: string) : TFDQuery; override;
    function ListAll(const AParams: TDictionary<string, string>) : TFDQuery; override;
  end;

var
  ServicesPedido: TServicesPedido;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicesPedido }

function TServicesPedido.GetById(const AId: string): TFDQuery;
begin
  qryCadastro.SQL.Add('where p.id = :id');
  qryCadastro.ParamByName('id').AsLargeInt := AId.ToInt64;
  qryCadastro.Open();
  Result := qryCadastro;
end;

function TServicesPedido.ListAll(const AParams: TDictionary<string, string>): TFDQuery;
begin
  if AParams.ContainsKey('id') then
  begin
    qryPesquisa.SQL.Add('and p.id = :pid');
    qryPesquisa.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;

    qryRecordCount.SQL.Add('and p.id = :pid');
    qryRecordCount.ParamByName('pid').AsLargeInt := AParams.Items['id'].ToInt64;
  end;

  if AParams.ContainsKey('idCliente') then
  begin
    qryPesquisa.SQL.Add('and p.id_cliente = :pidCliente');
    qryPesquisa.ParamByName('pidCliente').AsLargeInt := AParams.Items['idCliente'].ToInt64;

    qryRecordCount.SQL.Add('and p.id_cliente = :pidCliente');
    qryRecordCount.ParamByName('pidCliente').AsLargeInt := AParams.Items['idCliente'].ToInt64;
  end;

  if AParams.ContainsKey('nomeCliente') then
  begin
    qryPesquisa.SQL.Add('and lower(c.nome) like :pnomeCliente');
    qryPesquisa.ParamByName('pnomeCliente').AsString := '%' + AParams.Items['nomeCliente'].ToLower + '%';

    qryRecordCount.SQL.Add('and lower(c.nome) like :pnomeCliente');
    qryRecordCount.ParamByName('pnomeCliente').AsString := '%' + AParams.Items['nomeCliente'].ToLower + '%';
  end;

  if AParams.ContainsKey('idUsuario') then
  begin
    qryPesquisa.SQL.Add('and p.id_usuario = :pidUsuario');
    qryPesquisa.ParamByName('pidUsuario').AsLargeInt := AParams.Items['idUsuario'].ToInt64;

    qryRecordCount.SQL.Add('and p.id_usuario = :pidUsuario');
    qryRecordCount.ParamByName('pidUsuario').AsLargeInt := AParams.Items['idUsuario'].ToInt64;
  end;
  qryPesquisa.SQL.Add('order by p.id');

  Result := inherited ListAll(AParams);
end;

procedure TServicesPedido.qryCadastroAfterInsert(DataSet: TDataSet);
begin
  inherited;
  qryCadastrodata.AsDateTime := Now;
end;

end.

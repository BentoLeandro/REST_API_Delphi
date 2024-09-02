unit Services_Pedido_Item;

interface

uses
  System.SysUtils, System.Classes, Providers_Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  System.Generics.Collections, FireDAC.VCLUI.Wait;

type
  TServicesPedidoItem = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisaid_produto: TLargeintField;
    qryPesquisavalor: TFMTBCDField;
    qryPesquisaquantidade: TFMTBCDField;
    qryPesquisanome_produto: TWideStringField;
    qryCadastroid: TLargeintField;
    qryCadastroid_pedido: TLargeintField;
    qryCadastroid_produto: TLargeintField;
    qryCadastrovalor: TFMTBCDField;
    qryCadastroquantidade: TFMTBCDField;
    qryCadastronome_produto: TWideStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Append(const AJson: TJSONObject) : Boolean; override;
    function ListAllByPedido(const AParams: TDictionary<string, string>; const AIdPedido: string) : TFDQuery;
    function GetByPedido(const AIdPedido, AIdItem: string) : TFDQuery;
  end;

var
  ServicesPedidoItem: TServicesPedidoItem;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicesPedidoItem }

function TServicesPedidoItem.Append(const AJson: TJSONObject): Boolean;
begin
  Result := inherited Append(AJson);
  qryCadastroid_pedido.Visible := False;
end;

function TServicesPedidoItem.GetByPedido(const AIdPedido, AIdItem: string): TFDQuery;
begin
  qryCadastroid_pedido.Visible := False;
  qryCadastro.SQL.Add('where i.id = :pid_item');
  qryCadastro.SQL.Add('and i.id_pedido = :pid_pedido');
  qryCadastro.ParamByName('pid_item').AsLargeInt := AIdItem.ToInt64;
  qryCadastro.ParamByName('pid_pedido').AsLargeInt := AIdPedido.ToInt64;
  qryCadastro.Open();
  Result := qryCadastro;
end;

function TServicesPedidoItem.ListAllByPedido(
  const AParams: TDictionary<string, string>; const AIdPedido: string): TFDQuery;
begin
  qryPesquisa.ParamByName('pid_pedido').AsLargeInt := AIdPedido.ToInt64;
  qryRecordCount.ParamByName('pid_pedido').AsLargeInt := AIdPedido.ToInt64;

  Result := ListAll(AParams);
end;

end.

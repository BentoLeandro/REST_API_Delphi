unit Services_Usuario;

interface

uses
  System.SysUtils, System.Classes, Providers_Cadastro, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.VCLUI.Wait,
  System.Generics.Collections, System.JSON;

type
  TServicesUsuario = class(TProvidersCadastro)
    qryPesquisaid: TLargeintField;
    qryPesquisanome: TWideStringField;
    qryPesquisalogin: TWideStringField;
    qryPesquisastatus: TSmallintField;
    qryPesquisatelefone: TWideStringField;
    qryPesquisasexo: TSmallintField;
    qryCadastroid: TLargeintField;
    qryCadastronome: TWideStringField;
    qryCadastrologin: TWideStringField;
    qryCadastrosenha: TWideStringField;
    qryCadastrostatus: TSmallintField;
    qryCadastrotelefone: TWideStringField;
    qryCadastrosexo: TSmallintField;
    qryCadastrofoto: TBlobField;
    procedure qryCadastroBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function ListAll(const AParams: TDictionary<string, string>) : TFDQuery; override;
    function GetById(const AId: string) : TFDQuery; override;
    function Append(const AJson: TJSONObject) : Boolean; override;
    function Update(const AJson: TJSONObject) : Boolean; override;
    function SalvarFotoUsuario(const AFoto : TStream) : Boolean;
    function ObterFotoUsuario : TStream;
  end;

var
  ServicesUsuario: TServicesUsuario;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TServicesUsuario }

uses BCrypt;

function TServicesUsuario.Append(const AJson: TJSONObject): Boolean;
begin
  Result := inherited Append(AJson);
  qryCadastrosenha.Visible := False;
end;

function TServicesUsuario.GetById(const AId: string): TFDQuery;
begin
  qryCadastrosenha.Visible := False;
  Result := inherited GetById(AId);
end;

function TServicesUsuario.ListAll(
  const AParams: TDictionary<string, string>): TFDQuery;
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
    qryPesquisa.ParamByName('pnome').AsString := '%' + AParams.Items['nome'].ToLower + '%';

    qryRecordCount.SQL.Add('and lower(nome) like :pnome');
    qryRecordCount.ParamByName('pnome').AsString := '%' + AParams.Items['nome'].ToLower + '%';
  end;


  if AParams.ContainsKey('login') then
  begin
    qryPesquisa.SQL.Add('and lower(login) like :plogin');
    qryPesquisa.ParamByName('plogin').AsString := '%' + AParams.Items['login'].ToLower + '%';

    qryRecordCount.SQL.Add('and lower(login) like :plogin');
    qryRecordCount.ParamByName('plogin').AsString := '%' + AParams.Items['login'].ToLower + '%';
  end;

  if AParams.ContainsKey('telefone') then
  begin
    qryPesquisa.SQL.Add('and telefone like :pfone');
    qryPesquisa.ParamByName('pfone').AsString := '%' + AParams.Items['telefone'] + '%';

    qryRecordCount.SQL.Add('and telefone like :pfone');
    qryRecordCount.ParamByName('pfone').AsString := '%' + AParams.Items['telefone'] + '%';
  end;
  qryPesquisa.SQL.Add('order by u.id');

  Result := inherited ListAll(AParams);
end;

function TServicesUsuario.ObterFotoUsuario: TStream;
begin
  Result := nil;
  if qryCadastrofoto.IsNull then
    Exit;

  Result := TMemoryStream.Create;
  qryCadastrofoto.SaveToStream(Result);
end;

procedure TServicesUsuario.qryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (qryCadastrosenha.OldValue <> qryCadastrosenha.NewValue) and
     (not qryCadastrosenha.AsString.Trim.IsEmpty) then
  begin
    qryCadastrosenha.AsString := TBCrypt.GenerateHash(qryCadastrosenha.AsString);
  end;
end;

function TServicesUsuario.SalvarFotoUsuario(const AFoto: TStream): Boolean;
begin
  qryCadastro.Edit;
  qryCadastrofoto.LoadFromStream(AFoto);
  qryCadastro.Post;

  Result := qryCadastro.ApplyUpdates(0) = 0;
end;

function TServicesUsuario.Update(const AJson: TJSONObject): Boolean;
begin
  qryCadastrosenha.Visible := True;
  Result := inherited Update(AJson);
end;

end.

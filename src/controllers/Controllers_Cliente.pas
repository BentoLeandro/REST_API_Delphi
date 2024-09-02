unit Controllers_Cliente;

interface

uses Horse;

procedure Registry;

implementation

uses Services_Cliente, System.JSON, DataSet.Serialize, Data.DB;

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LRetorno : TJSONObject;
  LService : TServicesCliente;
begin
  LService := TServicesCliente.Create();
  try
    LRetorno := TJSONObject.Create();
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdCliente : string;
  LService : TServicesCliente;
begin
  LService := TServicesCliente.Create;
  try
    LIdCliente := Req.Params['id'];
    if LService.GetById(LIdCliente).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Cliente não Encontrado!');

    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LCliente : TJSONObject;
  LService : TServicesCliente;
begin
  LService := TServicesCliente.Create;
  try
    LCliente := Req.Body<TJSONObject>;
    if LService.Append(LCliente) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdCliente : string;
  LCliente : TJSONObject;
  LService : TServicesCliente;
begin
  LService := TServicesCliente.Create;
  try
    LIdCliente := Req.Params['id'];
    if LService.GetById(LIdCliente).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Cliente não Encontrado!');

    LCliente := Req.Body<TJSONObject>;
    if LService.Update(LCliente) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdCLiente : string;
  LService : TServicesCliente;
begin
  LService := TServicesCliente.Create;
  try
    LIdCLiente := Req.Params['id'];
    if LService.GetById(LIdCLiente).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Cliente não Encontrado!');

    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;


procedure Registry;
begin
  THorse.Get('/clientes', ListarClientes);
  THorse.Get('/clientes/:id', ObterCliente);
  THorse.Post('/clientes', CadastrarCliente);
  THorse.Put('/clientes/:id', AlterarCliente);
  THorse.Delete('/clientes/:id', DeletarCliente);
end;

end.

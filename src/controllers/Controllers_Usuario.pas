unit Controllers_Usuario;

interface

uses Horse;

procedure Registry;



implementation

uses Services_Usuario, System.JSON, DataSet.Serialize, Data.DB, System.Classes;

procedure ListarUsuarios(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LRetorno : TJSONObject;
begin
  LService := TServicesUsuario.Create;
  try
    LRetorno := TJSONObject.Create;
    LRetorno.AddPair('data', LService.ListAll(Req.Query.Dictionary).ToJSONArray());
    LRetorno.AddPair('records', TJSONNumber.Create(LService.GetRecordCount));

    Res.Send(LRetorno);
  finally
    LService.Free;
  end;
end;

procedure ObterUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LIdUsuario : string;
begin
  LService := TServicesUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Usuário não Encontrado!');

    Res.Send(LService.qryCadastro.ToJSONObject());
  finally
    LService.Free;
  end;
end;

procedure CadastrarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LUsuario : TJSONObject;
begin
  LService := TServicesUsuario.Create;
  try
    LUsuario := Req.Body<TJSONObject>;
    if LService.Append(LUsuario) then
      Res.Send(LService.qryCadastro.ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure AlterarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LIdUsuario : string;
  LUsuario : TJSONObject;
begin
  LService := TServicesUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Usuário não Encontrado!');

    LUsuario := Req.Body<TJSONObject>;
    if LService.Update(LUsuario) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure DeletarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LIdUsuario : string;
begin
  LService := TServicesUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Usuário não Encontrado!');

    if LService.Delete then
      res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure CadastrarFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc) ;
var
  LService : TServicesUsuario;
  LIdUsuario : string;
  LFoto : TMemoryStream;
begin
  LService := TServicesUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Usuário não Encontrado!');

    LFoto := Req.Body<TMemoryStream>;
    if not Assigned(LFoto) then
      raise EHorseException.New.Status(THTTPStatus.BadRequest).Error('Foto Inválida!');

    if LService.SalvarFotoUsuario(LFoto) then
      Res.Status(THTTPStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure ObterFotoUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LService : TServicesUsuario;
  LIdUsuario : string;
  LFoto : TStream;
begin
  LService := TServicesUsuario.Create;
  try
    LIdUsuario := Req.Params.Items['id'];
    if LService.GetById(LIdUsuario).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Usuário não Encontrado!');

    LFoto := LService.ObterFotoUsuario;
    if not Assigned(LFoto) then
      raise EHorseException.New.Status(THTTPStatus.NotFound).Error('Foto não Cadastrada!');

    Res.Send(LFoto);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/usuarios', ListarUsuarios);
  THorse.Get('/usuarios/:id', ObterUsuario);
  THorse.Post('/usuarios', CadastrarUsuario);
  THorse.Put('/usuarios/:id', AlterarUsuario);
  THorse.Delete('/usuarios/:id', DeletarUsuario);
  THorse.Post('/usuarios/:id/foto', CadastrarFotoUsuario);
  THorse.Get('/usuarios/:id/foto', ObterFotoUsuario);
end;

end.

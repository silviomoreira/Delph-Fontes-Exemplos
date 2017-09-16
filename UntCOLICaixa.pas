unit UntCOLICaixa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, ComCtrls, DB, Mask, Buttons,
  Grids, DBGrids, DBTables, Extras;

type
  TFrmCOLICaixa = class(TForm)
    pnInformacao: TPanel;
    shNomeFormulario: TShape;
    laTituloForm: TLabel;
    gbNavegacao: TGroupBox;
    DBnaNavegacao: TDBNavigator;
    dsCaixa: TDataSource;
    bbPesquisar: TBitBtn;
    bbImpressao: TBitBtn;
    bbFechar: TBitBtn;
    pnControle: TPanel;
    bbNovo: TBitBtn;
    bbExclui: TBitBtn;
    bbGrava: TBitBtn;
    bbCancela: TBitBtn;
    pnDados: TPanel;
    gbLancamentos: TGroupBox;
    DBgdLancamentos: TDBGrid;
    dsCaixaPesquisa: TDataSource;
    PageControl1: TPageControl;
    tsGeral: TTabSheet;
    tsPago: TTabSheet;
    gbCliente: TGroupBox;
    DBedRazaoSocial: TDBEdit;
    bbPesquisaPorResponsavel: TBitBtn;
    bbBuscaPorResponsavel: TBitBtn;
    gbPedidos: TGroupBox;
    DBedPedidos: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBedDtPagto: TDBEdit;
    DBedValorPago: TDBEdit;
    DBedDiscriminacao: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DBedDtVencto: TDBEdit;
    DBedValorCobrado: TDBEdit;
    DBedNumeroCheque: TDBEdit;
    rgTipoRecebimento: TRadioGroup;
    Label7: TLabel;
    meRepeteAte: TMaskEdit;
    Label8: TLabel;
    Label9: TLabel;
    DBedDescricaoBanco: TDBEdit;
    bbBuscaBanco: TBitBtn;
    bbBuscaPorRazaoSocial: TBitBtn;
    DBedResponsavel: TDBEdit;
    bbPesquisaPorRazaoSocial: TBitBtn;
    DBedTitularConta: TDBEdit;
    Label10: TLabel;
    bbPreparaBaixa: TSpeedButton;
    laResponsavelLKP: TLabel;
    bbCancelaBaixa: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure dsCaixaStateChange(Sender: TObject);
    procedure bbFecharClick(Sender: TObject);
    procedure bbPesquisarClick(Sender: TObject);
    procedure bbImpressaoClick(Sender: TObject);
    procedure bbNovoClick(Sender: TObject);
    procedure bbExcluiClick(Sender: TObject);
    procedure bbGravaClick(Sender: TObject);
    procedure bbCancelaClick(Sender: TObject);
    procedure bbPesquisaPorResponsavelClick(Sender: TObject);
    procedure bbBuscaPorResponsavelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBedDtPagtoExit(Sender: TObject);
    procedure bbBuscaBancoClick(Sender: TObject);
    procedure rgTipoRecebimentoClick(Sender: TObject);
    procedure meRepeteAteExit(Sender: TObject);
    procedure dsCaixaDataChange(Sender: TObject; Field: TField);
    procedure bbPreparaBaixaClick(Sender: TObject);
    procedure DBedPedidosExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure bbCancelaBaixaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCOLICaixa: TFrmCOLICaixa;

implementation

{$R *.DFM}

 uses UntCOLIMenu               ,
      UntCOLIDataModuloTransacoes ,
      UntCOLIRotinas            ,
      UntMSGPesquisa, UntCOLIBuscaMacia, UntCOLIBuscaMacia2, UntCOLIDataModuloArquivos,
  UntCOLIDadosRelCaixa;

{================================================+
! Objetivo: configurações iniciais do formulário !
+================================================}
procedure TFrmCOLICaixa.FormCreate(Sender: TObject);
var lstTipo: String;
begin
   Top      := 1;
   Left     := round((FrmCOLIMenu.Width-775)/2);
   Position := poDefaultPosOnly;
   // Abre arqs.
   PAbreFechaArquivosCaixa(True);
   FrmCOLIDataModuloTransacoes.tbCaixa.FieldbyName('CXA_DTPAGTO').EditMask    := '99/99/9999;1';
end;

procedure TFrmCOLICaixa.FormActivate(Sender: TObject);
begin
   // Abre arqs.
   PAbreFechaArquivosCaixa(True);
   //FrmCOLIDataModuloTransacoes.tbCaixa.IndexName := 'Caixa-1'; | Dá erro   
end;

{===============================================+
! Objetivo: verifica o fechamento do formulário !
+===============================================}
procedure TFrmCOLICaixa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   Canclose := VerificaFechamentoFormBD(dsCaixa,'Transações - Caixa');
end;

{==============================+
! Objetivo: liberar formulário !
+==============================}
procedure TFrmCOLICaixa.FormDestroy(Sender: TObject);
begin
   FrmCOLICaixa := nil;
   PAbreFechaArquivosCaixa(False);
end;

{================================================================================+
! Objetivo: desativar os butões de navegação nas operações de edição ou inclusão !
+================================================================================}
procedure TFrmCOLICaixa.dsCaixaStateChange(Sender: TObject);
begin
   with dsCaixa do
   begin
      DBnaNavegacao.Enabled := not (State in [dsInsert,dsEdit]);
      bbPesquisar.Enabled   := (DBnaNavegacao.Enabled) and (DataSet.RecordCount <> 0);
      bbImpressao.Enabled   := (bbPesquisar.Enabled);
      // Painel de Controle
      bbNovo.Enabled    := (DBnaNavegacao.Enabled);
      bbExclui.Enabled  := (bbPesquisar.Enabled);
      bbGrava.Enabled   := not (DBnaNavegacao.Enabled);
      bbCancela.Enabled := not (DBnaNavegacao.Enabled);
      bbPesquisaPorRazaoSocial.Enabled := (bbPesquisar.Enabled);
      bbPesquisaPorResponsavel.Enabled := (bbPesquisar.Enabled);
      bbPreparaBaixa.Enabled := (bbPesquisar.Enabled);
      DBgdLancamentos.Enabled := (DBnaNavegacao.Enabled);
      bbCancelaBaixa.Enabled := (bbPesquisar.Enabled);
   end;
end;

{=======================================================================+
! Objetivo: Ao clicar nos butões...                                     !
+=======================================================================}
{=================================+
! Objetivo: fechar formulário     !
+=================================}
procedure TFrmCOLICaixa.bbFecharClick(Sender: TObject);
begin
   close;
end;

{=================================+
! Objetivo: pesquisar informações !
+=================================}
procedure TFrmCOLICaixa.bbPesquisarClick(Sender: TObject);
begin
   with FrmMsgPesquisa do
   begin
      NomeObjetoTable        := FrmCOLIDataModuloTransacoes.tbCaixaPesquisa;
      NomeTabelaResultado    := FrmCOLIDataModuloTransacoes.tbCaixa;
      NomeArquivoFisico      := 'CAIXA';
      NomeCampoChave         := 'CXA_CODIGO';
   end;
   if assigned(FrmMSGPesquisa) then
      FrmMSGPesquisa.Free;
   FrmMSGPesquisa := TFrmMSGPesquisa.create(self);
   FrmMSGPesquisa.caption := 'Transações - Caixa - Pesquisa';
   FrmMSGPesquisa.showmodal;
end;

{=================================+
! Objetivo: Impressão             !
+=================================}
procedure TFrmCOLICaixa.bbImpressaoClick(Sender: TObject);
begin
   bbImpressao.Enabled := False;
   FrmCOLIDadosRELCaixa := TFrmCOLIDadosRELCaixa.Create(Self);
   With FrmCOLIDadosRELCaixa do
   begin
      Try
         Showmodal;
      Finally
         Free;
      End;
   end;
   bbImpressao.Enabled := True;
end;

{================================================================+
! Objetivo: Botões do painel de controle                         !
+================================================================}
procedure TFrmCOLICaixa.bbNovoClick(Sender: TObject);
begin
   FrmCOLIDataModuloTransacoes.tbCaixa.Append;
   if dsCaixa.State in [dsInsert,dsEdit] then
      FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_DTVENCTO').Value := Date;
   meRepeteAte.Text := '';
   DBedRazaoSocial.SetFocus;
end;

procedure TFrmCOLICaixa.bbExcluiClick(Sender: TObject);
begin
   If (Mensagem('Exclui Registro ?',2) = idyes) and
      (Mensagem('Tem certeza ?',2) = idyes)    then
      FrmCOLIDataModuloTransacoes.tbCaixa.Delete;
end;

procedure TFrmCOLICaixa.bbGravaClick(Sender: TObject);
var i,linCodigo,linCodCli,linCompCh: Integer;
    lstPedidos,lstCheque,{lstDesBan,}lstNovCheque,lstTitular,lstCodBan: String;
    lreValCob: Currency;
    ldtDtVencto: TDateTime;
begin
   // Critica digitacao de dados
   With FrmCOLIDataModuloTransacoes.tbCaixa do
   begin
      If FieldByName('CXA_DTVENCTO').AsString = '' then
      begin
         Mensagem('Dt. Vencimento não preenchida !',1);
         PageControl1.ActivePage := tsGeral;
         DBedDtVencto.SetFocus;
         Exit;
      end;
      If FieldByName('CXA_VALORCOBRADO').AsString = '' then
      begin
         Mensagem('Valor cobrado não preenchido !',1);
         PageControl1.ActivePage := tsGeral;
         DBedValorCobrado.SetFocus;
         Exit;
      end;
      If (FieldByName('CXA_NUMEROCHEQUE').AsString = '') and (rgTipoRecebimento.ItemIndex = 0) then
      begin
         Mensagem('Número do Cheque não preenchido !',1);
         PageControl1.ActivePage := tsGeral;
         DBedNumeroCheque.SetFocus;
         Exit;
      end;
      //If (FieldByName('CXA_DESCRICAOBANCO').AsString = '') and (rgTipoRecebimento.ItemIndex = 0) then
      If (FieldByName('CXA_CODIGOBANCO').AsString = '') and (rgTipoRecebimento.ItemIndex = 0) then
      begin
         Mensagem('Banco não preenchido !',1);
         PageControl1.ActivePage := tsGeral;         
         DBedDescricaoBanco.SetFocus;
         Exit;
      end;
   end;
   //
   If dsCaixa.State in [dsInsert] then
   begin
      // Examina se já há algum registro com este conjunto de pedidos cadastrado
      if (FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString <> '') and
         FrmCOLIDataModuloTransacoes.tbCaixaPesquisa.Locate('CXA_PEDIDOS',
         FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString,[]) then
      begin
         if Mensagem('Já há um registro com este(s) pedido(s) cadastrado(s). Permite a inclusão ?',2) <> idYes then
            Exit;
      end;
      If ((Trim(meRepeteAte.Text) <> '') and (Mensagem('Repete até '+Trim(meRepeteAte.Text)+' vezes ?',2) = idyes)) then
      begin
         i := 0;
         For i := 1 to StrtoInt(Trim(meRepeteAte.Text)) do
         begin
            if i > 1 then
               FrmCOLIDataModuloTransacoes.tbCaixa.Append;

            linCodigo := FCodigoSequencial('CAIXA',
               FrmCOLIDataModuloTransacoes.tbCaixa,
               FrmCOLIDataModuloArquivos.tbSequenciais);
            Try
               With FrmCOLIDataModuloArquivos.tbSequenciais do
               begin
                  Post;
                  Close;
               end;
               With FrmCOLIDataModuloTransacoes.tbCaixa do
               begin
                  FieldByName('CXA_CODIGO').Value := linCodigo;
                  if i = 1 then
                  begin
                     linCodCli := FieldByName('CXA_CODCLIENTE').AsInteger;
                     lstPedidos:= FieldByName('CXA_PEDIDOS').AsString;
                     lstCheque := FieldByName('CXA_NUMEROCHEQUE').AsString;
                     linCompCh := Length(FieldByName('CXA_NUMEROCHEQUE').AsString);
//                     lstDesBan := FieldByName('CXA_DESCRICAOBANCO').AsString;
                     lreValCob := FieldByName('CXA_VALORCOBRADO').AsCurrency;
                     ldtDtVencto := FieldByName('CXA_DTVENCTO').AsDateTime;
                     lstTitular :=  FieldByName('CXA_TITULARCONTA').AsString;
                     lstCodBan :=  FieldByName('CXA_CODIGOBANCO').AsString;
                  end
                  else
                  begin
                     if linCodCli = 0 then
                        FieldByName('CXA_CODCLIENTE').Clear
                     else
                        FieldByName('CXA_CODCLIENTE').Value := linCodCli;
                     FieldByName('CXA_PEDIDOS').Value := lstPedidos;
                     lstNovCheque := InttoStr(StrtoInt(lstCheque)+i-1);
                     FieldByName('CXA_NUMEROCHEQUE').Value :=
                        Copy( Replicate('0',linCompCh), 1, LinCompCh-Length(lstNovCheque) ) + lstNovCheque;
//                     FieldByName('CXA_DESCRICAOBANCO').Value := lstdesBan;
                     FieldByName('CXA_VALORCOBRADO').Value := lreValCob;
                     ldtDtVencto := StrToDate( Copy(DatetoStr(ldtDtVencto),1,3) + Copy(DatetoStr(ldtDtVencto+30),4,7) );
                     FieldByName('CXA_DTVENCTO').Value := ldtDtVencto;
                     FieldByName('CXA_TITULARCONTA').AsString := lstTitular;
                     FieldByName('CXA_CODIGOBANCO').AsString := lstCodBan;                      
                  end;
                  Post;
                  Refresh;
               end;
            Except on e:Exception do
            begin
               Mensagem('Gravação do registro '+Trim(meRepeteAte.Text)+' da sequência de repetição não efetivada ! ' + e.Message,1);
               Abort;
            end;end;

         end;
      end
      else
      begin
         linCodigo := FCodigoSequencial('CAIXA',
            FrmCOLIDataModuloTransacoes.tbCaixa,
            FrmCOLIDataModuloArquivos.tbSequenciais);
         Try
            With FrmCOLIDataModuloArquivos.tbSequenciais do
            begin
               Post;
               Close;
            end;
            With FrmCOLIDataModuloTransacoes.tbCaixa do
            begin
               FieldByName('CXA_CODIGO').Value := linCodigo;
               Post;
               Refresh;
            end;
         Except on e:Exception do
         begin
            Mensagem('Gravação não efetivada ! ' + e.Message,1);
            Abort;
         end;end;
      end;
   end
   Else // Alteração
   begin
      Try
         With FrmCOLIDataModuloTransacoes.tbCaixa do
         begin
            If (FieldByName('CXA_VALORCOBRADO').AsString <> '') and (FieldByName('CXA_VALORPAGO').AsString <> '') and
               (FieldByName('CXA_VALORCOBRADO').AsString <> FieldByName('CXA_VALORPAGO').AsString) and
               (Mensagem('Valor cobrado diferente do valor pago. Preenche valor pago com valor cobrado ?',2) = idYes) then
               FieldByName('CXA_VALORPAGO').Value := FieldByName('CXA_VALORCOBRADO').Value;
            Post;
            Refresh;
         end;
      Except on e:Exception do
      begin
         Mensagem('Gravação não efetivada ! ' + e.Message,1);
         Abort;
      end;end;
   end;
   If DBgdLancamentos.Enabled then
      DBgdLancamentos.SetFocus;
   laResponsavelLKP.Caption := '';
end;

procedure TFrmCOLICaixa.bbCancelaClick(Sender: TObject);
var lstTipo: String;
begin
   With FrmCOLIDataModuloTransacoes.tbCaixa do
   begin
      Cancel;
      Refresh;
   end;
   laResponsavelLKP.Caption := '';
end;

{================================================================+
! Objetivo: Mostra na tela Lookup de busca macia                 !
+================================================================}
procedure TFrmCOLICaixa.bbBuscaPorResponsavelClick(
  Sender: TObject);
var i: Integer;
begin
   bbBuscaPorRazaoSocial.enabled := False;
   i := 0;
   With FrmCOLIDataModuloArquivos.tbClientesPesquisaB do
   begin
      if Sender <> bbBuscaPorRazaoSocial then
         While i <= FieldCount-1 do
         begin
            if Fields[i].FieldName = 'CLI_CODIGO' then Fields[i].Visible := False;
            if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 2;
            if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 7;
            if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 1;
            Inc(i);
         end
      else
         While i <= FieldCount-1 do
         begin
            if Fields[i].FieldName = 'CLI_CODIGO' then Fields[i].Visible := False;
            if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 1;
            if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 7;
            if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 2;
            Inc(i);
         end;
   end;
   FrmCOLIBuscaMacia2 := TFrmCOLIBuscaMacia2.create(self);
   FrmCOLIBuscaMacia2.VLkTabelaDataSource := FrmCOLIDataModuloTransacoes.tbCaixa;
   FrmCOLIBuscaMacia2.VLkDataField  := 'CXA_CODCLIENTE';
   //FrmCOLIBuscaMacia2.VLkDataFields := 'CXA_CODCLIENTE';
   FrmCOLIBuscaMacia2.VLkTabelaLookupSource := FrmCOLIDataModuloArquivos.tbClientesPesquisaB;
   if Sender = bbBuscaPorRazaoSocial then
      FrmCOLIBuscaMacia2.VLkLookupDisPlay := 'Aluno'//'CLI_ALUNO'
   else // bbBuscaPorResponsavel
      FrmCOLIBuscaMacia2.VLkLookupDisPlay := 'Responsavel';//'CLI_RESPONSAVEL';
   FrmCOLIBuscaMacia2.VLkLookupField   := 'Codigo';//'CLI_CODIGO';
   FrmCOLIBuscaMacia2.VLkLookupFieldOriginal := 'CLI_CODIGO';
   FrmCOLIBuscaMacia2.uinLargura       := iif( Sender = bbBuscaPorRazaoSocial, 850, 825 );
   FrmCOLIBuscaMacia2.uinMensagem      := '';
   FrmCOLIBuscaMacia2.VlkQueryLookupSource := FrmCOLIDataModuloArquivos.qeAux;
   if Sender = bbBuscaPorRazaoSocial then
      FrmCOLIBuscaMacia2.VlkConsultaSQL   := 'SELECT CLI_ALUNO AS Aluno, CLI_RESPONSAVEL AS Responsavel, CLI_CODIGO AS Codigo  FROM CLIENTES '+
                                             'ORDER BY CLI_ALUNO'
   else
      FrmCOLIBuscaMacia2.VlkConsultaSQL   := 'SELECT CLI_RESPONSAVEL AS Responsavel, CLI_ALUNO AS Aluno, CLI_CODIGO AS Codigo  FROM CLIENTES ORDER BY CLI_RESPONSAVEL';
   if Sender = bbBuscaPorRazaoSocial then
      FrmCOLIBuscaMacia2.Caption := 'Transações - Caixa - Busca Macia p/ RAZÃO SOCIAL(ALUNO)'
   else // bbBuscaPorResponsavel
      FrmCOLIBuscaMacia2.Caption := 'Transações - Caixa - Busca Macia p/ RESPONSÁVEL';
   FrmCOLIBuscaMacia2.showmodal;
//   If FrmCOLIBuscaMacia2.ModalResult <> mrOk then
   if (dsCaixa.State <> dsInsert) then
      FrmCOLIDataModuloTransacoes.tbCaixa.Cancel;
   i := 0;
   With FrmCOLIDataModuloArquivos.tbClientesPesquisaB do
   begin
      While i <= FieldCount-1 do
      begin
         if Fields[i].FieldName = 'CLI_CODIGO' then Fields[i].Visible := True;
         if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 1;
         if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 2;
         if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 7;
         Inc(i);
      end;
   end;
   bbBuscaPorRazaoSocial.enabled := True;
   DBedPedidos.SetFocus;

end;
{================================================================+
! Objetivo: Mostra na tela Lookup de busca macia p/ pesquisas    !
! dentro do próprio arquivo                                      !
+================================================================}
procedure TFrmCOLICaixa.bbPesquisaPorResponsavelClick(Sender: TObject);
var i: Integer;
begin
   i := 0;
   With FrmCOLIDataModuloArquivos.tbClientesPesquisaB do
   begin
      if Sender <> bbPesquisaPorRazaoSocial then // bbPesquisaPorResponsavel
         While i <= FieldCount-1 do
         begin
            if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 2;
            if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 7;
            if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 1;
            Inc(i);
         end
      else
         While i <= FieldCount-1 do
         begin
            if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 1;
            if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 7;
            if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 2;
            Inc(i);
         end;
   end;
   FrmCOLIBuscaMacia2 := TFrmCOLIBuscaMacia2.create(self);
   FrmCOLIBuscaMacia2.VLkTabelaDataSource := Nil;
   FrmCOLIBuscaMacia2.VLkDataField  := '';
   FrmCOLIBuscaMacia2.VLkTabelaLookupSource := FrmCOLIDataModuloArquivos.tbClientesPesquisaB;
   if Sender = bbPesquisaPorRazaoSocial then
      FrmCOLIBuscaMacia2.VLkLookupDisPlay := 'Aluno'
   else // bbPesquisaPorResponsavel
      FrmCOLIBuscaMacia2.VLkLookupDisPlay := 'Responsavel';
   FrmCOLIBuscaMacia2.VLkLookupField   := 'Codigo';
   FrmCOLIBuscaMacia2.VLkLookupFields  := 'CXA_CODIGO';
   FrmCOLIBuscaMacia2.uinLargura       := 547;
   FrmCOLIBuscaMacia2.uinMensagem      := '';
   FrmCOLIBuscaMacia2.VlkQueryLookupSource := FrmCOLIDataModuloArquivos.qeAux;
   if Sender = bbPesquisaPorRazaoSocial then
      FrmCOLIBuscaMacia2.VlkConsultaSQL   := 'SELECT CLI_ALUNO AS Aluno, CLI_RESPONSAVEL AS Responsavel, CXA_CODIGO AS Codigo, BAN_SIGLA AS Sigla_Banco FROM CAIXA '+
                                             'LEFT JOIN CLIENTES ON CXA_CODCLIENTE = CLI_CODIGO '+
                                             'LEFT JOIN BANCOS   ON CXA_CODIGOBANCO = BAN_CODIGO '+
                                             'ORDER BY CLI_ALUNO'
   else
      FrmCOLIBuscaMacia2.VlkConsultaSQL   := 'SELECT CLI_RESPONSAVEL AS Responsavel, CLI_ALUNO AS Aluno, CXA_CODIGO AS Codigo, BAN_SIGLA AS Sigla_Banco FROM CAIXA '+
                                             'LEFT JOIN CLIENTES ON CXA_CODCLIENTE = CLI_CODIGO '+
                                             'LEFT JOIN BANCOS   ON CXA_CODIGOBANCO = BAN_CODIGO '+
                                             'ORDER BY CLI_RESPONSAVEL';
   if Sender = bbPesquisaPorRazaoSocial then
      Caption := 'Transações - Caixa - Pesquisa Macia p/ RAZÃO SOCIAL(ALUNO)'
   else // bbPesquisaPorResponsavel
      Caption := 'Transações - Caixa - Pesquisa Macia p/ RESPONSÁVEL';
   FrmCOLIBuscaMacia2.showmodal;
   If FrmCOLIBuscaMacia2.ModalResult = mrOk then
   begin
      If not FrmCOLIDataModuloTransacoes.tbCaixa.
         Locate('CXA_CODCLIENTE',FrmCOLIDataModuloArquivos.tbClientesPesquisaB.
         FieldByName('CLI_CODIGO').AsInteger,[]) then
         Mensagem('Cliente não encontrado !',1);
   end;
   i := 0;
   With FrmCOLIDataModuloArquivos.tbClientesPesquisaB do
   begin
      While i <= FieldCount-1 do
      begin
         if Fields[i].FieldName = 'CLI_ALUNO' then Fields[i].Index := 1;
         if Fields[i].FieldName = 'CLI_ENDERECO' then Fields[i].Index := 2;
         if Fields[i].FieldName = 'CLI_RESPONSAVEL' then Fields[i].Index := 7;
         Inc(i);
      end;
   end;
   DBedPedidos.SetFocus;
   // Redireciona ordem por obra já que o comp. redireciona p/ código
   //FrmCOLIDataModuloArquivos.tbLivros.IndexName := 'Livros-1';
end;

procedure TFrmCOLICaixa.FormShow(Sender: TObject);
begin
   If bbPesquisaPorRazaoSocial.Enabled then
      bbPesquisaPorRazaoSocial.SetFocus;
end;

procedure TFrmCOLICaixa.DBedDtPagtoExit(Sender: TObject);
begin
   With FrmCOLIDataModuloTransacoes.tbCaixa,FrmCOLIDataModuloTransacoes do
      If (dsCaixa.State in [dsInsert,dsEdit]) then
      begin
         if (FieldByName('CXA_DTVENCTO').AsString <> '') then
         begin
            If not Validarcamposdata(FieldByName('CXA_DTVENCTO').AsString) then
            begin
               DBedDtVencto.SetFocus;
               Exit;
            end;
         end;
         If (FieldByName('CXA_DTVENCTO').AsString <> '')  and
            (FieldByName('CXA_DTPAGTO').AsString <> '')   and
            (FieldByName('CXA_DTPAGTO').AsDateTime < FieldByName('CXA_DTVENCTO').AsDateTime) then
         begin
            Mensagem('Data de Pagamento não pode ser anterior à data do Vencimento',1);
            bbCancelaClick(nil);
            //(Sender as TDBEdit).SetFocus; // Estava prendendo neste campo sem permitir cancelar a operação
         end;
      end;
end;

procedure TFrmCOLICaixa.bbBuscaBancoClick(Sender: TObject);
begin
   FrmCOLIBuscaMacia2 := TFrmCOLIBuscaMacia2.create(self);
   FrmCOLIBuscaMacia2.VLkTabelaDataSource := FrmCOLIDataModuloTransacoes.tbCaixa;
   FrmCOLIBuscaMacia2.VLkDataField  := 'CXA_CODIGOBANCO';
   FrmCOLIBuscaMacia2.VLkTabelaLookupSource := FrmCOLIDataModuloArquivos.tbBancosPesquisa;
   FrmCOLIBuscaMacia2.VLkLookupDisPlay := 'Sigla';
   FrmCOLIBuscaMacia2.VLkLookupField   := 'Codigo';
   FrmCOLIBuscaMacia2.VLkLookupFieldOriginal := 'BAN_CODIGO';
   FrmCOLIBuscaMacia2.uinLargura       := 825;
   FrmCOLIBuscaMacia2.uinMensagem      := '';
   FrmCOLIBuscaMacia2.VlkQueryLookupSource := FrmCOLIDataModuloArquivos.qeAux;
   FrmCOLIBuscaMacia2.VlkConsultaSQL   := 'SELECT BAN_SIGLA AS Sigla, BAN_CODIGO AS Codigo  FROM BANCOS  ORDER BY BAN_SIGLA';
   {
   // Posiciona no BRADESCO
   With FrmCOLIDataModuloArquivos.tbBancosPesquisa do
   begin
      If not Locate('BAN_SIGLA','BRADESCO',[]) then
         First;
   end;
   if not assigned(FrmCOLIBuscaMacia) then
      FrmCOLIBuscaMacia2 := TFrmCOLIBuscaMacia2.create(self);
   }
   FrmCOLIBuscaMacia2.caption := 'Transações - Caixa - Busca Macia p/ BANCO';
   FrmCOLIBuscaMacia2.showmodal;
   DBedTitularConta.SetFocus;
end;

procedure TFrmCOLICaixa.rgTipoRecebimentoClick(Sender: TObject);
begin
   meRepeteAte.Enabled := (rgTipoRecebimento.ItemIndex = 0);
   DBedNumeroCheque.Enabled := meRepeteAte.Enabled;
   DBedDescricaoBanco.Enabled := meRepeteAte.Enabled;
   bbBuscaBanco.Enabled := meRepeteAte.Enabled;
end;

procedure TFrmCOLICaixa.meRepeteAteExit(Sender: TObject);
begin
   Try
      if ((Trim(meRepeteAte.Text) <> '') and (StrtoInt(Trim(meRepeteAte.Text)) < 2)) then
         Mensagem('Valor de repetição baixo',1);
   Except
   End;
end;

procedure TFrmCOLICaixa.dsCaixaDataChange(Sender: TObject; Field: TField);
begin
   if FrmCOLIDataModuloTransacoes.tbCaixa.Recordcount = 0 then
      rgTipoRecebimento.ItemIndex := -1
   else
      if FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_NUMEROCHEQUE').AsString <> '' then
         rgTipoRecebimento.ItemIndex := 0
      else
         rgTipoRecebimento.ItemIndex := 1;
end;

procedure TFrmCOLICaixa.bbPreparaBaixaClick(Sender: TObject);
begin
   FrmCOLIDataModuloTransacoes.tbCaixa.Edit;
   With FrmCOLIDataModuloTransacoes.tbCaixa do
      FieldByName('CXA_VALORPAGO').Value := FieldByName('CXA_VALORCOBRADO').Value;
   DBedDiscriminacao.Setfocus;
end;

procedure TFrmCOLICaixa.DBedPedidosExit(Sender: TObject);
var linPosB, linPosV: Integer;
    lstCha: String;
begin
   If (dsCaixa.State in [dsInsert,dsEdit]) and
      (FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString <> '') then
   begin
      linPosB := Pos('/', FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString);
      linPosV := Pos(',', FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString);
      if linPosB <> 0 then
         lstCha := Copy(FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString, 1, linPosB-1)
      else
      if linPosV <> 0 then
         lstCha := Copy(FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString, 1, linPosV-1)
      else
         lstCha := FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_PEDIDOS').AsString;

      if FrmCOLIDataModuloTransacoes.tbPedidosPesquisa.Locate('PAD_CODIGO',lstCha,[]) and
         //FrmCOLIDataModuloArquivos.tbClientesPesquisaB.Locate('CLI_RESPONSAVEL',
         //   FrmCOLIDataModuloTransacoes.tbPedidosPesquisa.FieldByName('PAD_RESPONSAVEL').AsString,[]) then
         FrmCOLIDataModuloArquivos.tbClientesPesquisaB.Locate('CLI_CODIGO',
            FrmCOLIDataModuloTransacoes.tbPedidosPesquisa.FieldByName('PAD_CODCLIENTE').AsString,[]) then
      begin
         FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_CODCLIENTE').Value :=
            FrmCOLIDataModuloArquivos.tbClientesPesquisaB.FieldByName('CLI_CODIGO').Value;
         //laResponsavelLKP.Caption := 'Responsável: '+FrmCOLIDataModuloTransacoes.tbPedidosPesquisa.FieldByName('PAD_RESPONSAVEL').AsString;
         laResponsavelLKP.Caption := 'Responsável: '+FrmCOLIDataModuloArquivos.tbClientesPesquisaB.FieldByName('CLI_RESPONSAVEL').AsString;
      end;
   end;
end;

procedure TFrmCOLICaixa.FormKeyPress(Sender: TObject; var Key: Char);
begin
   ProxComponente(FrmCOLICaixa,Key);
end;

procedure TFrmCOLICaixa.bbCancelaBaixaClick(Sender: TObject);
begin
   if (not FrmCOLIDataModuloTransacoes.tbCaixa.FieldByName('CXA_VALORPAGO').IsNull) and
      (Mensagem('Deseja cancelar baixa ?',2) = idyes)                               then
   begin
      FrmCOLIDataModuloTransacoes.tbCaixa.Edit;
      With FrmCOLIDataModuloTransacoes.tbCaixa do
      begin
         FieldByName('CXA_VALORPAGO').Clear;
         FieldByName('CXA_DTPAGTO').Clear;
         FieldByName('CXA_DISCRIMINACAO').Clear;
      end;
      if bbGrava.Enabled then
         bbGrava.Setfocus;
   end;
end;

end.


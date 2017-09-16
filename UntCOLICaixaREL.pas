unit UntCOLICaixaREL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Qrctrls, quickrpt, ExtCtrls, DB, DBTables, ADODB;

type
  TFrmCOLICaixaREL = class(TForm)
    qrCaixa: TQuickRep;
    PageHeaderBand1: TQRBand;
    ColumnHeaderBand1: TQRBand;
    DetailBand1: TQRBand;
    SummaryBand1: TQRBand;
    qrlaTituloRelatorio: TQRLabel;
    qrNomeSistema: TQRLabel;
    qrlData: TQRLabel;
    qrsDataSys: TQRSysData;
    qrlPagina: TQRLabel;
    qrsNumPag: TQRSysData;
    qrtData: TQRLabel;
    qreHora: TQRExpr;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel1: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRlaCabPagto: TQRLabel;
    QRDBTBanco: TQRDBText;
    QRDBTCodPedidos: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBTDtPagto: TQRDBText;
    QRlaTotal: TQRLabel;
    QRlaDescTotal: TQRLabel;
    QRlaResponsavel: TQRLabel;
    DetailBand1Child: TQRChildBand;
    QRDBTDiscriminacao: TQRDBText;
    qeCaixa: TADOQuery;
    procedure qrCaixaBeforePrint(Sender: TCustomQuickRep;
      var PrintReport: Boolean);
    procedure DetailBand1BeforePrint(Sender: TQRCustomBand;
      var PrintBand: Boolean);
    procedure QRlaTotalPrint(sender: TObject; var Value: string);
    procedure QRlaResponsavelPrint(sender: TObject; var Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCOLICaixaREL: TFrmCOLICaixaREL;
  ureTotal: Currency;
  FlagJaPassou: Boolean;

implementation

uses UntCOLIDataModuloTransacoes, UntCOLIDadosRelCaixa,
  UntCOLIDataModuloArquivos;

{$R *.DFM}

procedure TFrmCOLICaixaREL.qrCaixaBeforePrint(Sender: TCustomQuickRep;
  var PrintReport: Boolean);
begin
   With FrmCOLIDadosRelCaixa do
   begin
      If not FlagJaPassou then
         qrlaTituloRelatorio.Caption := qrlaTituloRelatorio.Caption +
            '(' + meDtInicial.Text + ' a ' + meDtFinal.Text + ')';
      FlagJaPassou := True;
      QRlaCabPagto.Visible := rbTodos.Checked;
      QRDBTDtPagto.Visible := rbTodos.Checked;
   end;
   ureTotal := 0;
end;

procedure TFrmCOLICaixaREL.DetailBand1BeforePrint(Sender: TQRCustomBand;
  var PrintBand: Boolean);
begin
   ureTotal := ureTotal + qeCaixa.FieldByName('CXA_VALORCOBRADO').AsCurrency;
end;

procedure TFrmCOLICaixaREL.QRlaTotalPrint(sender: TObject;
  var Value: string);
begin
   Value := FormatCurr('R$#,##0.00',ureTotal);
end;

procedure TFrmCOLICaixaREL.QRlaResponsavelPrint(sender: TObject;
  var Value: string);
begin
   if qeCaixa.FieldByName('CXA_TITULARCONTA').AsString <> '' then
      Value := qeCaixa.FieldByName('CXA_TITULARCONTA').AsString
   else
      Value := qeCaixa.FieldByName('RESPONSAVELLKP').AsString;
end;

{
            SELECT CXA_PEDIDOS,CXA_NUMEROCHEQUE,CXA_DESCRICAOBANCO,
            CXA_VALORCOBRADO,CXA_DTVENCTO,CXA_DTPAGTO,CXA_TITULARCONTA,
            CXA_CODCLIENTE,CXA_DISCRIMINACAO,CLI_RESPONSAVEL AS RESPONSAVELLKP
            FROM CAIXA,CLIENTES
            LEFT JOIN BANCOS ON ( CXA_CODIGOBANCO = BAN_CODIGO )
            WHERE ( CXA_CODCLIENTE = CLI_CODIGO )
            AND   ( CXA_DTVENCTO >= :DTINI )
            AND   ( CXA_DTVENCTO <= :DTFIM )
            @SOTITULOSABERTOS@
            UNION
            SELECT CXA_PEDIDOS,CXA_NUMEROCHEQUE,CXA_DESCRICAOBANCO,
            CXA_VALORCOBRADO,CXA_DTVENCTO,CXA_DTPAGTO,CXA_TITULARCONTA,
            CXA_CODCLIENTE,CXA_DISCRIMINACAO,NULL AS RESPONSAVELLKP
            FROM CAIXA
            WHERE ( CXA_CODCLIENTE IS NULL )
            AND   ( CXA_DTVENCTO >= :DTINI1 )
            AND   ( CXA_DTVENCTO <= :DTFIM1 )
            @SOTITULOSABERTOS@
            @ORDERBY@
}
end.

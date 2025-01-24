
// ==UserScript==
// @name         liberacao
// @namespace    http://tampermonkey.net/
// @version      2024-03-20
// @description  try to take over the world!
// @author       You
// @match        https://soldasul.sankhyacloud.com.br/mge/LiberacaoLimites.xhtml5*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=sankhyacloud.com.br
// ==/UserScript==


(() => {
  "use strict";
  Notification.requestPermission().then((result) => {
    console.log(result);
  });
  setInterval(()=> {
let results = await fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=DatasetSP.loadRecords&application=LiberacaoLimites&outputType=json&preventTransform=false", {
  "headers": {
    "accept": "application/json, text/plain, */*",
    "accept-language": "en-US,en;q=0.9",
    "content-type": "application/json; charset=UTF-8",
    "sec-ch-ua": "\"Not(A:Brand\";v=\"24\", \"Chromium\";v=\"122\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "\"Linux\"",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin"
  },
  "referrer": "https://soldasul.sankhyacloud.com.br/mge/LiberacaoLimites.xhtml5",
  "referrerPolicy": "strict-origin-when-cross-origin",
  "body": "{\"serviceName\":\"DatasetSP.loadRecords\",\"requestBody\":{\"dataSetID\":\"001\",\"entityName\":\"ViewLiberacaoLimite\",\"standAlone\":true,\"fields\":[\"VLRLIBERADO\",\"NUCHAVE\",\"NUNOTA\",\"EVENTO\",\"ViewEventoLiberacao.DESCRICAO\",\"CODUSUSOLICIT\",\"Solicitante.NOMEUSU\",\"PERCLIMITE\",\"PERCSOLIC\",\"VLRLIMITE\",\"VLRATUAL\",\"DHSOLICIT\",\"CODUSULIB\",\"Usuario.NOMEUSU\",\"DHLIB\",\"PERCANTERIOR\",\"VLRANTERIOR\",\"SEQUENCIA\",\"OBSERVACAO\",\"OBSLIB\",\"CODPARC\",\"Parceiro.NOMEPARC\",\"CODEMP\",\"Empresa.NOMEFANTASIA\",\"CODVEND\",\"Vendedor.APELIDO\",\"OBSCOMPL\",\"CODPARCTRANSP\",\"Transportadora.NOMEPARC\",\"DTNEG\",\"CODTIPOPER\",\"TipoOperacao.DESCROPER\",\"VLRNOTA\",\"DTVENC\",\"REPROVADO\",\"CODNAT\",\"Natureza.DESCRNAT\",\"CODCENCUS\",\"CentroResultado.DESCRCENCUS\",\"CODPROJ\",\"Projeto.IDENTIFICACAO\",\"TOTALDESCONTONOTA\",\"NURNG\",\"TABELA\",\"VLRTOTAL\",\"NULBO\",\"SUPLEMENTO\",\"TRANSF\",\"VLRDESDOB\",\"DHTIPOPER\",\"STATUSNOTA\",\"SEQCASCATA\",\"ORDEM\",\"NUCLL\",\"DTPREVENT\",\"PRECOLIQUIDO\",\"AD_SOMAPENDENTE\",\"AD_MAIORATRASO\",\"Parceiro.CODCID\",\"Parceiro.Cidade.NOMECID\",\"Parceiro.ComplementoParc.CODCIDENTREGA\",\"Parceiro.ComplementoParc.Cidade.NOMECID\"],\"tryJoinedFields\":true,\"parallelLoader\":true,\"crudListener\":\"br.com.sankhya.modelcore.crudlisteners.LiberacaoLimitesCrudListener\",\"criteria\":{\"expression\":\"((this.CODUSULIB = 0 OR this.CODUSULIB = ? OR this.CODUSULIB IN ( SELECT CODUSU FROM TSISUPL WHERE CODUSUSUPL = ? AND DTINICIO <= ? AND ( DTFIM IS NULL OR DTFIM >= ?))) AND (this.DHLIB IS NULL OR (ABS(this.VLRLIBERADO) > 0 AND ABS(this.VLRLIBERADO) < ABS(this.VLRATUAL))) AND this.DHSOLICIT >= ? AND onlydate(this.DHSOLICIT) <= ? AND this.EVENTO <> 24 AND this.EVENTO IN ( SELECT EVENTO FROM TSILIM LIM WHERE (( LIM.CODUSU = ? OR LIM.CODUSU IN ( SELECT CODUSU FROM TSISUPL WHERE TSISUPL.CODUSUSUPL = ? AND TSISUPL.DTINICIO <= ? AND (TSISUPL.DTFIM IS NULL OR TSISUPL.DTFIM >= ? ))) AND LIM.CODGRU = 0) OR (LIM.CODUSU = 0 AND (LIM.CODGRU = ? OR LIM.CODGRU IN ( SELECT U.CODGRUPO FROM TSISUPL S, TSIUSU U WHERE  S.CODUSUSUPL = ? AND S.DTINICIO <= ? AND (S.DTFIM IS NULL OR S.DTFIM >= ?) AND S.CODUSU = U.CODUSU)))))\",\"parameters\":[{\"type\":\"N\",\"value\":6},{\"type\":\"N\",\"value\":6},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"D\",\"value\":\"15/01/2025\"},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"N\",\"value\":6},{\"type\":\"N\",\"value\":6},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"N\",\"value\":6},{\"type\":\"N\",\"value\":6},{\"type\":\"D\",\"value\":\"22/01/2025\"},{\"type\":\"D\",\"value\":\"22/01/2025\"}]},\"txProperties\":{\"ConfigToSaveAt:br.com.sankhya.liberacao.limites.DynamicFilterAccordion\":\"eyJwcm9nQ3JpdGVyaWEiOltdfQ==\"},\"ignoreListenerMethods\":\"\",\"useDefaultRowsLimit\":true,\"clientEventList\":{\"clientEvent\":[{\"$\":\"br.com.sankhya.actionbutton.clientconfirm\"}]}}}",
  "method": "POST",
  "mode": "cors",
  "credentials": "include"
}).then(r=>r.json());
let total_resultados = results.then(r=>Number(r.responseBody.total));
if (total_resultados > 0) {
  new Notification("LIBERAÇÃO PENDENTE");
}
  }, 1000);
})();

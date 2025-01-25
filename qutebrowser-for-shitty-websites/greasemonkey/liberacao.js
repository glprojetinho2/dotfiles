// ==UserScript==
// @name         liberacao
// @namespace    http://tampermonkey.net/
// @version      2024-03-20
// @description  try to take over the world!
// @author       You
// @match        https://soldasul.sankhyacloud.com.br/mge/LiberacaoLimites.xhtml5*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=sankhyacloud.com.br
// ==/UserScript==

(()=>{
    "use strict";
    let codusulib = 6;
    Notification.requestPermission().then((result)=>{
        console.log(result);
    });
    new Notification("Serviço iniciado");
    let total_anterior = 0;
    setInterval(()=>{
        fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=DatasetSP.loadRecords&counter=48&application=LiberacaoLimites&outputType=json&preventTransform=false&mgeSession=-k30iBzyUEO8NzuR1wzGquJqQ1Zi3Kie7WhwFrf2&resourceID=br.com.sankhya.liberacao.limites&globalID=C67D84FFCE5FC2EF0A75EC15D08F8B13&allowConcurrentCalls=true&vss=2", {
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
            "referrer": "https://soldasul.sankhyacloud.com.br/mge/LiberacaoLimites.xhtml5?mgeSession=-k30iBzyUEO8NzuR1wzGquJqQ1Zi3Kie7WhwFrf2&resourceID=br.com.sankhya.liberacao.limites&html5ScreenChoice=S&changeLayout=S&isFirstAccess=N&betaApp=false&newLayoutSupChoice=S&legacyLayoutInUse=V2",
            "referrerPolicy": "strict-origin-when-cross-origin",
            "body": JSON.stringify({
                "serviceName": "DatasetSP.loadRecords",
                "requestBody": {
                    "dataSetID": "001",
                    "entityName": "ViewLiberacaoLimite",
                    "standAlone": true,
                    "fields": ["VLRLIBERADO"],
                    "tryJoinedFields": true,
                    "parallelLoader": true,
                    "crudListener": "br.com.sankhya.modelcore.crudlisteners.LiberacaoLimitesCrudListener",
                    "criteria": {
                        "expression": `((this.CODUSULIB = 0 OR this.CODUSULIB = ${codusulib} OR this.CODUSULIB IN ( SELECT CODUSU FROM TSISUPL WHERE CODUSUSUPL = ${codusulib} AND DTINICIO <= onlydate(sysdate) AND ( DTFIM IS NULL OR DTFIM >= onlydate(sysdate)))) AND (this.DHLIB IS NULL OR (ABS(this.VLRLIBERADO) > 0 AND ABS(this.VLRLIBERADO) < ABS(this.VLRATUAL))) AND this.DHSOLICIT >= onlydate(sysdate) AND onlydate(this.DHSOLICIT) <= onlydate(sysdate) AND this.EVENTO <> 24 AND this.EVENTO IN ( SELECT EVENTO FROM TSILIM LIM WHERE (( LIM.CODUSU = ${codusulib} OR LIM.CODUSU IN ( SELECT CODUSU FROM TSISUPL WHERE TSISUPL.CODUSUSUPL = ${codusulib} AND TSISUPL.DTINICIO <= onlydate(sysdate) AND (TSISUPL.DTFIM IS NULL OR TSISUPL.DTFIM >= onlydate(sysdate) ))) AND LIM.CODGRU = 0) OR (LIM.CODUSU = 0 AND (LIM.CODGRU = ${codusulib} OR LIM.CODGRU IN ( SELECT U.CODGRUPO FROM TSISUPL S, TSIUSU U WHERE  S.CODUSUSUPL = ${codusulib} AND S.DTINICIO <= onlydate(sysdate) AND (S.DTFIM IS NULL OR S.DTFIM >= onlydate(sysdate)) AND S.CODUSU = U.CODUSU)))))`,
                        "parameters": [{
                            "type": "N",
                            "value": 0
                        }]
                    },
                    "txProperties": {
                        "ConfigToSaveAt:br.com.sankhya.liberacao.limites.DynamicFilterAccordion": "eyJwcm9nQ3JpdGVyaWEiOltdfQ=="
                    },
                    "ignoreListenerMethods": "",
                    "useDefaultRowsLimit": true,
                    "clientEventList": {
                        "clientEvent": [{
                            "$": "br.com.sankhya.actionbutton.clientconfirm"
                        }]
                    }
                }
            }),
            "method": "POST",
            "mode": "cors",
            "credentials": "include"
        }).then(r=>r.json()).then(results=>{
            let total_resultados = Number(results.responseBody.total);
            if (total_resultados > total_anterior) {
                new Notification("LIBERAÇÃO PENDENTE");
            }
            total_anterior = total_resultados
        }
        );

    }
    , 7000);

}
)();

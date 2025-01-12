// ==UserScript==
// @name         sankhyasul
// @namespace    http://tampermonkey.net/
// @version      2024-03-20
// @description  try to take over the world!
// @author       You
// @require      https://code.jquery.com/jquery-3.6.0.min.js
// @require      https://unpkg.com/hotkeys-js/dist/hotkeys.min.js
// @require      https://raw.githubusercontent.com/wansleynery/SankhyaJX/main/jx.js
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// @require      https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js
// @match        https://soldasul.sankhyacloud.com.br/mge*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=sankhyacloud.com.br
// @grant        none
// ==/UserScript==
/* globals jQuery, $, waitForKeyElements */

"use strict";
const $j = jQuery.noConflict();

const port = 7777;
const configEndpoint = `http://localhost:${port}/config`;

function getCookie(document, cname) {
    var name = cname + "=";
    var ca = document.cookie.split(";");
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == " ") {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}
/**
   * Retorna o JSESSIONID da licença. Note que uma tela com a licença deve estar aberta.
   * Por exemplo, se tu queres a licença mgecom, um iframe (tela) com o atributo src
   * que comece com /mgecom/ deve existir no html da página.
   */
function getLicense(license) {
    let document =
        $j(`iframe[src^='/${license}/']`).get(0).contentWindow.document;
    return getCookie(document, "JSESSIONID");
}

async function sendAllLicenses() {
    const availableLicenses = ["mge", "mgecom", "mgefin"];
    let configObj = {};
    for (let license of availableLicenses) {
        try {
            configObj[license] = getLicense(license);
        } catch (e) {
            console.log(`Sem ${license}`);
        }
    }
    await fetch(configEndpoint, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(configObj),
    });
    const licensesServer = await fetch(configEndpoint, { method: "POST" }).then(
        (r) => r.json()
    );
    console.log(`Client: ${JSON.stringify(configObj, null, 2)}`);
    console.log(`Server: ${JSON.stringify(licensesServer, null, 2)}`);
    return configObj;
}
let prevIframeCount = 0;
setInterval(async () => {
    const iframeCount = $j("iframe").get().length;
    if (iframeCount !== prevIframeCount) {
        console.log(prevIframeCount, iframeCount);
        prevIframeCount = iframeCount;
        await sendAllLicenses();
    }
}, 2000);
function resetCentral() {
    $j("div.AppItem-center:contains('Central de Vendas') + .icon-close")
        .click();
    setTimeout(() => {
        top.workspace.openAppActivity("br.com.sankhya.com.mov.CentralNotas", {
            NUNOTA: "2334",
        });
    }, 1000);
}
hotkeys("ctrl+shift+s", async function (event, handler) {
    await sendAllLicenses();
    alert(`Licenças atualizadas!`);
});
hotkeys("ctrl+,", resetCentral);

function startup() {
    const listaResourceIds = [
        "br.com.sankhya.mgecom.mov.selecaodedocumento",
        "br.com.sankhya.com.cons.consultaProdutos",
        "br.com.sankhya.core.cad.produtos",
        "br.com.sankhya.fila.de.conferencia",
        "br.com.sankhya.cac.ImportacaoXMLNota",
        "br.com.sankhya.core.cad.parceiros",
        "br.com.sankhya.menu.adicional.AD_TGHSQL"
    ];

    let t = 1;
    resetCentral()
    for (const resourceId of listaResourceIds) {
        setTimeout(() => {
            JX.abrirPagina(resourceId);
        }, 1000 * t);
        t = t + 1;
    }
}
function getJSessionId() {
    var jsId = document.cookie.match(/JSESSIONID=[^;]+/);
    if (jsId != null) {
        if (jsId instanceof Array)
            jsId = jsId[0].substring(11);
        else
            jsId = jsId.substring(11);
    }
    return jsId;
}
function msgWrapper(codUsu, msg) {
    return fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=AvisoSistemaSP.enviarMensagem&counter=2&application=workspace", {
        "headers": {
            "accept": "*/*",
            "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
            "content-type": "text/xml; charset=UTF-8",
            "sec-ch-ua": "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Linux\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin"
        },
        "referrer": "https://soldasul.sankhyacloud.com.br/mge/system.jsp",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": `<serviceRequest serviceName=\"AvisoSistemaSP.enviarMensagem\"><requestBody><mensagem><destinatario tipo=\"usuario\" id=\"${codUsu}\"/><conteudo><![CDATA[${msg}]]></conteudo></mensagem><clientEventList/></requestBody></serviceRequest>`,
        "method": "POST",
        "mode": "cors",
        "credentials": "include"
    });
}
const nuGdgInput = jQuery(`<input type="text" id="atualizar" placeholder="Código da tela"><br>`)
waitForKeyElements("body > div.gwt-PopupPanel.ContextMenuPopup > div", ()=>{
    console.log("waitForKeyElements")
    jQuery("body > div.gwt-PopupPanel.ContextMenuPopup > div").prepend(nuGdgInput);
    jQuery("#atualizar").on('keydown', async function (event) {
        if (event.key === 'Enter' && document.getElementById('atualizar').value != '') {
            event.preventDefault();
            console.log("event.target.value")
            console.log(event.target.value);
            await upload(Number(event.target.value)).then((x)=>console.log(x));
        }
    });})

async function upload(nuGdg) {
    const config = {
        JSESSIONID: getJSessionId(),
        SANKHYACLOUD_URL: "http://soldasul.sankhyacloud.com.br"
    }
    console.log(config)
    const fileText = await fetch("http://127.0.0.1:1111/componente.jsp").then((r) => r.text());
    const zip = new JSZip();
    zip.file("componente.jsp", fileText);
    const zippedFile = await zip.generateAsync({
        type: "blob"
    });
    const form = new FormData();
    form.append("arquivo", zippedFile, "jsp.zip");
    const response = await fetch("https://soldasul.sankhyacloud.com.br/mge/sessionUpload.mge?salvar=S", {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
            "cache-control": "max-age=0",
            "sec-ch-ua": "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Linux\"",
            "sec-fetch-dest": "document",
            "sec-fetch-mode": "navigate",
            "sec-fetch-site": "same-origin",
            "sec-fetch-user": "?1",
            "upgrade-insecure-requests": "1"
        },
        "referrer": "https://soldasul.sankhyacloud.com.br/mge/sessionUpload.mge?sessionkey=ARQUIVO_COMPONENTE",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": form,
        "method": "POST",
        "mode": "cors",
        "credentials": "include"
    });
    const params = new URLSearchParams({
        "serviceName": "DynaGadgetBuilderSP.atualizarComponente",
        "counter": "27",
        "application": "GadgetBuilder",
        "outputType": "json",
        "preventTransform": "false",
        "mgesession": `${config.JSESSIONID}`,
        "resourceID": "br.com.sankhya.core.cfg.GadgetBuilder",
        "globalID": "C28F7B8257A846CA48BF306E8A89EB4F",
        "vss": "1",
    }).toString();
    await fetch(`${config.SANKHYACLOUD_URL}/mge/service.sbr?${params}`, {
        method: 'POST',
        headers: {
            "Accept": "application/json, text/plain, */*",
            "Accept-Language": "pt-BR,ptq=0.9,en-USq=0.8,enq=0.7",
            "Connection": "keep-alive",
            "Content-Type": "application/json charset=UTF-8",
            "Cookie": `JSESSIONID=${config.JSESSIONID}`,
            "Origin": `${config.SANKHYACLOUD_URL}`,
            "Referer": `${config.SANKHYACLOUD_URL}/mge/GadgetBuilder.xhtml5?mode=U&mgesession=${config.JSESSIONID}&resourceID=br.com.sankhya.core.cfg.GadgetBuilder&html5ScreenChoice=S&changeLayout=S&isFirstAccess=N&betaApp=false&newLayoutSupChoice=S`,
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
            "User-Agent": "Mozilla/5.0 (X11 Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36",
            "sec-ch-ua": '"Not)ABrand"v="99", "Google Chrome"v="127", "Chromium"v="127"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": '"Linux"',
        },
        body: JSON.stringify({
            "serviceName": "DynaGadgetBuilderSP.atualizarComponente",
            "requestBody": {
                "param": {
                    "chave": "ARQUIVO_COMPONENTE",
                    "nugdg": nuGdg,
                },
            },
        })
    });
}
async function exq(query) {
    return fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=DbExplorerSP.executeQuery&counter=3&application=DbExplorer&outputType=json&preventTransform=false&mgeSession=t0h-k3Mw5jfl6gxo0Fy8cjAzEMI9vHVOvtF0GRUP&resourceID=br.com.sankhya.DbExplorer&globalID=EAC1199525E77D24C62681463E3F8236&vss=2", {
        "headers": {
            "accept": "application/json, text/plain, */*",
            "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
            "content-type": "application/json; charset=UTF-8",
            "sec-ch-ua": "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Linux\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin"
        },
        "referrer": "https://soldasul.sankhyacloud.com.br/mge/DbExplorer.xhtml5?mgeSession=t0h-k3Mw5jfl6gxo0Fy8cjAzEMI9vHVOvtF0GRUP&resourceID=br.com.sankhya.DbExplorer&html5ScreenChoice=S&isExt=N",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": `{\"serviceName\":\"DbExplorerSP.executeQuery\",\"requestBody\":{\"sql\":\"${query}\"}}`,
        "method": "POST",
        "mode": "cors",
        "credentials": "include"
    }).then(r=>r.json()).then(r=>r.responseBody.rows);
}
function getDocumentDataWrapper(el){
    return fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=ImpressaoNotasSP.imprimeDocumentos&counter=33&application=SelecaoDocumento&outputType=json&preventTransform=false&mgeSession=t0h-k3Mw5jfl6gxo0Fy8cjAzEMI9vHVOvtF0GRUP&resourceID=br.com.sankhya.mgecom.mov.selecaodedocumento&globalID=ACE108B60DA9DCD41A091D72FF2140FC&vss=1", {
        "headers": {
            "accept": "application/json, text/plain, */*",
            "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
            "content-type": "application/json; charset=UTF-8",
            "sec-ch-ua": "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\"",
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "\"Linux\"",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin"
        },
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": `{\"serviceName\":\"ImpressaoNotasSP.imprimeDocumentos\",\"requestBody\":{\"notas\":{\"pedidoWeb\":false,\"portalCaixa\":false,\"gerarpdf\":true,\"nota\":[{\"nuNota\":${el},\"tipoImp\":1,\"impressaoDanfeSimplicado\":false}]},\"clientEventList\":{\"clientEvent\":[{\"$\":\"br.com.sankhya.comercial.recalcula.pis.cofins\"},{\"$\":\"br.com.sankhya.financeiro.alert.mudanca.titulo.baixa\"},{\"$\":\"br.com.sankhya.actionbutton.clientconfirm\"},{\"$\":\"br.com.sankhya.mgecom.enviar.recebimento.wms.sncm\"},{\"$\":\"comercial.status.nfe.situacao.diferente\"},{\"$\":\"br.com.sankhya.mgecom.compra.SolicitacaoComprador\"},{\"$\":\"br.com.sankhya.mgecom.expedicao.SolicitarUsuarioConferente\"},{\"$\":\"br.com.sankhya.mgecom.nota.adicional.SolicitarUsuarioGerente\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.nfeAcimaTolerancia\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.processo.wms.andamento\"},{\"$\":\"br.com.sankhya.mgecom.msg.nao.possui.itens.pendentes\"},{\"$\":\"br.com.sankhya.mgecomercial.event.baixaPortal\"},{\"$\":\"br.com.sankhya.mgecom.valida.ChaveNFeCompraTerceiros\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.validarPedidos\"},{\"$\":\"br.com.sankhya.mgecom.gera.lote.xmlRejeitado\"},{\"$\":\"br.com.sankhya.comercial.solicitaContingencia\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.notas.remessa\"},{\"$\":\"br.com.sankhya.mgecomercial.event.compensacao.credito.debito\"},{\"$\":\"br.com.sankhya.modelcore.comercial.cancela.nota.devolucao.wms\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.selecaoDocas\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.cortePedidos\"},{\"$\":\"br.com.sankhya.modelcore.comercial.cancela.nfce.baixa.caixa.fechado\"},{\"$\":\"br.com.utiliza.dtneg.servidor\"}]}}}`,
        "method": "POST",
        "mode": "cors",
        "credentials": "include"
    }).then(r=>r.json()).then(r=>{
        if (r.responseBody.status === "0"){
            throw new Error("PDF não gerado.")
        }
    })
}
// ${nuNotas.map(nuNota=>`{\"nuNota\":${nuNota},\"tipoImp\":1,\"impressaoDanfeSimplicado\":false}`).join(", ")}
if (window.location.pathname.startsWith("/mgecom/SelecaoDocumento")){
    jQuery("body").on('click', async()=>{
        const nuPedidos = jQuery('[col-id="NUNOTA"]').map((a,b,c)=>jQuery(b).text()).get().filter(Number)
        const nuNotas = await fetch("https://soldasul.sankhyacloud.com.br/mge/service.sbr?serviceName=DatasetSP.loadRecords&counter=144&application=SelecaoDocumento&outputType=json&preventTransform=false&mgeSession=dxDA35p3BxnOvu3p_MNaSMznMLpAw8Fi8BaBrTec&resourceID=br.com.sankhya.mgecom.mov.selecaodedocumento&globalID=0DBEC432033BBEDEB61214BC66CD9DF9&allowConcurrentCalls=true&vss=1", {
            "headers": {
                "accept": "application/json, text/plain, */*",
                "accept-language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
                "content-type": "application/json; charset=UTF-8",
                "sec-ch-ua": "\"Not)A;Brand\";v=\"99\", \"Google Chrome\";v=\"127\", \"Chromium\";v=\"127\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-platform": "\"Linux\"",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-origin"
            },
            "referrer": "https://soldasul.sankhyacloud.com.br/mgecom/SelecaoDocumento.xhtml5?mgeSession=dxDA35p3BxnOvu3p_MNaSMznMLpAw8Fi8BaBrTec&resourceID=br.com.sankhya.mgecom.mov.selecaodedocumento&modoSelecao=PV&html5ScreenChoice=S&changeLayout=S&isFirstAccess=N&betaApp=false&newLayoutSupChoice=S",
            "referrerPolicy": "strict-origin-when-cross-origin",
            "body": `{\"serviceName\":\"DatasetSP.loadRecords\",\"requestBody\":{\"dataSetID\":\"03D\",\"entityName\":\"CompraVendavariosPedido\",\"standAlone\":false,\"fields\":[\"NUNOTA\"],\"tryJoinedFields\":true,\"parallelLoader\":true,\"criteria\":{\"expression\":\"(this.NUNOTAORIG in (${nuPedidos.join(",")}) AND this.NUNOTA <> this.NUNOTAORIG)\",\"parameters\":[]},\"ignoreListenerMethods\":\"\",\"useDefaultRowsLimit\":true,\"clientEventList\":{\"clientEvent\":[{\"$\":\"br.com.sankhya.comercial.recalcula.pis.cofins\"},{\"$\":\"br.com.sankhya.financeiro.alert.mudanca.titulo.baixa\"},{\"$\":\"br.com.sankhya.actionbutton.clientconfirm\"},{\"$\":\"br.com.sankhya.mgecom.enviar.recebimento.wms.sncm\"},{\"$\":\"comercial.status.nfe.situacao.diferente\"},{\"$\":\"br.com.sankhya.mgecom.compra.SolicitacaoComprador\"},{\"$\":\"br.com.sankhya.mgecom.expedicao.SolicitarUsuarioConferente\"},{\"$\":\"br.com.sankhya.mgecom.nota.adicional.SolicitarUsuarioGerente\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.nfeAcimaTolerancia\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.processo.wms.andamento\"},{\"$\":\"br.com.sankhya.mgecom.msg.nao.possui.itens.pendentes\"},{\"$\":\"br.com.sankhya.mgecomercial.event.baixaPortal\"},{\"$\":\"br.com.sankhya.mgecom.valida.ChaveNFeCompraTerceiros\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.validarPedidos\"},{\"$\":\"br.com.sankhya.mgecom.gera.lote.xmlRejeitado\"},{\"$\":\"br.com.sankhya.comercial.solicitaContingencia\"},{\"$\":\"br.com.sankhya.mgecom.cancelamento.notas.remessa\"},{\"$\":\"br.com.sankhya.mgecomercial.event.compensacao.credito.debito\"},{\"$\":\"br.com.sankhya.modelcore.comercial.cancela.nota.devolucao.wms\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.selecaoDocas\"},{\"$\":\"br.com.sankhya.mgewms.expedicao.cortePedidos\"},{\"$\":\"br.com.sankhya.modelcore.comercial.cancela.nfce.baixa.caixa.fechado\"},{\"$\":\"br.com.utiliza.dtneg.servidor\"}]}}}`,
            "method": "POST",
            "mode": "cors",
            "credentials": "include"
        }).then(r=>r.json()).then(r=>r.responseBody.result);
        const noDuplicates = [...new Set(nuNotas.flat()), ...new Set(nuPedidos.flat())].flat()
        console.log(noDuplicates)
        const sql = `
SELECT NUNOTA
FROM TGFPDF
WHERE NUNOTA in (${noDuplicates.filter(v=>v.trim().length>0).join(", ")})
    `
    const result = await exq(sql)
    const alreadyWithPDF = result.flat().filter(Number)
    const notWithPDF = noDuplicates.filter((a,v)=>!alreadyWithPDF.includes(Number(a)))

    console.log(notWithPDF)
        for (const el of notWithPDF) {
            await getDocumentDataWrapper(el)
        }

    }
                     )
}
if (window.location.pathname.startsWith("/mgecom/SelecaoDocumento")){
    jQuery("body").on("click scroll mousemove",()=>{
        jQuery("div[col-id='PENDENTE']:contains('Sim')").parent().css('background-color','#eb4034')
        jQuery("div[col-id='AD_PARCIAL']:contains('S')").parent().css('background-color','#ebbd34')
    })
}
if (window.location.pathname.startsWith("/mgecom/CentralNotas")){
    waitForKeyElements('.top-bar.high-contrast-panel', ()=>{
        console.log("painel confirmado")
        jQuery("body").on('click', '.top-bar.high-contrast-panel', async()=>{
            const nuNotas = jQuery('[sk-field-name="NUNOTA"] input').map((a,v)=>jQuery(v).val()).get()
            setTimeout(async ()=>{
                const sql = `
SELECT NUNOTA
FROM TGFPDF
WHERE NUNOTA in (${nuNotas.filter(v=>v.trim().length>0).join(",")})
    `
                    await exq(sql).then(async result=>{
                        const alreadyWithPDF = nuNotas.flat().filter(Number).map(Number)
                        for (const nuNota of nuNotas){
                            try{
                                if (!alreadyWithPDF.includes(Number(nuNota))){
                                    await getDocumentDataWrapper(nuNota)
                                    console.log(nuNota)
                                    console.log(alreadyWithPDF)
                                    console.log(!alreadyWithPDF.includes(Number(nuNota)))
                                } else {
                                    console.log(`Nota já tinha pdf: ${nuNota}`)
                                }
                            } catch (e){
                                console.log(`Nota já tinha pdf: ${nuNota}`)
                            }
                        }
                    })

            },3000)
        })
    })
}

hotkeys("ctrl+shift+,", startup);
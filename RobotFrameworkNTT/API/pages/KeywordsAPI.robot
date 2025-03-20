*** Settings ***
Library    FakerLibrary
Library    RequestsLibrary
Library    String
Library    Collections

*** Variables ***
${BASE_URL}     https://serverest.dev
${HEADERS}      Create Dictionary    accept=application/json    Content-Type=application/json
${PASSWORD}     123456

*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String  length=4  chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case    ${palavra_aleatoria}
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatoria}@emailteste.com
    Log To Console  Email gerado: ${EMAIL_TESTE}

Cadastrar o usuário criado na ServerRest
    [Arguments]  ${email}  ${status_code_desejado}
    ${body}    Create Dictionary    
    ...    nome=Adrielson Pinheiro    
    ...    email=${email}    
    ...    password=${PASSWORD}    
    ...    administrador=true
    Log  ${body}

    Criar Sessão na ServerRest

    ${resposta}    POST On Session    
    ...    alias=ServerRest
    ...    url=/usuarios
    ...    json=${body}
    ...    expected_status=${status_code_desejado}

    Log   ${resposta.json()}

    IF    ${resposta.status_code} == 201
          Set Test Variable    ${ID_USUARIO}  ${resposta.json()["_id"]}          
    END
       
    Set Test Variable    ${CONTEXT}     ${resposta.json()}

Criar Sessão na ServerRest
    ${headers}  Create Dictionary     accept=application/json    Content-Type=application/json
    Create Session    alias=ServerRest    url=${BASE_URL}    headers=${headers}

Autenticar Usuário na ServerRest
    [Arguments]    ${email} 
    ${body}    Create Dictionary    email=${email}    password=${PASSWORD}
    Criar Sessão na ServerRest
    ${resposta}    POST On Session    ServerRest    /login    json=${body}    expected_status=200
    Log    Resposta da API: ${resposta.json()}

    Run Keyword And Continue On Failure    Dictionary Should Contain Key    ${resposta.json()}    authorization
    ${TOKEN}    Set Variable    ${resposta.json()["authorization"]}
    Run Keyword If    "${TOKEN}" == "None"    Fail    "Token não foi retornado pela API. Verifique a autenticação."
    Set Test Variable    ${TOKEN}
    Log    Token obtido: ${TOKEN}

Conferir se o usuário foi cadastrado corretamente
    Log    ${CONTEXT}
    Dictionary Should Contain Item    ${CONTEXT}    message    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${CONTEXT}     _id

Repetir o cadastro do usuário
    Cadastrar o usuário criado na ServerRest    email=${EMAIL_TESTE}   status_code_desejado=400

Verificar se a API não permitiu o cadastro repetido
    Dictionary Should Contain Item    ${CONTEXT}    message    Este email já está sendo usado

Consultar os dados do novo usuário
    ${resposta_consulta}  GET On Session    alias=ServerRest  url=/usuarios/${ID_USUARIO}  expected_status=200
    Set Test Variable    ${RESP_CONSULTA}   ${resposta_consulta.json()} 

Conferir os dados retornados
    Log    ${RESP_CONSULTA}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    nome             Adrielson Pinheiro
    Dictionary Should Contain Item    ${RESP_CONSULTA}    email            ${EMAIL_TESTE}
    Dictionary Should Contain Item    ${RESP_CONSULTA}    password         123456
    Dictionary Should Contain Item    ${RESP_CONSULTA}    administrador    true
    Dictionary Should Contain Item    ${RESP_CONSULTA}    _id              ${ID_USUARIO}

Cadastrar Produto na ServerRest
    # Gerar dados aleatórios do produto
    ${nome}    FakerLibrary.Name
    ${preco}    Evaluate    random.randint(10, 500)    random
    ${descricao}    FakerLibrary.Word
    ${quantidade}    Evaluate    random.randint(1, 1000)    random

    # Criar um dicionário com os dados do produto
    ${DADOS_PRODUTO}    Create Dictionary
    ...    nome=${nome}
    ...    preco=${preco}
    ...    descricao=${descricao}
    ...    quantidade=${quantidade}
    Set Test Variable    ${DADOS_PRODUTO}

    # Definir headers com autenticação
    ${AUTH_HEADERS}    Create Dictionary
    ...    accept=application/json
    ...    Content-Type=application/json
    ...    Authorization=${TOKEN}

    Log    Headers: ${AUTH_HEADERS}

    # Fazer a requisição para criar o produto
    ${resposta}    POST On Session    ServerRest    /produtos    json=${DADOS_PRODUTO}    headers=${AUTH_HEADERS}    expected_status=201
    Log    Resposta da API: ${resposta.json()}

    # Capturar o ID do produto criado e armazená-lo
    ${json_resposta}    Evaluate    json.loads($resposta.text)    json
    ${ID_PRODUTO}    Set Variable    ${json_resposta["_id"]}
    Set Test Variable    ${ID_PRODUTO}


Consultar Produto Criado
    # Buscar o produto recém-criado usando o ID armazenado
    ${resposta}    GET On Session    ServerRest    /produtos/${ID_PRODUTO}    expected_status=200
    Log    Resposta da API: ${resposta.json()}

    # Capturar os dados do produto retornado
    ${produto}    Set Variable    ${resposta.json()}

    # Verificar se os dados do produto retornado batem com os cadastrados
    Dictionary Should Contain Item    ${produto}    _id    ${ID_PRODUTO}
    Dictionary Should Contain Item    ${produto}    nome    ${DADOS_PRODUTO}[nome]
    Dictionary Should Contain Item    ${produto}    preco    ${DADOS_PRODUTO}[preco]
    Dictionary Should Contain Item    ${produto}    descricao    ${DADOS_PRODUTO}[descricao]
    Dictionary Should Contain Item    ${produto}    quantidade    ${DADOS_PRODUTO}[quantidade]
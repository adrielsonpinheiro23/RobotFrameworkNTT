*** Settings ***
Library    FakerLibrary
Library    RequestsLibrary
Library    String
Library    Collections


*** Keywords ***
Criar um usuário novo
    ${palavra_aleatoria}    Generate Random String  length=4  chars=[LETTERS]
    ${palavra_aleatoria}    Convert To Lower Case    ${palavra_aleatoria}
    Set Test Variable    ${EMAIL_TESTE}    ${palavra_aleatoria}@emailteste.com
    Log To Console  Minha palavra aleatória: ${EMAIL_TESTE}

Cadastrar o usuário criado na ServerRest
    [Arguments]  ${email}  ${status_code_desejado}
    ${body}    Create Dictionary    
    ...    nome=Adrielson Pinheiro    
    ...    email=${email}    
    ...    password=123456    
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
    Create Session    alias=ServerRest    url=https://serverest.dev    headers=${headers}

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

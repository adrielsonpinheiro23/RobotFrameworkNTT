*** Settings ***
Library    Zoomba.GUILibrary
Library    FakerLibrary
Library    XML
Library    RequestsLibrary
Library    String
Library    Collections

*** Variables ***
${URL}                    https://front.serverest.dev/
${BASE_URL}               https://serverest.dev
${FORM_NOME}              //*[@id="nome"]
${FORM_EMAIL}             //*[@id="email"] 
${FORM_SENHA}             //*[@id="password"]
${BOTAO_CADASTRAR}        //*[@data-testid="cadastrar"]
${BOTAO_ENTRAR}           //*[@data-testid="entrar"]
${CHECKBOX_ADMIN}         //*[@id="administrador"]    
${BOTAO_LOGOUT}           //*[@data-testid="logout"]
${BARRA_PESQUISA}         //*[@data-testid="pesquisar"]
${BOTAO_PESQUISAR}        //*[@data-testid="botaoPesquisar"]
${LINK_DETALHES}          //*[@data-testid="product-detail-link"]
${ADICIONAR_NA_LISTA}     //*[@data-testid="adicionarNaLista"]

*** Keywords ***
I access serverest
    Open Browser      url=${URL}      browser=Chrome
    Maximize Browser Window

I close serverest
    Close Browser

I create a new user
    [Arguments]        ${isAdmin}=${False}
    Wait For And Click Element    ${BOTAO_CADASTRAR}
    ${name}           Name    
    ${email}          Email
    ${password}       Password
    Set Suite Variable    ${SavedLogin}    ${email}
    Set Suite Variable    ${SavedPassword}    ${password}   
    Wait For And Input Text    ${FORM_NOME}     ${name}
    Wait For And Input Text    ${FORM_EMAIL}    ${email}
    Wait For And Input Text    ${FORM_SENHA}    ${password}
    IF    ${isAdmin}
        Select Checkbox    ${CHECKBOX_ADMIN}        
    END
    Wait For And Click Element    ${BOTAO_CADASTRAR}
    Wait Until Page Contains    Cadastro realizado com sucesso    
    IF    ${isAdmin}
        Wait Until Page Contains    Bem Vindo
        Wait Until Page Contains    ${name}
        Wait Until Page Contains    Este é seu sistema para administrar seu ecommerce.
    ELSE
        Wait Until Page Contains    Produtos
    END
    Wait For And Click Element    ${BOTAO_LOGOUT}

I Login at the serverest Application
    Wait For And Input Text           ${FORM_EMAIL}      ${SavedLogin}
    Wait For And Input Text           ${FORM_SENHA}      ${SavedPassword}
    Wait For And Click Element        ${BOTAO_ENTRAR}

Non Admin User is At Landing Page
    Wait Until Page Contains    Produtos
    Wait Until Page Contains    Serverest Store

I search for ${PRODUCT} in search bar
    [Arguments]        ${PRODUCT}
    Wait For And Input Text    ${BARRA_PESQUISA}        ${PRODUCT} 
    Wait For And Click Element    ${BOTAO_PESQUISAR}
    Wait Until Page Contains    ${PRODUCT}


Check available products
    ${index}      Random Int    min=1    max=5
    Wait Until Element Is Visible     (//*[@class="card-title negrito"])[${index}]    
    ${PRODUCT}    Get Text    (//*[@class="card-title negrito"])[${index}]
    Log To Console    peguei esse produto 3: ${PRODUCT}
    RETURN        ${PRODUCT}


I click on Details
    Wait For And Click Element    ${LINK_DETALHES} 
    Wait Until Page Contains    Detalhes

Add the Item to the List    
    [Arguments]        ${PRODUCT}
    Log To Console    O produto é: ${PRODUCT} 
    Wait For And Click Element    ${ADICIONAR_NA_LISTA}
    Wait Until Page Contains      Lista de Compras
    Wait Until Page Contains      ${PRODUCT}

I Logout the application
    Wait For And Click Element    ${BOTAO_LOGOUT}



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

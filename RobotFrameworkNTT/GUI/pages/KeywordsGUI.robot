*** Settings ***
Library    Zoomba.GUILibrary
Library    FakerLibrary
Library    XML

*** Variables ***
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


*** Settings ***
Documentation       Testes automatizados para a API ServeRest
Resource          ../../resource/resource.resource
Test Setup        Criar e Autenticar um Usuario

*** Test Cases ***
TC1: Cadastrar um novo usuário com sucesso na ServerRest    
    Conferir se o usuário foi cadastrado corretamente

TC2: Cadastrar um usuário já existente
    Repetir o cadastro do usuário
    Verificar se a API não permitiu o cadastro repetido

TC3: Consultar os dados de um novo usuário
    Consultar os dados do novo usuário
    Conferir os dados retornados

TC4: Criar e Validar Produto na ServerRest
    Autenticar Usuário na ServerRest        email=${EMAIL_TESTE}
    Cadastrar Produto na ServerRest
    Consultar Produto Criado

*** Keywords ***
Criar e Autenticar um Usuario
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201
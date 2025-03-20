*** Settings ***
Documentation       Testes automatizados para a API ServeRest
Resource          ../../resource/resource.resource

*** Test Cases ***
TC1: Cadastrar um novo usuário com sucesso na ServerRest
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Conferir se o usuário foi cadastrado corretamente

TC2: Cadastrar um usuário já existente
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Repetir o cadastro do usuário
    Verificar se a API não permitiu o cadastro repetido

TC3: Consultar os dados de um novo usuário
    Criar um usuário novo
    Cadastrar o usuário criado na ServerRest    email=${EMAIL_TESTE}    status_code_desejado=201
    Consultar os dados do novo usuário
    Conferir os dados retornados

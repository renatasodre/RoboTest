*** Settings ***
Library     SeleniumLibrary


*** Variables ***
${URL}                          https://bugbank.netlify.app/#
${BROWSER}                      chrome
${BUTTON_REGISTRO}              xpath://button[@type='button' and contains(text(), 'Registrar')]
${INPUT_EMAIL}                  id:email
${INPUT_NOME}                   id:name
${INPUT_SENHA}                  id:password
${INPUT_CONFIRMACAO_SENHA}      id:passwordConfirmation
${LABEL_SALDO}                  id:toggleAddBalance
${BUTTON_CADASTRAR}             xpath://button[@type='submit' and contains(text(), 'Cadastrar')]
${OPÇÃO_VOLTAR_LOGIN}           id:btnBackButton


*** Test Cases ***
Cenário 1: Acessar Página De Registro
    [Documentation]    Acessa a página de registro do BugBank
    Abrir Home Do Site Do BugBank
    Clicar No Botão Registrar

Cenário 2: Formulário De Registro
    [Documentation]    Preenche o formulário de registro
    Preencher Campos

Cenário 3: Criar Conta Com Saldo
    [Documentation]    Cria uma conta com saldo
    Clicar No Botão De Saldo    ${TRUE}

Cenário 4: Cadastrar E Voltar Para A Página Home
    [Documentation]    Clica no botão de cadastrar e volta para a página home
    Clicar No Botão Cadastrar
    Voltar Ao Login
    Fechar Site


*** Keywords ***
Configurar Opções Do Navegador
    [Documentation]    Configura as opções do navegador Chrome
    ${options}    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Adiciona argumentos para o Chrome
    Call Method    ${options}    add_argument    --disable-extensions    # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications    # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Home Do Site Do BugBank
    [Documentation]    Abre o navegador na página de home do BugBank
    ${chrome_options}    Configurar Opções Do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Clicar No Botão Registrar
    [Documentation]    Clica no botão de registro
    Wait Until Page Contains Element    ${button_registro}    timeout=30s

    # Tenta clicar de diferentes formas
    Run Keyword And Ignore Error    Click Element    ${button_registro}
    Run Keyword And Ignore Error
    ...    Execute JavaScript
    ...    document.querySelector('button[type="button"]:contains("Registrar")').click()

Preencher Campos
    [Documentation]   Preenche os campos do formulário de registro
    Input Text        css:.card__register input[name='email']    rribeirosodre@gmail.com
    Input Text        css:.card__register input[name='name']    Renata Sodré
    Input Password    css:.card__register input[name='password']    eiAbA!#ZYxZ4$U
    Input Password    css:.card__register input[name='passwordConfirmation']    eiAbA!#ZYxZ4$U

    Execute JavaScript    arguments[0].value = 'rribeirosodre@gmail.com'    ARGUMENTS    ${input_email}
    Execute JavaScript    arguments[0].value = 'Renata Sodré'    ARGUMENTS               ${input_nome}
    Execute JavaScript    arguments[0].value = 'eiAbA!#ZYxZ4$U'    ARGUMENTS             ${input_senha}
    Execute JavaScript    arguments[0].value = 'eiAbA!#ZYxZ4$U'    ARGUMENTS             ${input_confirmacao_senha}

Clicar No Botão Cadastrar
    [Documentation]    Clica no botão de cadastrar
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    2s

    # Tenta clicar de várias formas
    Run Keyword And Ignore Error    Click Element    ${button_cadastrar}
    Execute JavaScript
    ...    var botao = document.querySelector('button[type="submit"]');
    ...    if (botao) {
    ...    botao.click();
    ...    }

Clicar No Botão De Saldo
    [Documentation]    Clica no toggle de saldo para criar conta com saldo
    [Arguments]    ${criar_com_saldo}=${FALSE}

    # Espera e verifica o estado do toggle
    Wait Until Page Contains Element    ${label_saldo}    timeout=30s
    Sleep    2s

    ${estado_atual}    Get Element Attribute    ${label_saldo}    class

    IF    ${criar_com_saldo} and 'ativo' not in '${estado_atual}'
        Click Element    ${label_saldo}
    END
    IF    not ${criar_com_saldo} and 'ativo' in '${estado_atual}'
        Click Element    ${label_saldo}
    END

Voltar Ao Login
    [Documentation]    Volta para a página de login
    Execute JavaScript    window.scrollTo(0, 0)
    Sleep    2s

    # Tenta clicar de várias formas
    Run Keyword And Ignore Error    Click Element    ${opção_voltar_login}
    Execute JavaScript
    ...    var botao = document.getElementById('btnBackButton');
    ...    if (botao) {
    ...    botao.click();
    ...    }

Fechar Site
    [Documentation]    Fecha o navegador
    Close Browser

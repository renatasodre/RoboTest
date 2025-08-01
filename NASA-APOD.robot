*** Settings ***
# APOD= Astronomy Picture of the Day
Library     SeleniumLibrary


*** Variables ***
${URL}          https://api.nasa.gov/planetary/apod?api_key=1A0YEWnyo5hf9ffAkaKvUbl6z24dXFgiFgXUNqhg
${BROWSER}      chrome
${API_KEY}      1A0YEWnyo5hf9ffAkaKvUbl6z24dXFgiFgXUNqhg


*** Test Cases ***
Cenário 1: Validar API NASA
    [Documentation]    Testa a API NASA APOD e valida a resposta.
    Abrir Site NASA
    Validar Resposta Do APOD

Cenário 2: Fechar Navegador
    [Documentation]    Fecha o navegador após a validação da API.
    Fechar Site


*** Keywords ***
Configurar Opções Do Navegador
    [Documentation]    Configura as opções do navegador Chrome para o teste.
    # Configura opções do Chrome
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver

    # Adiciona argumentos
    Call Method    ${options}    add_argument    --disable-extensions    # Desabilita extensões
    Call Method    ${options}    add_argument    --disable-popup-blocking    # Desabilita bloqueio de pop-ups
    Call Method    ${options}    add_argument    --disable-notifications    # Desabilita notificações
    Call Method    ${options}    add_argument    --no-sandbox    # Opções adicionais para melhor performance
    Call Method    ${options}    add_argument    --start-maximized    # Opções adicionais para melhor performance

    RETURN    ${options}

Abrir Site NASA
    [Documentation]    Abre o navegador na página de home da NASA APOD.
    ${chrome_options}=    Configurar Opções Do Navegador
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Validar Resposta Do APOD
    [Documentation]    Valida a resposta do endpoint APOD da NASA e exibe informações no console - usando urllib.
    ${response}=    Evaluate
    ...    json.loads(urllib.request.urlopen("${URL}").read().decode('utf-8'))
    ...    modules=urllib.request, json
    Should Contain    ${response}    title
    Should Contain    ${response}    explanation
    Should Contain    ${response}    url
    Log To Console    Título: ${response["title"]}
    Log To Console    Data: ${response["date"]}
    ${titulo_api}=    Set Variable    ${response["title"]}
    ${image_url}=    Set Variable    ${response["url"]}
    Go To    ${image_url}
    Sleep    15s
    RETURN    ${titulo_api}

Fechar Site
    [Documentation]    Fecha o navegador.
    Close Browser

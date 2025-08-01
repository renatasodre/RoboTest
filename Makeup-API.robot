*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     json


*** Variables ***
${BASE_URL}     https://makeup-api.herokuapp.com


*** Test Cases ***
Cenário 1: Buscar Produtos Da Marca
    [Documentation]    Busca produtos de uma marca específica e valida a resposta.
    ${marca}=    Set Variable    l'oreal
    ${produtos}=    Buscar Produtos Da Marca    ${marca}
    Log To Console    Produtos encontrados: ${produtos}
    Should Not Be Empty    ${produtos}

Cenário 2: Pesquisar Por Tag
    [Documentation]    Busca produtos com uma tag específica e valida a existência de produtos filtrados.
    ${produtos}=    Buscar Todos Os Produtos
    ${filtrados}=    Filtrar Produtos Por Tag    ${produtos}    Vegan
    Validar Existencia De Produtos Filtrados    ${filtrados}


*** Keywords ***
Buscar Produtos Da Marca
    [Documentation]    Busca produtos de uma marca específica.
    [Arguments]    ${marca}
    Create Session    api    ${BASE_URL}
    ${endpoint}=    Set Variable    /api/v1/products.json?brand=${marca}
    ${resposta}=    GET On Session    api    ${endpoint}
    Should Be Equal As Integers    ${resposta.status_code}    200
    ${produtos}=    Set Variable    ${resposta.json()}
    RETURN    ${produtos}

Buscar Todos Os Produtos
    [Documentation]    Busca todos os produtos disponíveis na API.
    Create Session    api    ${BASE_URL}
    ${endpoint}=    Set Variable    /api/v1/products.json
    ${resposta}=    GET On Session    api    ${endpoint}
    Should Be Equal As Integers    ${resposta.status_code}    200
    ${produtos}=    Set Variable    ${resposta.json()}
    RETURN    ${produtos}

Filtrar Produtos Por Tag
    [Documentation]    Filtra produtos por uma tag específica.
    [Arguments]    ${produtos}    ${tag}
    ${lista_filtrada}=    Create List
    FOR    ${produto}    IN    @{produtos}
        ${tags}=    Get From Dictionary    ${produto}    tag_list
        IF    '${tag}' in ${tags}
            Append To List    ${lista_filtrada}    ${produto}
        END
    END
    RETURN    ${lista_filtrada}

Validar Existencia De Produtos Filtrados
    [Documentation]    Valida se a lista filtrada contém produtos.
    [Arguments]    ${lista_filtrada}
    Should Be True    len(${lista_filtrada}) > 0
    Log Many    @{lista_filtrada}

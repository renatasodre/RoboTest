# 🤖 Testes Web Automatizados com Robot Framework 🤖

## ➡️ Descrição
Projeto pessoal de testes automatizados para diversos sítios web, desenvolvido com Robot Framework e Selenium Library.

## ➡️ Tecnologias
✔️ Python 3.12

✔️ UV (Python package manager)

✔️ Robot Framework 

✔️ Selenium Library

## ➡️ Configuração

### Clonar repositório:

```bash
git clone https://github.com/renatasodre/RoboTest.git
```

```bash
cd RoboTest.git
```

### ➡️ Preparar ambiente
```bash
uv venv
source .venv/bin/activate  # No Windows: .\.venv\Scripts\activate
```

### ➡️ Instalar dependências
```bash
uv add [dependency]
```

Selenium Library: 
```bash
uv add robotframework-seleniumlibrary
```

## ➡️ Executar Testes

```bash
uv run robot [file]
```

## ➡️ Projetos Testados

✔️  NASA APOD (Astronomy Picture of the Day)

✔️  Automation Demo Site

✔️  Bug Bank

✔️  Practice Form Demo QA

✔️ Orange HRM - Open Source HR Software


## ➡️ Observações

Gestão de Dependências com UV:
Este projeto utiliza UV para gestão de dependências, substituindo o tradicional pip e requirements.txt.

### Como funciona:

✔️ Utilizamos uv.toml ou pyproject.toml para definir dependências

✔️ Comando uv sync instala/atualiza todas as bibliotecas necessárias
uv sync [OPTIONS]

✔️ Processo mais rápido e eficiente comparado ao pip tradicional

## ➡️ Nota Pessoal
Projeto desenvolvido para aprimorar habilidades de teste automatizado e explorar diferentes sítios web.

## 🔗 Referência
https://docs.astral.sh/uv/reference/cli/
🤖 Testes Web Automatizados com Robot Framework 🤖

➡️ Descrição
Projeto pessoal de testes automatizados para diversos sítios web, desenvolvido com Robot Framework e Selenium Library.

➡️ Tecnologias
Python 3.12
UV (Python package manager)
Robot Framework
Selenium Library

➡️ Configuração

Clonar repositório

git clone https://github.com/renatasodre/robotselenium
cd robotselenium

➡️ Preparar ambiente

uv venv
source .venv/bin/activate  # No Windows: .\.venv\Scripts\activate

➡️ Instalar dependências

uv add [dependency]
Selenium Library: uv add robotframework-seleniumlibrary

➡️ Executar Testes

uv run robot [file]

➡️ Estrutura

ROBOTSELENIUM/
│
├── .cadence/
│   └── configs/
│
├── .idea/
│
├── .venv/
│
├── Resources/
│
├── logs/
│   └── log.html
│
├── screenshots/
│   └── selenium-screenshot-*.png
│
├── .python-version
│
├── form.robot
│
├── main.py
│
├── output.xml
│
├── pyproject.toml
│
├── README.md
│
├── report.html
│
├── teste1.robot
│
├── uv.lock
│
└── (outros arquivos)

➡️ Observações

Gestão de Dependências com UV:
Este projeto utiliza UV para gestão de dependências, substituindo o tradicional pip e requirements.txt.

Como funciona:

✔️Utilizamos uv.toml ou pyproject.toml para definir dependências

✔️Comando uv sync instala/atualiza todas as bibliotecas necessárias
uv sync [OPTIONS]

✔️Processo mais rápido e eficiente comparado ao pip tradicional

➡️ Nota Pessoal
Projeto desenvolvido para aprimorar habilidades de teste automatizado e explorar diferentes sítios web.

🔗 Referência
https://docs.astral.sh/uv/reference/cli/
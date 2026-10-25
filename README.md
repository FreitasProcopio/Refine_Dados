# Refina

**Refinaria de dados para desktop.** Um app de ETL visual em Python que leva planilhas e bases de milhões de linhas pelas camadas **Bronze → Prata → Ouro** sem estourar a memória do computador.

Os dados ficam num banco DuckDB local, em disco, e não na RAM. A interface só busca as linhas que estão na tela, e cada passo vira uma receita que pode rodar sozinha no Agendador de Tarefas do Windows.

## O que ele faz

| Camada | Função | Operações |
|---|---|---|
| 🟤 Bronze | Ingestão do dado bruto | Arquivos, pastas e links · escolha de abas/tabelas · cabeçalho em qualquer linha · arrastar e soltar |
| ⚪ Prata | Limpeza e tratamento | Deduplicação · nulos · tipagem · padronização de texto · merge (left, inner, full, cross) com diagnóstico das chaves · filtros |
| 🟡 Ouro | Consolidação | Agregações · colunas calculadas · seleção e renomeação de colunas · exportação para Excel, Parquet ou DuckDB |

Também tem uma tela de **Banco de dados** (conecta um `.duckdb`, cria tabelas, grava datasets e roda SQL) e uma de **Automação** (receitas, `.bat` de agendamento e geração de código Python).

## Fontes aceitas

- **Arquivos:** `.xlsx` `.xlsm` `.xlsb` `.xls` `.ods` `.csv` `.txt` `.parquet` `.json` · bancos SQLite e DuckDB
- **Links:** Google Planilhas, Google Drive, OneDrive/SharePoint, Dropbox, GitHub e qualquer `http(s)` com arquivo de dados
- **Rede:** pastas compartilhadas (`\\servidor\pasta`), copiadas para um cache local em blocos de 8 MB (até 4 em paralelo) e reaproveitadas enquanto não mudarem

## Como aguenta bases grandes

- Limite de memória automático de **40% da RAM** (entre 512 MB e 8 GB); o excedente é processado em disco pelo DuckDB.
- Leitor próprio de `.xlsx` que lê o XML **em fluxo**, linha a linha, com memória constante. Usa o `python-calamine` quando a aba cabe com folga.
- Grade de dados paginada sob demanda (blocos de 500 linhas). Busca e ordenação rodam no banco.
- Tarefas em segundo plano com barra de progresso e cancelamento.

## Instalação

Requer Python 3.10+ no Windows.

```bash
pip install -r etl_app/requirements.txt
python etl_app/app.py
```

Para gerar o executável (`dist/Refina/Refina.exe`):

```bat
etl_app\build.bat
```

## Automação

1. Monte o pipeline nas telas. Cada operação é gravada como um passo.
2. Em **Automação**, salve a receita (`receita.json`) e gere o `.bat`.
3. Aponte o Agendador de Tarefas do Windows para o `.bat`.

A receita também roda pela linha de comando:

```bash
python etl_app/app.py --run receita.json
# ou, compilado:
Refina.exe --run receita.json
```

Cada execução grava um `.log` ao lado da receita.

### Exportar como código Python

O botão **Gerar código Python** transforma o pipeline em scripts que rodam sem o app, só com Python e DuckDB:

```
BD.py             cria as tabelas da Bronze
etl_bronze.py     carrega os arquivos de origem
etl_prata.py      tratamentos e junções (SQL)
etl_ouro.py       consolidação e exportação para Parquet
executar_tudo.py  roda tudo em sequência
```

## Stack

PySide6 (Qt) · DuckDB · pandas · pyarrow · openpyxl · python-calamine · PyInstaller

## Experimente

Na tela de Upload, clique em **Dados de exemplo** para carregar duas tabelas fictícias (`clientes` e `pedidos`) e testar o merge, os filtros e as agregações.

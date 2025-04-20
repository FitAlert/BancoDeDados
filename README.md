# Sistema de Monitoramento de Provadores

Este projeto consiste em um sistema de monitoramento de provadores de lojas, com um banco de dados que armazena informações sobre usuários, lojas, sensores e provadores. O sistema foi projetado para monitorar a utilização dos provadores nas lojas, controlando o status dos sensores e registrando as entradas e saídas dos sensores.

## Tabelas do Banco de Dados

O banco de dados `provador` contém as seguintes tabelas:

1. **usuarios**  
   Armazena as informações dos usuários que serão cadastrados no site.

2. **enderecos**  
   Armazena os endereços das lojas.

3. **lojas**  
   Armazena as informações sobre as lojas, podendo uma loja ser matriz de muitas outras.

4. **sensores**  
   Armazena informações sobre sensores da FitAlert.

5. **provadores**  
   Armazena informações sobre os provadores nas lojas, incluindo o tipo de sessão (Masculino, Feminino, Unissex) e o sensor associado.

6. **registros**  
   Armazena os registros de entrada e saída de dados dos sensores.

## Relacionamentos e Regras de Negócio

- **1 Usuário** pode cadastrar várias lojas, mas cada loja pertence a **1 Usuário**.
- **1 Loja** pode ter várias lojas filiais (através da referência para `fkLojaMatriz`), mas cada loja pertence a uma **única Matriz**.
- **1 Loja** tem **1 Endereço**, e cada **Endereço** pertence a **uma única loja**.
- **1 Provador** pertence a **1 Loja**, mas **1 Loja** pode ter vários provadores.
- **1 Provador** está associado a **1 Sensor**, e **1 Sensor** só pode estar em um provador.
- O **status do Sensor** pode ser `Ativo`, `Inativo` ou `Em Manutenção`.
- **Registros** de sensores armazenam as entradas e saídas dos sensores, sendo **1 Sensor** responsável por vários registros.

## Scripts SQL

### Criação do Banco de Dados

```sql
CREATE DATABASE provador;
USE provador;

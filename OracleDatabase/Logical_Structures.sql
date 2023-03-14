/*
https://britodba.wordpress.com/2017/02/07/arquitetura-do-oracle-parte-1-estrutura-logica/

=========== Arquitetura do Oracle - Estrutura lógica ===========

A arquitetura do servidor do banco de dados Oracle consiste em três estrutura principais:
    - Memória;
    - Processo;
    - Armazenamento.

O banco de dados é composto tanto por estruturas físicas como lógicas. Como as estruturas físicas e lógicas
são separadas, o armazenamento físico de dados pode ser gerenciado sem afetar o acesso às estruturas lógicas
de armazenamento.



--- Estrutura Lógica ---

Basicamente essa arquitetura pe composta por quatro grandes componentes, que são as tablespaces, segmentos,
extensões e bloco de dados.


-- O que são Tablespaces? --

Tablespace é uma estrutura lógica do banco de dados Oracle para o armazenamento dos segmentos.

-Podem conter um ou mais datafiles associados a ela;
-Podem ser gerenciadas por dicionário ou localmente;
-Podem ser permanentes, temporárias ou de undo, entre outras características.

O Oracle possui tablespaces básicas quando um banco de dados é criado.

As tablespaces básicas são: USERS, SYSTEM, TEMP, UNDO E SYSAUX.

Tablespace USERS: Por padrão quando um usuário é criado sem ser especificado uma tablespace default, o Oracle
coloca como default o tablespace USERS, ou seja, se um usuário criar um objeto, tal como uma tabela ou um índice
sem especificar o tablespace, o Oracle criará no tablespace USERS.

Tablespace SYSTEM: O tablespace SYSTEM (tablespace de sistema) é onde o Oracle armazena todas as informações 
necessárias para o seu próprio gerenciamento, ou seja, é o mais crítico do banco de dados pois ele contém o
dicionário de dados.

Tablespace TEMP: O tablespace TEMP é onde o Oracle armazena todas as suas tabelas temporárias (CREATE
TEMPORARY TABLE). É o quadro em branco ou papel de rascunho do banco de dados.

O Oracle geralmente utiliza o tablespace temporário para operações de ordenação (SORT). Sua principal função é
auxiliar a memória do Oracle (SGA), em seu principal componente, o SORT_AREA_SIZE.

O Oracle não fará a operação de ordenação em memórias, para isso ele utiliza o tableaspace temporário.

Algumas operações que utilizam o tablespace TEMP são: CREATE INDEX, ANALYZE, SELECT DISTINCT, ORDER BY, UNION,
INTERSECT, MINUS, SORT-MERGE JOIN, ETC.

Tablespace UNDO: Todos os bancos de dados Oracle precisam de um local para armazenar informações a desfazer.
O tablespace UNDO possui a capacidade de recuperar transações incompletas ou abortadas.

Um segmento undo é usado para salvar o valor antigo quando um processo altera dados de um banco de dados. Ele
armazena a localização dos dados e também os dados da forma como se encontravam antes da modificação.

Tablespace SYSAUX: Este tablespace auxiliar não existe nas versões anteriores ao Oracle 10g e foi criado
especialmente para aliviar o tablespace SYSTEM de segmentos associados a algumas aplicações do próprio banco de
dados como o Oracle ultra search, Oracle Text e até mesmo segmentos relacionados ao funcionamento do OEM etc.

Como resultado da criação desse tablespace, alguns gargalos de I/O frequentemente associados ao tablespace 
SYSTEM foram reduzidos ou eliminados.


-- O que são segmentos? --

Um 

*/
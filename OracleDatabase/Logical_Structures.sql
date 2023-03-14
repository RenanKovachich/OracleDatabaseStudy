/*
https://britodba.wordpress.com/2017/02/07/arquitetura-do-oracle-parte-1-estrutura-logica/
https://britodba.wordpress.com/2017/02/14/arquitetura-do-oracle-parte-2-estrutura-fisica/

=========== Arquitetura do Oracle - Estrutura lógica ===========

A arquitetura do servidor do banco de dados Oracle consiste em três estrutura principais:
    - Memória;
    - Processo;
    - Armazenamento.

O banco de dados é composto tanto por estruturas físicas como lógicas. Como as estruturas físicas e lógicas
são separadas, o armazenamento físico de dados pode ser gerenciado sem afetar o acesso às estruturas lógicas
de armazenamento.



--- Estrutura Lógica 1 ---

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

Um segmento é um grupo de exteensões que abrange um objeto de banco de dados tratado pelo Oracle como uma
unidade, por exemplo, uma tabela ou índice.

Quatro tipos de segmentos são encontrados em um banco de dados Oracle: segmentos de dados, de índices, rollback
e temporários.


-- O que são extensões? --

É um espaço usado por um segmento em um tablespace.

Quando um objeto de banco de dados é expandido (o aumento de uma tabela, por exemplo), o espaço adicionado ao
objeto é alocado como uma extensão.

Uma extensão consiste em um ou mais blocos de banco de dados.


-- O que são blocos de dados? --

No nível mais detalahos dee granularidade, os dados de um banco de dados Oracle, são armazenados em blocos de dados.

- Um bloco de banco de dados é a menor unidade entrada/saída no banco de dados;
- Um bloco é normalmente um múltiplo do tamanho de bloco do sistema operacional para facilitar a E/S de disco eficiente;
- O tamanho padrão é de 8k, é especificado pelo parâmetro de inicialização do Oracle DB_BLOCK_SIZE, e é adequado
para a maioria dos bancos de dados;
- O tamanho máximo do bloco deepende do sistema operacional;
- O tamanho mínimo do bloco é de 2k e raramente deverá ser usado.

O Oracle gerencia todo o espaço de armazenamento nos datafiles através dessas pequenas unidades chamada blocos de dados,
que carregam informações importantes como cabeçalho, diretório da tabela, diretório de linha, dados de tabelas ou índices 
e espaço livre para inserções ou atualizações de dados.

Então resumindo, a estrutura lógica de um banco de dados Oracle se resume em tablespaces que contém segmentos que contém
extensões que contém blocos.



--- Estrutura Lógica 2 ---

O Oracle Database usa diversas estruturas físicas de armazenamento para gerenciar o banco de dados. Algumas dessas
estruturas são: 
    - Datafiles;
    - Redo Log Files;
    - Archive Logs;
    - Control File;
    - Parameter Files.


-- O que são datafiles? --

Fisicamente, no nível do sistema operacional, o armazenamento é feito através de datafiles, que são arquivos de sistema
operacional com tamanhos definidos e que podem ser "visualizados" no sistema operacional através de comandos simples
como "ls -l" (Unix) our "dir" (Windows).

- Cada datafile é membro de um tablespace, porém cada tablespace pode ter vários datafiles;
- O Datafile é o lugar de armazenamento final para todos os dados no banco de dados.


-- O que são Redo Logs? --

Sempre que forem adicionados, removidos ou alterados dados em uma tabela, índice ou outro objeto do Oracle, uma entrada
será gravada no arquivo de redo log atual. Cada banco de dados Oracle deve ter ao menos dois arquivos de redo log,
porque o Oracle reutiliza os arquivos de redo log de maneira circular.

Os redo logs possuem 6 status que são importantes ressaltar:

    UNUSED - Registro de redo online nunca escrito. Este é o estado de um log de redo que acabou de ser adicionado, ou
    logo após a RESETLOGS, quando não é o log de redo atual.

    CURRENT - Registro de redo atual. Isso implica que o log redo está ativo. O log redo pode ser aberto ou fechado.

    ACTIVE - Log está ativo, mas não é o log atual. É necessário para a recuperação de falhas. Pode estar em uso para 
    a recuperação do bloco. Ele pode ou não ser arquivado.

    CLEARING - O log está sendo recriado como um log vazio após uma instrução ALTER DATABASE CLEAR LOGFILE. Depois que
    o log estiver desmarcado, o status muda para UNUSED.

    CLEARING_CURRENT - O log atual está sendo apagado de um thread fechado. O log pode permanecer nesse status se 
    houver falha no comutador, como um erro de E/S escrevendo o novo cabeçalho do log.

    INACTIVE - Log não é mais necessário para recuperação de instância. Ele pode estar em uso para a recuperação de
    mídia. Ele pode ou não ser arquivado 

Essas informações podem ser visualizadas na view v$log, assim como outras informações, como por exemplo, número de
sequência do log, número do grupo, etc...

Quando ocorre alguma falha (por exemplo, falta de energia no servidor), alguns blocos de dados que foram atualizados
no database buffer cache podem não ter sido gravados nos datafiles. Quando a instância for reinicializada, as entradas
no redo log serão aplicadas aos datafiles do banco de dados em uma operação de roll-forward para restaurar o estado
do banco de dados até o ponto em que a falha ocorreu.

É altamente recomendado que os arquivos de redo log sejam multiplexados, ou seja, tenham uma ou mais cópias ativas
para garantir disponibilidade e integridade dos dados. A perda de um redo log que não tenha cópia pode causas perda
de dados.


-- O que são Control Files? --



*/
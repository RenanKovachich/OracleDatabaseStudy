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

Cada banco de dados Oracle tem ao menos um arquivo de controle que mantém os seus metadados (em outras palavras, os
dados sobre a estrutura física do próprio banco de dados). Entre outras coisas, ele contém o nome do banco de dados,
quando ele foi criado e os nomes e locais de todos os arquivos de dados e arquivos de redo log. Além disso, o arquivo
de controle mantêm as informações usadas pelo RMAN, como as configurações RMAN persistentes e os tipos de backups
que foram executados no banco de dados.

O control file é um arquivo muito crítico para a operação do banco de dados, e por isso pode (e deve) ser multiplexado
e copiado para backup com frequência.

- Para subir o banco de dados em modo MOUNT é necessário ter o control file.


-- O que são Archives Logs? --

O Oracle Database pode funcionar de dois modos: ARCHIVELOG ou NOARCHIVELOG.

O modo ARCHIVELOG envia um arquivo de redo log preenchido (após o mesmo sofrer um switch automático, quando o arquivo
é totalmente preenchido, ou quando ocorre um switch log de forma manual) para um ou mais destinos especificados e 
podem ficar disponíveis para a recuperação do banco de dados a qualquer momento caso ocorra uma falha na mídia do
banco de dados.

Se uma unidade de disco contendo datafiles falhar, o conteúdo do banco de dados pode ser recuperado até um determinado
ponto no tempo antes da falha.  para isto é necessário: um backup recente dos datafiles, os arquivos de redo log e
os archive logs gerados a partir do backup.

Em contrapartida, o modo NOARCHIVELOG não garante integridade do banco de dados na ocorrência de uma falha de instância
ou de sistema. As transações que sofreram commit mas que ainda não foram gravadas nos datafiles estão disponívies apenas
nos arquivos de redo log online. Sendo assim, a recuperação de uma falha estará limitada às entradas existentes
atualmente nos redo logs online. Se o último backup foi realizado antes do primeiro arquivo de redo log, então não será
possível recuperar o banco de dados, os dados gerados após este backup serão perdidos.


-- O que são Parameter Files? --

Quando uma instância de banco de dados inicia, a memória para a instância Oracle alocada a um dos dois tipos de arquivos
de parãmetro de inicialização é aberto: um arquivo texto denominado init.ora (conhecido genericamente como init.ora ou PFILE) 
ou um arquivo de parâmetro de servidor (conhecido como SPFILE). A instância primeiro procura um SPFILE no local padrão 
do sistema operacional ($ORACLE_GOME/dbs no Unix, por exemplo) como spfile.<sid>.ora ou spfile.ora. Se nenhum desses 
arquivos existir, a instância procura um PFILE com o nome init.<sid>.ora.

Como alternativa, o comando startup pode especificar explicitamente um PFILE para ser usado na inicialização.

Os arquivos de parâmetro de inicialização, independentemente do formato, especificam as localizações para arquivos de 
rastreamento, arquivos de controle, arquivos de redo logs preenchidos e assim por diante. Eles também definem os limites 
quanto aos tamanhos das várias estruturas na SGA e também quanto à quantidade de usuários que podem se conectar ao banco 
de dados simultaneamente.

Se um SPFILE estiver em uso para a instância em execução, qualquer comando alter system que altere um parâmetro de 
inicialização poderá mudar automaticamente o parâmetro de inicialização SPFILE, alterá-lo somente para a instância em 
execução ou ambos.

Embora não seja possível espelhar um arquivo de parâmetro ou SPFILE, é possível fazer um backup de um SPFILE para um 
arquivo init.ora e tanto o init.ora como o SPFILE para a instância Oracle devem ser copiados em backup por meio dos 
comandos de S.O convencionais ou usando o RMAN no caso de um SPFILE.


-- O que são Alert e Trace Log? --

Quando algo dá errado, o Oracle pode gravar mensagens no log de alerta e, no caso de processos em segundo plano ou 
sessões de usuário, nos arquivos de log de rastreamento.

O arquivo de log de alerta, localizado no diretório especificado pelo parâmetro de inicialização BACKGROUND_DUMP_DEST, 
contém mensagens de status de rotina e condições de erro. Quando o banco de dados é inicializado ou desligado, uma 
mensagem é registrada no log de alerta, junto com uma lista de parâmetros de inicialização que são diferentes dos seus 
valores padrão. Além disso, todos os comandos alter database e alter system emitidos pelo DBA são registrados.

Os arquivos de rastreamento para os processos em segundo plano da instância Oracle igualmente estão localizados no 
BACKGROUND_DUMP_DEST. Por exemplo, os arquivos de rastreamento para PMON E SMON contêm uma entrada para quando ocorrer 
um erro ou quando o SMON precisar executar uma recuperação de instância;

Também são criados arquivos de rastreamento para sessões individuais dos usuários ou para conexões com o banco de dados. 
Esses trace logs estão localizados no diretório especificado pelo parâmetro USER_DUMP_DEST. Esses arquivos são criados em 
duas situações: quando ocorre algum tipo de erro em uma sessão do usuário (como um problema de privilégio, esgotamento de 
espaço, dentre outros); ou podem ser criados explicitamente com o comando:

    ALTER SESSION SET SQL_TRACE=TRUE;

A informação de rastreamento é gerada para cada instrução SQL executada pelo usuário, o que pode ser útil para se ajustar
a instrução SQL do usuário.

*/
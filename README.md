# Checkpoint 4 — Bug Hunt StreamFIAP

## Identificação

**Grupo:** cp4-bughunt-Grupo GS

| Integrante | RM | Turma |

| Daniel Castro Sanches | rm563333 | 2CCPX |
| Maria Eduarda de Áquila Amaral | rm563783 | 2CCPX |
| Matheus Vilela Silveira | rm564989 | 2CCPX |

| Campo | |
|---|---|
| **Total de bugs corrigidos** | 12 / 12 |
| **Total de ajustes de Clean Code** | 6 / 6 |

---

## Parte 1 — Bugs encontrados

| # | Sintoma observado (o que fiz/vi) | Causa raiz (arquivo e linha aproximada) | Correção aplicada | Conceito da disciplina |
|---|---|---|---|---|
| bug01 | Ao consultar `GET /api/conteudos/999`, a API retornava uma resposta vazia em vez de informar que o conteúdo não existia | `ConteudoController.buscarPorId`, no `catch (Exception e)` vazio: a `ConteudoNaoEncontradoException` era engolida e o método retornava `null` | Removido o `try/catch`; a exceção agora chega ao `GlobalExceptionHandler`, que retorna 404 e uma mensagem clara | Exceções e tratamento global de erros |
| bug02 | `GET /api/conteudos/categoria/FICCAO` retornava lista vazia mesmo existindo conteúdos nessa categoria | `ConteudoController.listarPorCategoria`: comparação de Strings feita com `==` | Substituído `==` por `.equals()` na comparação da categoria | Comparação de objetos e Strings |
| bug03 | Uma série com várias temporadas era cobrada pelo preço padrão R$ 9,90, sem considerar as temporadas | `Serie.calcularPrecoAluguel(double desconto)` tinha assinatura diferente da superclasse e criava sobrecarga, não sobrescrita | Removido o parâmetro extra, adicionado `@Override` e definido o cálculo `4.90 * numeroTemporadas`; método da superclasse passou a ser abstrato | Polimorfismo, override e overload |
| bug04 | O preço promocional do filme ficava maior que o preço normal | `Filme.aplicarPromocao` multiplicava o preço por `1.2`, aumentando 20% | Corrigido para multiplicar por `0.8`, aplicando desconto de 20% | Interface e implementação de contrato |
| bug05 | Documentário era cobrado por R$ 9,90, embora o contrato diga que é gratuito | `Documentario` herdava o cálculo padrão de `Conteudo` e não sobrescrevia o método | Adicionado `calcularPrecoAluguel()` retornando `0.0` | Herança e sobrescrita de método |
| bug06 | Séries cadastradas ficavam indisponíveis mesmo quando o JSON enviava `disponivel: true` | Construtor de `Serie` não recebia nem repassava o atributo `disponivel` para `Conteudo` | Construtor atualizado para receber `disponivel`; controller atualizado para repassar o valor | Construtores, inicialização e encapsulamento |
| bug07 | A API aceitava conteúdo com duração 0 ou negativa | Os três endpoints de cadastro de conteúdo não validavam `duracaoMinutos` | Adicionado método de validação antes de salvar filme, série ou documentário | Validação de dados e regras de negócio |
| bug08 | Usuário era salvo com nome nulo | Construtor de `Usuario` usava `nome = nome` em vez de atribuir ao atributo da classe | Corrigido para `this.nome = nome` | Escopo de variável e uso de `this` |
| bug09 | Usuário com crédito insuficiente conseguia alugar e usuário com saldo alto era recusado | `temCreditosSuficientes` usava comparação invertida: `preco >= creditos` | Corrigido para `creditos >= preco` | Operadores relacionais e lógica condicional |
| bug10 | Era possível alugar um conteúdo com `disponivel: false` | `Usuario.alugar` não verificava a disponibilidade antes do débito | Adicionada verificação de `isDisponivel()` e lançamento de `ConteudoIndisponivelException` | Regras de negócio no model e exceções customizadas |
| bug11 | Usuário menor de idade recebia erro 500 genérico ao tentar alugar conteúdo incompatível | O `GlobalExceptionHandler` não tinha handler para `ClassificacaoIndicativaException` | Adicionado `@ExceptionHandler(ClassificacaoIndicativaException.class)` retornando 403 e a mensagem da regra | Checked exceptions e tratamento global |
| bug12 | Buscar usuário inexistente retornava erro 500 genérico | `UsuarioController` e `AluguelController` lançavam `IllegalArgumentException`, mas ela não era tratada globalmente | Adicionado handler para `IllegalArgumentException`, retornando mensagem de erro ao cliente | Padronização de respostas de erro da API |

## Parte 2 — Ajustes de Clean Code

| # | Onde estava | Qual princípio/boas práticas era violado | O que eu mudei |
|---|---|---|---|
| clean01 | `Conteudo.duracaoMinutos` | O atributo era `public`, quebrando o encapsulamento usado no restante da classe | Alterado para `private`; o acesso é feito pelos getters e setters |
| clean02 | `ConteudoController.buscarPorId` | O método criava `ResponseEntity.ok(conteudo)` apenas para chamar `.getBody()` logo depois | Alterado o retorno para `ResponseEntity<Conteudo>` diretamente |
| clean03 | `ConteudoController` | Existia código morto: método `calcularDescontoAntigo` não usado e comentário de cupom obsoleto | Removido o método e o bloco de comentário sem utilidade |
| clean04 | `Usuario.debitarCreditos` | O comentário dizia que o método adicionava créditos, mas o código subtraía | Comentário corrigido para descrever a operação real |
| clean05 | `Serie.calcularPrecoAluguel(double desconto)` | Havia parâmetro não utilizado e assinatura enganosa | Parâmetro removido; método ficou com assinatura correta e `@Override` |
| clean06 | Controllers e tratamento de erros | Uso inconsistente de exceções genéricas sem resposta padronizada ao cliente | Centralizado o tratamento de `IllegalArgumentException` no `GlobalExceptionHandler` |

---

## Parte 3 — Perguntas de reflexão

### 1. Injeção de dependência (Aula 13)

Os controllers usam `@Autowired` para receber os repositories porque o Spring precisa criar e gerenciar esses objetos como beans. No `ConteudoController`, por exemplo, o `ConteudoRepository` é uma interface; por isso não seria possível simplesmente usar `new ConteudoRepository()`. O Spring Data JPA cria uma implementação/proxy em tempo de execução com os métodos de persistência, como `findAll`, `findById` e `save`. Ao injetar esse bean, o controller recebe um objeto já configurado para trabalhar com a conexão do banco e com o JPA. Com `new`, não haveria implementação da interface, configuração de conexão nem gerenciamento do ciclo de vida pelo container do Spring.

### 2. JDBC vs Spring Data JPA (Aulas 12 e 13)

Com JDBC/DAO, seria necessário abrir uma `Connection`, montar um `PreparedStatement`, executar SQL, percorrer o `ResultSet` e transformar cada linha em objeto. No StreamFIAP, o `ConteudoRepository` estende `JpaRepository` e já recebe operações de CRUD, como `save`, `findAll`, `findById` e `delete`, sem implementação manual. O Spring Data JPA automatiza o mapeamento entre entidades Java e tabelas, além de gerar várias consultas. Um método como `findByCategoria` consegue funcionar sem corpo porque o Spring interpreta `findBy` e o atributo `categoria`, criando a consulta automaticamente. JDBC ainda pode ser mais apropriado em consultas muito específicas, relatórios complexos ou cenários que exigem controle total do SQL.

### 3. Exceções checked vs unchecked (Aula 11)

`ClassificacaoIndicativaException` estende `Exception`, então é uma exceção checked. Isso obriga métodos como `Usuario.alugar` a declarar que ela pode ser lançada usando `throws`. Já exceções que estendem `RuntimeException`, como `ConteudoNaoEncontradoException` e `CreditosInsuficientesException`, são unchecked e não exigem declaração na assinatura. O problema não era a exceção checked existir, mas não haver um handler para ela no `GlobalExceptionHandler`. A correção foi criar um `@ExceptionHandler` específico, que transforma a exceção em uma resposta HTTP 403 com a mensagem da regra, em vez de deixar a API responder erro 500 genérico.

### 4. Sobrescrita vs sobrecarga (Aula 7)

Sobrescrita acontece quando uma subclasse redefine um método da superclasse com a mesma assinatura. Sobrecarga acontece quando existem métodos com o mesmo nome, mas parâmetros diferentes. Na `Serie`, existia `calcularPrecoAluguel(double desconto)`, enquanto a superclasse usava `calcularPrecoAluguel()` sem parâmetro. Portanto, não era uma sobrescrita: era outro método, que não era chamado quando `Usuario.alugar` executava `c.calcularPrecoAluguel()`. Por isso a série recebia o preço errado. Ao usar `@Override`, o compilador verifica se a assinatura realmente corresponde a um método da superclasse; se a anotação estivesse presente antes, o erro teria sido identificado na compilação.

### 5. Onde blindar o objeto? (Aulas 3, 4 e 13)

Cada regra deve ser validada na camada em que ela faz mais sentido, mas regras essenciais também precisam ser protegidas no próprio model. A duração inválida foi validada no controller antes de persistir, pois é uma entrada recebida diretamente pela API. Já créditos suficientes e disponibilidade foram validados no método `Usuario.alugar`, porque são regras de negócio e precisam valer independentemente de quem chama esse método. O nome nulo não era uma regra esquecida, mas um erro no construtor: `nome = nome` não alterava o atributo da entidade, então foi necessário corrigir para `this.nome = nome`. Validar só em um lugar não é suficiente porque o sistema pode criar ou alterar objetos por construtor, setter ou endpoint.

### 6. Abstração e interface (Aulas 8 e 9)

`Conteudo` é uma classe abstrata porque concentra os atributos e comportamentos comuns de filme, série e documentário: título, categoria, duração, classificação etária, disponibilidade e cálculo de preço. Já `Promocionavel` é uma interface porque representa uma capacidade opcional: receber promoção. Filme e série implementam essa interface; documentário não implementa, pois não participa de promoção. Se o documentário passasse a ter promoção, seria necessário adicionar `implements Promocionavel` e implementar `aplicarPromocao` nessa classe. O método `calcularPrecoPromocional` em `Conteudo` continuaria intacto, assim como Filme e Série. Isso mostra um design extensível: a herança representa o que as entidades são, enquanto a interface representa uma capacidade que elas podem ter.

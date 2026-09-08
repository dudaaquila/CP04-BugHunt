# Commits em ordem - StreamFIAP Bug Hunt (CP4)
# Execute um por um, na raiz do repositorio, apos o commit inicial
# "chore: estado original do projeto recebido"

git add src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "fix: bug01 - remove catch vazio que engolia excecao ao buscar conteudo inexistente"

git add src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "fix: bug02 - corrige comparacao de categoria usando equals ao inves de =="

git add src/main/java/br/com/fiap/streamfiap/model/Serie.java src/main/java/br/com/fiap/streamfiap/model/Conteudo.java
git commit -m "fix: bug03 - torna calcularPrecoAluguel abstrato e faz Serie sobrescrever corretamente"

git add src/main/java/br/com/fiap/streamfiap/model/Filme.java
git commit -m "fix: bug04 - corrige aplicarPromocao do Filme que aumentava o preco em 20% em vez de dar desconto"

git add src/main/java/br/com/fiap/streamfiap/model/Documentario.java
git commit -m "fix: bug05 - Documentario agora sobrescreve calcularPrecoAluguel retornando 0.0"

git add src/main/java/br/com/fiap/streamfiap/model/Serie.java src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "fix: bug06 - construtor de Serie passa a receber e setar o campo disponivel"

git add src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "fix: bug07 - adiciona validacao de duracaoMinutos <= 0 nos cadastros de conteudo"

git add src/main/java/br/com/fiap/streamfiap/model/Usuario.java
git commit -m "fix: bug08 - corrige atribuicao nome = nome para this.nome = nome no construtor de Usuario"

git add src/main/java/br/com/fiap/streamfiap/model/Usuario.java
git commit -m "fix: bug09 - inverte logica de temCreditosSuficientes que estava ao contrario"

git add src/main/java/br/com/fiap/streamfiap/model/Usuario.java
git commit -m "fix: bug10 - Usuario.alugar passa a verificar isDisponivel antes de efetivar o aluguel"

git add src/main/java/br/com/fiap/streamfiap/exception/GlobalExceptionHandler.java
git commit -m "fix: bug11 - adiciona handler para ClassificacaoIndicativaException"

git add src/main/java/br/com/fiap/streamfiap/exception/GlobalExceptionHandler.java src/main/java/br/com/fiap/streamfiap/controller/UsuarioController.java src/main/java/br/com/fiap/streamfiap/controller/AluguelController.java
git commit -m "fix: bug12 - adiciona handler para IllegalArgumentException (usuario nao encontrado)"

# --- Clean Code ---

git add src/main/java/br/com/fiap/streamfiap/model/Conteudo.java
git commit -m "refactor: clean01 - encapsula duracaoMinutos com getter e setter privados"

git add src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "refactor: clean02 - buscarPorId passa a retornar ResponseEntity diretamente sem getBody manual"

git add src/main/java/br/com/fiap/streamfiap/controller/ConteudoController.java
git commit -m "refactor: clean03 - remove metodo morto calcularDescontoAntigo e comentario TODO obsoleto de cupom"

git add src/main/java/br/com/fiap/streamfiap/model/Usuario.java
git commit -m "refactor: clean04 - corrige comentario mentiroso de debitarCreditos (dizia adicionar, na verdade subtrai)"

git add src/main/java/br/com/fiap/streamfiap/model/Serie.java
git commit -m "refactor: clean05 - remove parametro desconto nao utilizado de calcularPrecoAluguel"

git add src/main/java/br/com/fiap/streamfiap/controller/UsuarioController.java src/main/java/br/com/fiap/streamfiap/controller/AluguelController.java
git commit -m "refactor: clean06 - padroniza uso de exceptions customizadas em vez de IllegalArgumentException generico"

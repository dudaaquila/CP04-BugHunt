package br.com.fiap.streamfiap.controller;

import br.com.fiap.streamfiap.exception.ConteudoNaoEncontradoException;
import br.com.fiap.streamfiap.model.Conteudo;
import br.com.fiap.streamfiap.model.Documentario;
import br.com.fiap.streamfiap.model.Filme;
import br.com.fiap.streamfiap.model.Serie;
import br.com.fiap.streamfiap.repository.ConteudoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/conteudos")
public class ConteudoController {

    @Autowired
    private ConteudoRepository conteudoRepository;

    @GetMapping
    public List<Conteudo> listarTodos() {
        return conteudoRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Conteudo> buscarPorId(@PathVariable Long id) {
        Conteudo conteudo = conteudoRepository.findById(id)
                .orElseThrow(() -> new ConteudoNaoEncontradoException("Conteúdo não encontrado: " + id));
        return ResponseEntity.ok(conteudo);
    }

    @GetMapping("/categoria/{categoria}")
    public List<Conteudo> listarPorCategoria(@PathVariable String categoria) {
        List<Conteudo> resultado = new ArrayList<>();
        for (Conteudo c : conteudoRepository.findAll()) {
            if (c.getCategoria().equals(categoria)) {
                resultado.add(c);
            }
        }
        return resultado;
    }

    @GetMapping("/{id}/preco-promocional")
    public double precoPromocional(@PathVariable Long id) {
        Conteudo conteudo = conteudoRepository.findById(id)
                .orElseThrow(() -> new ConteudoNaoEncontradoException("Conteúdo não encontrado: " + id));
        return conteudo.calcularPrecoPromocional();
    }

    @PostMapping("/filme")
    public ResponseEntity<Filme> cadastrarFilme(@RequestBody Filme filme) {
        validarDuracao(filme.getDuracaoMinutos());
        Filme novo = new Filme(filme.getTitulo(), filme.getCategoria(), filme.getDuracaoMinutos(),
                filme.getClassificacaoEtaria(), filme.isDisponivel(), filme.isEstreia());
        return ResponseEntity.status(201).body(conteudoRepository.save(novo));
    }

    @PostMapping("/serie")
    public ResponseEntity<Serie> cadastrarSerie(@RequestBody Serie serie) {
        validarDuracao(serie.getDuracaoMinutos());
        Serie nova = new Serie(serie.getTitulo(), serie.getCategoria(), serie.getDuracaoMinutos(),
                serie.getClassificacaoEtaria(), serie.isDisponivel(), serie.getNumeroTemporadas());
        return ResponseEntity.status(201).body(conteudoRepository.save(nova));
    }

    @PostMapping("/documentario")
    public ResponseEntity<Documentario> cadastrarDocumentario(@RequestBody Documentario documentario) {
        validarDuracao(documentario.getDuracaoMinutos());
        Documentario novo = new Documentario(documentario.getTitulo(), documentario.getCategoria(),
                documentario.getDuracaoMinutos(), documentario.getClassificacaoEtaria(),
                documentario.isDisponivel(), documentario.getTema());
        return ResponseEntity.status(201).body(conteudoRepository.save(novo));
    }

    private void validarDuracao(int duracaoMinutos) {
        if (duracaoMinutos <= 0) {
            throw new IllegalArgumentException("duracaoMinutos deve ser maior que zero");
        }
    }
}

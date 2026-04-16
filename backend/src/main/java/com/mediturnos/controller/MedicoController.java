package com.mediturnos.controller;

import com.mediturnos.model.Medico;
import com.mediturnos.service.MedicoService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/medicos")
@RequiredArgsConstructor
public class MedicoController {

    private final MedicoService service;

    @GetMapping
    public List<Medico> listar(@RequestParam(required = false) String q) {
        if (q != null && !q.isBlank()) return service.buscar(q);
        return service.listar();
    }

    @GetMapping("/{id}")
    public Medico obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    public Medico crear(@Valid @RequestBody Medico m) { return service.crear(m); }

    @PutMapping("/{id}")
    public Medico actualizar(@PathVariable Long id, @Valid @RequestBody Medico m) {
        return service.actualizar(id, m);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}


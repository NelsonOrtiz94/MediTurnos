package com.mediturnos.controller;

import com.mediturnos.model.Paciente;
import com.mediturnos.service.PacienteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/pacientes")
@RequiredArgsConstructor
public class PacienteController {

    private final PacienteService service;

    @GetMapping
    public List<Paciente> listar(@RequestParam(required = false) String q) {
        if (q != null && !q.isBlank()) return service.buscar(q);
        return service.listar();
    }

    @GetMapping("/{id}")
    public Paciente obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    public Paciente crear(@Valid @RequestBody Paciente p) { return service.crear(p); }

    @PutMapping("/{id}")
    public Paciente actualizar(@PathVariable Long id, @Valid @RequestBody Paciente p) {
        return service.actualizar(id, p);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}


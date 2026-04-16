package com.mediturnos.controller;

import com.mediturnos.model.Especialidad;
import com.mediturnos.service.EspecialidadService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/especialidades")
@RequiredArgsConstructor
public class EspecialidadController {

    private final EspecialidadService service;

    @GetMapping
    public List<Especialidad> listar() { return service.listar(); }

    @GetMapping("/{id}")
    public Especialidad obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    public Especialidad crear(@Valid @RequestBody Especialidad e) { return service.crear(e); }

    @PutMapping("/{id}")
    public Especialidad actualizar(@PathVariable Long id, @Valid @RequestBody Especialidad e) {
        return service.actualizar(id, e);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.eliminar(id);
        return ResponseEntity.noContent().build();
    }
}


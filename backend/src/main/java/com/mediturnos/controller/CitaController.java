package com.mediturnos.controller;

import com.mediturnos.model.Cita;
import com.mediturnos.service.CitaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/citas")
@RequiredArgsConstructor
public class CitaController {

    private final CitaService service;

    @GetMapping
    public List<Cita> listar() { return service.listar(); }

    @GetMapping("/{id}")
    public Cita obtener(@PathVariable Long id) { return service.obtener(id); }

    @PostMapping
    public Cita agendar(@Valid @RequestBody Cita cita) { return service.agendar(cita); }

    @PutMapping("/{id}/reprogramar")
    public Cita reprogramar(@PathVariable Long id,
                            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime fechaHora) {
        return service.reprogramar(id, fechaHora);
    }

    @PutMapping("/{id}/cancelar")
    public Cita cancelar(@PathVariable Long id,
                         @RequestParam(required = false) String motivo) {
        return service.cancelar(id, motivo);
    }

    @PutMapping("/{id}/completar")
    public Cita completar(@PathVariable Long id) { return service.completar(id); }

    @GetMapping("/agenda")
    public List<Cita> agenda(@RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        return service.agendaDiaria(fecha);
    }

    @GetMapping("/historial/{pacienteId}")
    public List<Cita> historial(
            @PathVariable Long pacienteId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta) {
        return service.historialPaciente(pacienteId, desde, hasta);
    }

    @GetMapping("/reporte")
    public Map<String, Long> reporte(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate desde,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate hasta) {
        return service.reporte(desde, hasta);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable Long id) {
        service.cancelar(id, "Eliminado por el sistema");
        return ResponseEntity.noContent().build();
    }
}


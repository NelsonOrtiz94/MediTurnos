package com.mediturnos.service;

import com.mediturnos.model.Cita;
import com.mediturnos.repository.CitaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class CitaService {

    private final CitaRepository repo;

    public List<Cita> listar() { return repo.findAll(); }

    public Cita obtener(Long id) {
        return repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Cita no encontrada: " + id));
    }

    public Cita agendar(Cita cita) {
        validarDisponibilidad(cita.getMedico().getId(), cita.getFechaHora(), null);
        cita.setEstado(Cita.EstadoCita.PROGRAMADA);
        return repo.save(cita);
    }

    public Cita reprogramar(Long id, LocalDateTime nuevaFecha) {
        Cita cita = obtener(id);
        validarDisponibilidad(cita.getMedico().getId(), nuevaFecha, id);
        cita.setFechaHora(nuevaFecha);
        return repo.save(cita);
    }

    public Cita cancelar(Long id, String motivo) {
        Cita cita = obtener(id);
        cita.setEstado(Cita.EstadoCita.CANCELADA);
        cita.setMotivoCancelacion(motivo);
        return repo.save(cita);
    }

    public Cita completar(Long id) {
        Cita cita = obtener(id);
        cita.setEstado(Cita.EstadoCita.COMPLETADA);
        return repo.save(cita);
    }

    public List<Cita> agendaDiaria(LocalDate fecha) {
        LocalDateTime inicio = fecha.atStartOfDay();
        LocalDateTime fin    = fecha.atTime(23, 59, 59);
        return repo.findByFechaHoraBetweenOrderByFechaHoraAsc(inicio, fin);
    }

    public List<Cita> historialPaciente(Long pacienteId, LocalDate desde, LocalDate hasta) {
        if (desde != null && hasta != null) {
            return repo.findByPacienteIdAndFechaHoraBetweenOrderByFechaHoraDesc(
                    pacienteId, desde.atStartOfDay(), hasta.atTime(23, 59, 59));
        }
        return repo.findByPacienteIdOrderByFechaHoraDesc(pacienteId);
    }

    public Map<String, Long> reporte(LocalDate desde, LocalDate hasta) {
        List<Object[]> rows = repo.countByEstadoBetween(
                desde.atStartOfDay(), hasta.atTime(23, 59, 59));
        Map<String, Long> result = new HashMap<>();
        for (Object[] row : rows) {
            result.put(row[0].toString(), (Long) row[1]);
        }
        return result;
    }

    private void validarDisponibilidad(Long medicoId, LocalDateTime fechaHora, Long citaIdExcluir) {
        boolean conflicto = repo.existsByMedicoIdAndFechaHoraAndEstado(
                medicoId, fechaHora, Cita.EstadoCita.PROGRAMADA);
        if (conflicto) {
            throw new RuntimeException("El médico ya tiene una cita programada en ese horario");
        }
    }
}


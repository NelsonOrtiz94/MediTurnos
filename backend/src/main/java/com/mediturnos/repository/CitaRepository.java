package com.mediturnos.repository;

import com.mediturnos.model.Cita;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@Repository
public interface CitaRepository extends JpaRepository<Cita, Long> {

    // Agenda diaria: citas de un médico en un rango de fecha
    List<Cita> findByMedicoIdAndFechaHoraBetweenOrderByFechaHoraAsc(
            Long medicoId, LocalDateTime inicio, LocalDateTime fin);

    // Todas las citas de un día (cualquier médico)
    List<Cita> findByFechaHoraBetweenOrderByFechaHoraAsc(
            LocalDateTime inicio, LocalDateTime fin);

    // Historial de un paciente
    List<Cita> findByPacienteIdOrderByFechaHoraDesc(Long pacienteId);

    // Historial en rango de fechas
    List<Cita> findByPacienteIdAndFechaHoraBetweenOrderByFechaHoraDesc(
            Long pacienteId, LocalDateTime inicio, LocalDateTime fin);

    // Verificar conflicto de horario (mismo médico, misma hora, estado PROGRAMADA)
    boolean existsByMedicoIdAndFechaHoraAndEstado(
            Long medicoId, LocalDateTime fechaHora, Cita.EstadoCita estado);

    // Reporte: contar por estado
    @Query("SELECT c.estado, COUNT(c) FROM Cita c " +
           "WHERE c.fechaHora BETWEEN :inicio AND :fin " +
           "GROUP BY c.estado")
    List<Object[]> countByEstadoBetween(LocalDateTime inicio, LocalDateTime fin);
}


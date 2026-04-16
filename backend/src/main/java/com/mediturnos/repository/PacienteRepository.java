package com.mediturnos.repository;

import com.mediturnos.model.Paciente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface PacienteRepository extends JpaRepository<Paciente, Long> {
    boolean existsByDocumento(String documento);
    List<Paciente> findByNombreContainingIgnoreCaseOrDocumentoContainingIgnoreCase(String nombre, String documento);
}


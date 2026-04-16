package com.mediturnos.service;

import com.mediturnos.model.Paciente;
import com.mediturnos.repository.PacienteRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PacienteService {

    private final PacienteRepository repo;

    public List<Paciente> listar() { return repo.findAll(); }

    public Paciente obtener(Long id) {
        return repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado: " + id));
    }

    public List<Paciente> buscar(String q) {
        return repo.findByNombreContainingIgnoreCaseOrDocumentoContainingIgnoreCase(q, q);
    }

    public Paciente crear(Paciente p) {
        if (repo.existsByDocumento(p.getDocumento())) {
            throw new RuntimeException("Ya existe un paciente con ese documento");
        }
        return repo.save(p);
    }

    public Paciente actualizar(Long id, Paciente datos) {
        Paciente p = obtener(id);
        p.setNombre(datos.getNombre());
        p.setDocumento(datos.getDocumento());
        p.setTelefono(datos.getTelefono());
        p.setCorreo(datos.getCorreo());
        return repo.save(p);
    }

    public void eliminar(Long id) { repo.deleteById(id); }
}


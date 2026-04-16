package com.mediturnos.service;

import com.mediturnos.model.Medico;
import com.mediturnos.repository.MedicoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MedicoService {

    private final MedicoRepository repo;

    public List<Medico> listar() { return repo.findAll(); }

    public Medico obtener(Long id) {
        return repo.findById(id)
                .orElseThrow(() -> new RuntimeException("Médico no encontrado: " + id));
    }

    public List<Medico> buscar(String q) {
        return repo.findByNombreContainingIgnoreCaseOrDocumentoContainingIgnoreCase(q, q);
    }

    public Medico crear(Medico m) {
        if (repo.existsByDocumento(m.getDocumento())) {
            throw new RuntimeException("Ya existe un médico con ese documento");
        }
        return repo.save(m);
    }

    public Medico actualizar(Long id, Medico datos) {
        Medico m = obtener(id);
        m.setNombre(datos.getNombre());
        m.setDocumento(datos.getDocumento());
        m.setTelefono(datos.getTelefono());
        m.setCorreo(datos.getCorreo());
        m.setHorario(datos.getHorario());
        m.setEspecialidad(datos.getEspecialidad());
        return repo.save(m);
    }

    public void eliminar(Long id) { repo.deleteById(id); }
}


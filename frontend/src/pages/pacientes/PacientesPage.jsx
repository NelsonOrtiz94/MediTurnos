import { useState, useEffect } from 'react';
import { getPacientes, createPaciente, updatePaciente, deletePaciente } from '../../api';

const EMPTY = { nombre: '', documento: '', telefono: '', correo: '' };

export default function PacientesPage() {
  const [lista, setLista]       = useState([]);
  const [form, setForm]         = useState(EMPTY);
  const [editId, setEditId]     = useState(null);
  const [busqueda, setBusqueda] = useState('');
  const [error, setError]       = useState('');

  const cargar = (q = '') => getPacientes(q).then(r => setLista(r.data));
  useEffect(() => { cargar(); }, []);

  const change = e => setForm(f => ({ ...f, [e.target.name]: e.target.value }));

  const guardar = async (e) => {
    e.preventDefault(); setError('');
    try {
      if (editId) await updatePaciente(editId, form);
      else await createPaciente(form);
      setForm(EMPTY); setEditId(null); cargar(busqueda);
    } catch (err) {
      setError(err.response?.data?.error || JSON.stringify(err.response?.data) || 'Error');
    }
  };

  const editar = (p) => {
    setEditId(p.id);
    setForm({ nombre: p.nombre, documento: p.documento, telefono: p.telefono || '', correo: p.correo || '' });
  };

  const eliminar = async (id) => {
    if (window.confirm('¿Eliminar paciente?')) { await deletePaciente(id); cargar(busqueda); }
  };

  return (
    <div>
      <h2>Pacientes</h2>

      <div style={{ marginBottom: 12 }}>
        <input placeholder="Buscar por nombre o documento…" value={busqueda}
          onChange={e => { setBusqueda(e.target.value); cargar(e.target.value); }}
          style={{ padding: '6px 10px', width: 280 }} />
      </div>

      <form onSubmit={guardar} className="form-grid">
        <input name="nombre"    value={form.nombre}    onChange={change} placeholder="Nombre *"    required />
        <input name="documento" value={form.documento} onChange={change} placeholder="Documento *" required />
        <input name="telefono"  value={form.telefono}  onChange={change} placeholder="Teléfono" />
        <input name="correo"    value={form.correo}    onChange={change} placeholder="Correo" type="email" />
        <button type="submit" className="btn-primary">{editId ? 'Actualizar' : 'Guardar'}</button>
        {editId && <button type="button" onClick={() => { setForm(EMPTY); setEditId(null); }}>Cancelar</button>}
        {error && <span style={{ color: 'red' }}>{error}</span>}
      </form>

      <table className="tabla">
        <thead><tr><th>#</th><th>Nombre</th><th>Documento</th><th>Teléfono</th><th>Correo</th><th>Acciones</th></tr></thead>
        <tbody>
          {lista.map(p => (
            <tr key={p.id}>
              <td>{p.id}</td><td>{p.nombre}</td><td>{p.documento}</td>
              <td>{p.telefono}</td><td>{p.correo}</td>
              <td>
                <button onClick={() => editar(p)} className="btn-edit">Editar</button>
                <button onClick={() => eliminar(p.id)} className="btn-delete">Eliminar</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}


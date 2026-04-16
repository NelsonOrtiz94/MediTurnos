import { useState, useEffect } from 'react';
import { getMedicos, createMedico, updateMedico, deleteMedico, getEspecialidades } from '../../api';

const EMPTY = { nombre: '', documento: '', telefono: '', correo: '', horario: '', especialidad: { id: '' } };

export default function MedicosPage() {
  const [lista, setLista]           = useState([]);
  const [especialidades, setEsp]    = useState([]);
  const [form, setForm]             = useState(EMPTY);
  const [editId, setEditId]         = useState(null);
  const [busqueda, setBusqueda]     = useState('');
  const [error, setError]           = useState('');

  const cargar = (q = '') => getMedicos(q).then(r => setLista(r.data));

  useEffect(() => {
    cargar();
    getEspecialidades().then(r => setEsp(r.data));
  }, []);

  const change = e => setForm(f => ({ ...f, [e.target.name]: e.target.value }));
  const changeEsp = e => setForm(f => ({ ...f, especialidad: { id: Number(e.target.value) } }));

  const guardar = async (e) => {
    e.preventDefault(); setError('');
    try {
      if (editId) await updateMedico(editId, form);
      else await createMedico(form);
      setForm(EMPTY); setEditId(null); cargar(busqueda);
    } catch (err) {
      setError(err.response?.data?.error || JSON.stringify(err.response?.data) || 'Error');
    }
  };

  const editar = (m) => {
    setEditId(m.id);
    setForm({ nombre: m.nombre, documento: m.documento, telefono: m.telefono || '',
              correo: m.correo || '', horario: m.horario || '',
              especialidad: { id: m.especialidad?.id || '' } });
  };

  const eliminar = async (id) => {
    if (window.confirm('¿Eliminar médico?')) { await deleteMedico(id); cargar(busqueda); }
  };

  return (
    <div>
      <h2>Médicos</h2>

      {/* Búsqueda */}
      <div style={{ marginBottom: 12 }}>
        <input placeholder="Buscar por nombre o documento…" value={busqueda}
          onChange={e => { setBusqueda(e.target.value); cargar(e.target.value); }}
          style={{ padding: '6px 10px', width: 280 }} />
      </div>

      {/* Formulario */}
      <form onSubmit={guardar} className="form-grid">
        <input name="nombre"    value={form.nombre}    onChange={change} placeholder="Nombre *"    required />
        <input name="documento" value={form.documento} onChange={change} placeholder="Documento *" required />
        <input name="telefono"  value={form.telefono}  onChange={change} placeholder="Teléfono" />
        <input name="correo"    value={form.correo}    onChange={change} placeholder="Correo" type="email" />
        <input name="horario"   value={form.horario}   onChange={change} placeholder="Horario (ej: Lun-Vie 8-16)" />
        <select value={form.especialidad.id} onChange={changeEsp} required>
          <option value="">-- Especialidad * --</option>
          {especialidades.map(e => <option key={e.id} value={e.id}>{e.nombre}</option>)}
        </select>
        <button type="submit" className="btn-primary">{editId ? 'Actualizar' : 'Guardar'}</button>
        {editId && <button type="button" onClick={() => { setForm(EMPTY); setEditId(null); }}>Cancelar</button>}
        {error && <span style={{ color: 'red' }}>{error}</span>}
      </form>

      {/* Tabla */}
      <table className="tabla">
        <thead><tr><th>#</th><th>Nombre</th><th>Documento</th><th>Especialidad</th><th>Horario</th><th>Acciones</th></tr></thead>
        <tbody>
          {lista.map(m => (
            <tr key={m.id}>
              <td>{m.id}</td><td>{m.nombre}</td><td>{m.documento}</td>
              <td>{m.especialidad?.nombre}</td><td>{m.horario}</td>
              <td>
                <button onClick={() => editar(m)} className="btn-edit">Editar</button>
                <button onClick={() => eliminar(m.id)} className="btn-delete">Eliminar</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}


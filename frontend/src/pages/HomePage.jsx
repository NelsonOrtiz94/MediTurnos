export default function HomePage() {
  return (
    <div>
      <h2>Bienvenido a MediTurnos 🏥</h2>
      <p style={{ marginTop: 12, color: '#555', lineHeight: 1.7 }}>
        Sistema de gestión de turnos para consultorios médicos.<br />
        Utiliza el menú lateral para navegar entre los módulos:
      </p>
      <ul style={{ marginTop: 16, lineHeight: 2.2, paddingLeft: 24 }}>
        <li>🔬 <strong>Especialidades</strong> — Administra las especialidades médicas</li>
        <li>👨‍⚕️ <strong>Médicos</strong> — Registra y consulta el equipo médico</li>
        <li>🧑 <strong>Pacientes</strong> — Gestiona la base de pacientes</li>
        <li>📅 <strong>Citas</strong> — Agenda, reprograma, cancela y consulta la agenda diaria</li>
      </ul>
    </div>
  );
}


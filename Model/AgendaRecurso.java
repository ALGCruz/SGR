package Model;

import javax.persistence.*;

@Entity
@Table(name = "Agendas_Recursos")
public class AgendaRecurso {

    @Id
    @ManyToOne
    @JoinColumn(name = "agenda", nullable = false)
    private Agenda agenda;

    @Id
    @ManyToOne
    @JoinColumn(name = "recurso", nullable = false)
    private Recurso recurso;

    @Column(nullable = false, length = 1)
    private String executada;

    @Column
    private String apontamentos;

    // Construtor padrão requerido por JPA
    public AgendaRecurso() {}

    // Construtor com argumentos
    public AgendaRecurso(Agenda agenda, Recurso recurso, String executada, String apontamentos) {
        this.agenda = agenda;
        this.recurso = recurso;
        this.executada = executada;
        this.apontamentos = apontamentos;
    }

    public Agenda getAgenda() {
        return agenda;
    }

    public void setAgenda(Agenda agenda) {
        this.agenda = agenda;
    }

    public Recurso getRecurso() {
        return recurso;
    }

    public void setRecurso(Recurso recurso) {
        this.recurso = recurso;
    }

    public String getExecutada() {
        return executada;
    }

    public void setExecutada(String executada) {
        this.executada = executada;
    }

    public String getApontamentos() {
        return apontamentos;
    }

    public void setApontamentos(String apontamentos) {
        this.apontamentos = apontamentos;
    }

    @Override
    public String toString() {
        return "AgendaRecurso [agenda=" + agenda + ", recurso=" + recurso + ", executada=" + executada
                + ", apontamentos=" + apontamentos + "]";
    }

}

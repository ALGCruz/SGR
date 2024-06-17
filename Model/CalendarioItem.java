package Model;

import javax.persistence.*;

@Entity
@Table(name = "Calendarios_Itens")
public class CalendarioItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int item;

    @ManyToOne
    @JoinColumn(name = "calendario", nullable = false)
    private Calendario calendario;

    @Column(nullable = false, length = 1)
    private String diaSemana;

    @Column(nullable = false)
    private float hrInicio;

    @Column(nullable = true)
    private float hrFim;

    // Construtor padrão requerido por JPA
    public CalendarioItem() {}

    // Construtor com argumentos
    public CalendarioItem(int item, Calendario calendario, String diaSemana, float hrInicio, float hrFim) {
        this.item = item;
        this.calendario = calendario;
        this.diaSemana = diaSemana;
        this.hrInicio = hrInicio;
        this.hrFim = hrFim;
    }

    public int getItem() {
        return item;
    }

    public Calendario getCalendario() {
        return calendario;
    }

    public void setCalendario(Calendario calendario) {
        this.calendario = calendario;
    }

    public String getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(String diaSemana) {
        this.diaSemana = diaSemana;
    }

    public float getHrInicio() {
        return hrInicio;
    }

    public void setHrInicio(float hrInicio) {
        this.hrInicio = hrInicio;
    }

    public float getHrFim() {
        return hrFim;
    }

    public void setHrFim(float hrFim) {
        this.hrFim = hrFim;
    }

    @Override
    public String toString() {
        return "CalendarioItem [item=" + item + ", calendario=" + calendario + ", diaSemana=" + diaSemana
                + ", hrInicio=" + hrInicio + ", hrFim=" + hrFim + "]";
    }

}

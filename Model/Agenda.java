package Model;


import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Agendas")
public class Agenda {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "cliente", nullable = false)
    private Cliente cliente;

    @Column(nullable = false)
    @Temporal(TemporalType.DATE)
    private Date data;

    @Column(nullable = false)
    private float hrInicio;

    @Column(nullable = false)
    private float hrFim;

    @Column(nullable = false)
    private float valor;

    @Column(nullable = false, length = 1)
    private String status;

    @Column
    private String obs;

    // Construtor padrão requerido por JPA
    public Agenda() {}

    // Construtor com argumentos
    public Agenda(int id, Cliente cliente, Date data, float hrInicio, float hrFim, float valor, String status, String obs) {
        this.id = id;
        this.cliente = cliente;
        this.data = data;
        this.hrInicio = hrInicio;
        this.hrFim = hrFim;
        this.valor = valor;
        this.status = status;
        this.obs = obs;
    }

    // Getters e Setters

    public int getId() {
        return id;
    }

    public Cliente getCliente() {
        return cliente;
    }

    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
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

    public float getValor() {
        return valor;
    }

    public void setValor(float valor) {
        this.valor = valor;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getObs() {
        return obs;
    }

    public void setObs(String obs) {
        this.obs = obs;
    }

    @Override
    public String toString() {
        return "Agenda [id=" + id + ", cliente=" + cliente + ", data=" + data + ", hrInicio=" + hrInicio + ", hrFim="
                + hrFim + ", valor=" + valor + ", status=" + status + ", obs=" + obs + "]";
    }
    
}

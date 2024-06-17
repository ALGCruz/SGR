package Model;

import javax.persistence.*;

@Entity
@Table(name = "Recursos")
public class Recurso {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 80)
    private String nome;

    @Column(nullable = false, length = 1)
    private String tipo;

    @ManyToOne
    @JoinColumn(name = "calendario", nullable = false)
    private Calendario calendario;

    @Column(nullable = false)
    private float valor;

    @Column(nullable = false)
    private float custo;

    @Column(length = 1)
    private String ativo;

    // Construtor padrão requerido por JPA
    public Recurso() {}

    // Construtor com argumentos
    public Recurso(int id, String nome, String tipo, Calendario calendario, float valor, float custo, String ativo) {
        this.id = id;
        this.nome = nome;
        this.tipo = tipo;
        this.calendario = calendario;
        this.valor = valor;
        this.custo = custo;
        this.ativo = ativo;
    }

    public int getId() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public Calendario getCalendario() {
        return calendario;
    }

    public void setCalendario(Calendario calendario) {
        this.calendario = calendario;
    }

    public float getValor() {
        return valor;
    }

    public void setValor(float valor) {
        this.valor = valor;
    }

    public float getCusto() {
        return custo;
    }

    public void setCusto(float custo) {
        this.custo = custo;
    }

    public String getAtivo() {
        return ativo;
    }

    public void setAtivo(String ativo) {
        this.ativo = ativo;
    }

    @Override
    public String toString() {
        return "Recurso [id=" + id + ", nome=" + nome + ", tipo=" + tipo + ", calendario=" + calendario + ", valor="
                + valor + ", custo=" + custo + ", ativo=" + ativo + "]";
    }
}

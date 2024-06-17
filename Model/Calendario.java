package Model;

import javax.persistence.*;

@Entity
@Table(name = "Calendarios")
public class Calendario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 80)
    private String nome;

    @Column(nullable = false, length = 1)
    private String intervalo;

    @Column(nullable = false, length = 1)
    private String ativo;

    // Construtor padrão requerido por JPA
    public Calendario() {}

    // Construtor com argumentos
    public Calendario(int id, String nome, String intervalo, String ativo) {
        this.id = id;
        this.nome = nome;
        this.intervalo = intervalo;
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

    public String getIntervalo() {
        return intervalo;
    }

    public void setIntervalo(String intervalo) {
        this.intervalo = intervalo;
    }

    public String getAtivo() {
        return ativo;
    }

    public void setAtivo(String ativo) {
        this.ativo = ativo;
    }

    @Override
    public String toString() {
        return "Calendario [id=" + id + ", nome=" + nome + ", intervalo=" + intervalo + ", ativo=" + ativo + "]";
    }

}

package Model;

import javax.persistence.*;

@Entity
@Table(name = "Clientes")
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, length = 120)
    private String nome;

    @Column(nullable = false, length = 1)
    private String tipo;

    @Column(nullable = false, length = 14, unique = true)
    private String cpfCnpj;

    @Column(length = 80)
    private String endereco;

    @Column(length = 9)
    private String numero;

    @Column(length = 60)
    private String bairro;

    @Column(length = 80)
    private String cidade;

    @Column(length = 2)
    private String estado;

    @Column(nullable = false, length = 14)
    private String telefone;

    @Column(length = 120)
    private String email;

    // Construtor padrão requerido por JPA
    public Cliente() {}

    // Construtor com argumentos
    public Cliente(int id, String nome, String tipo, String cpfCnpj, String endereco, String numero, String bairro, String cidade, String estado, String telefone, String email) {
        this.id = id;
        this.nome = nome;
        this.tipo = tipo;
        this.cpfCnpj = cpfCnpj;
        this.endereco = endereco;
        this.numero = numero;
        this.bairro = bairro;
        this.cidade = cidade;
        this.estado = estado;
        this.telefone = telefone;
        this.email = email;
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

    public String getCpfCnpj() {
        return cpfCnpj;
    }

    public void setCpfCnpj(String cpfCnpj) {
        this.cpfCnpj = cpfCnpj;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getBairro() {
        return bairro;
    }

    public void setBairro(String bairro) {
        this.bairro = bairro;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Cliente [id=" + id + ", nome=" + nome + ", tipo=" + tipo + ", cpfCnpj=" + cpfCnpj + ", endereco="
                + endereco + ", numero=" + numero + ", bairro=" + bairro + ", cidade=" + cidade + ", estado=" + estado
                + ", telefone=" + telefone + ", email=" + email + "]";
    }

}

package Model;

import javax.persistence.*;

@Entity
@Table(name = "Usuarios")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(nullable = false, unique = true, length = 20)
    private String user;

    @Column(nullable = false, length = 40)
    private String password;

    @Column(nullable = false, length = 1)
    private String superusuario;

    @Column(length = 1)
    private String ativo;

    // Construtor padrão requerido por JPA
    public Usuario() {}

    // Construtor com argumentos
    public Usuario(int id, String user, String password, String superusuario, String ativo) {
        this.id = id;
        this.user = user;
        this.password = password;
        this.superusuario = superusuario;
        this.ativo = ativo;
    }

    public int getId() {
        return id;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSuperusuario() {
        return superusuario;
    }

    public void setSuperusuario(String superusuario) {
        this.superusuario = superusuario;
    }

    public String getAtivo() {
        return ativo;
    }

    public void setAtivo(String ativo) {
        this.ativo = ativo;
    }

    @Override
    public String toString() {
        return "Usuario [id=" + id + ", user=" + user + ", password=" + password + ", superusuario=" + superusuario
                + ", ativo=" + ativo + "]";
    }
}

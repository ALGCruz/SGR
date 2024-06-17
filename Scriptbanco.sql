-- Database: SGR
-- DROP DATABASE IF EXISTS "SGR";
CREATE DATABASE "SGR"
WITH
OWNER = postgres
ENCODING = 'UTF8'
LC_COLLATE = 'Portuguese_Brazil.1252'
LC_CTYPE = 'Portuguese_Brazil.1252'
TABLESPACE = pg_default
CONNECTION LIMIT = -1
IS_TEMPLATE = False;
COMMENT ON DATABASE "SGR"
IS 'Banco de dados do Sistema de Gerenciamento de Recursos';

GRANT TEMPORARY, CONNECT ON DATABASE "SGR" TO PUBLIC;
GRANT CREATE, CONNECT ON DATABASE "SGR" TO postgres;
GRANT TEMPORARY ON DATABASE "SGR" TO postgres WITH GRANT OPTION;
GRANT TEMPORARY ON DATABASE "SGR" TO "user" WITH GRANT OPTION;
GRANT TEMPORARY ON DATABASE "SGR" TO "sgr" WITH GRANT OPTION;

-- Switch to the new database
\connect SGR

-- Table: public.Clientes
-- DROP TABLE IF EXISTS public."Clientes";
CREATE TABLE IF NOT EXISTS public."Clientes"
(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    tipo VARCHAR(1) NOT NULL DEFAULT 'F',
    cpf_cnpj VARCHAR(14) NOT NULL,
    endereco VARCHAR(80),
    numero VARCHAR(9),
    bairro VARCHAR(60),
    cidade VARCHAR(80),
    estado VARCHAR(2),
    telefone VARCHAR(14) NOT NULL,
    "e-mail" VARCHAR(120),
    CONSTRAINT "Clientes_cpf_cnpj_UK" UNIQUE (cpf_cnpj),
    CONSTRAINT "Clientes_tipo_check" CHECK (tipo IN ('F', 'J'))
);
COMMENT ON TABLE public."Clientes" IS 'Tabela de clientes';

-- Table: public.Recursos
-- DROP TABLE IF EXISTS public."Recursos";
CREATE TABLE IF NOT EXISTS public."Recursos"
(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    tipo VARCHAR(1) NOT NULL DEFAULT 'P',
    calendario INTEGER NOT NULL,
    valor REAL NOT NULL,
    custo REAL NOT NULL,
    ativo VARCHAR(1) DEFAULT 'S',
    CONSTRAINT "Recursos_calendario_fk" FOREIGN KEY (calendario) REFERENCES public."Calendarios" (id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT "Recursos_ativo_check" CHECK (ativo IN ('S', 'N')),
    CONSTRAINT "Recursos_custo_check" CHECK (custo >= 0),
    CONSTRAINT "Recursos_tipo_check" CHECK (tipo IN ('P', 'E', 'L')),
    CONSTRAINT "Recursos_valor_check" CHECK (valor >= 0)
);
COMMENT ON TABLE public."Recursos" IS 'Tabela de recursos';

-- Table: public.Usuarios
-- DROP TABLE IF EXISTS public."Usuarios";
CREATE TABLE IF NOT EXISTS public."Usuarios"
(
    id SERIAL PRIMARY KEY,
    "user" VARCHAR(20) NOT NULL,
    password VARCHAR(40) NOT NULL,
    superusuario VARCHAR(1) NOT NULL,
    ativo VARCHAR(1),
    CONSTRAINT "Usuarios_user_uniq" UNIQUE ("user"),
    CONSTRAINT "Usuarios_ativo_check" CHECK (ativo IN ('S', 'N')),
    CONSTRAINT "Usuarios_superusuario_check" CHECK (superusuario IN ('S', 'N'))
);
COMMENT ON TABLE public."Usuarios" IS 'Tabela de usuários';

-- Table: public.Calendarios
-- DROP TABLE IF EXISTS public."Calendarios";
CREATE TABLE IF NOT EXISTS public."Calendarios"
(
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    intervalo VARCHAR(1) NOT NULL DEFAULT '1',
    ativo VARCHAR(1) NOT NULL DEFAULT 'S',
    CONSTRAINT "Calendarios_ativo_check" CHECK (ativo IN ('S', 'N')),
    CONSTRAINT "Calendarios_intervalo_check" CHECK (intervalo IN ('1', '2', '3'))
);
COMMENT ON TABLE public."Calendarios" IS 'Tabela de calendários';
COMMENT ON COLUMN public."Calendarios".intervalo IS '1- 15 minutos\n2 - 30 Minutos\n3 - 1 hora';
COMMENT ON COLUMN public."Calendarios".ativo IS 'S - Sim\nN - Não';

-- Table: public.Calendarios_Itens
-- DROP TABLE IF EXISTS public."Calendarios_Itens";
-- Sequence: public."Calendarios_Itens_item_seq"
CREATE SEQUENCE IF NOT EXISTS public."Calendarios_Itens_item_seq"
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 2147483647
    START WITH 1
    CACHE 1;
ALTER SEQUENCE public."Calendarios_Itens_item_seq" OWNER TO postgres;


CREATE TABLE IF NOT EXISTS public."Calendarios_Itens"
(
    calendario INTEGER NOT NULL,
    item SMALLINT NOT NULL DEFAULT nextval('"Calendarios_Itens_item_seq"'::regclass),
    dia_semana VARCHAR(1) NOT NULL,
    hr_inicio REAL NOT NULL DEFAULT 8.0,
    hr_fim REAL DEFAULT 18.0,
    CONSTRAINT "Calendarios_Itens_PK" PRIMARY KEY (calendario, item),
    CONSTRAINT "Calendarios_Calendarios_Itens_FK" FOREIGN KEY (calendario) REFERENCES public."Calendarios" (id) ON UPDATE RESTRICT ON DELETE CASCADE,
    CONSTRAINT "Calendarios_dia_semana_check" CHECK (dia_semana IN ('D', '2', '3', '4', '5', '6', 'S')),
    CONSTRAINT "Calendarios_hr_fim_check" CHECK (hr_fim >= 0 AND hr_fim <= 24 AND hr_fim > hr_inicio),
    CONSTRAINT "Calendarios_hr_inicio_check" CHECK (hr_inicio >= 0 AND hr_inicio <= 24 AND hr_inicio < hr_fim)
);
COMMENT ON TABLE public."Calendarios_Itens" IS 'Tabela de itens de calendários';

-- Table: public.Agendas
-- DROP TABLE IF EXISTS public."Agendas";
CREATE TABLE IF NOT EXISTS public."Agendas"
(
    id SERIAL PRIMARY KEY,
    cliente INTEGER NOT NULL,
    data DATE NOT NULL,
    hr_inicio REAL NOT NULL,
    hr_fim REAL NOT NULL,
    valor REAL NOT NULL,
    status VARCHAR(1) NOT NULL DEFAULT 'A',
    obs TEXT,
    CONSTRAINT "Agendas_Clientes_FK" FOREIGN KEY (cliente) REFERENCES public."Clientes" (id) ON UPDATE RESTRICT ON DELETE RESTRICT,
    CONSTRAINT "Agendas_hr_fim_check" CHECK (hr_fim >= 0 AND hr_fim <= 24 AND hr_inicio < hr_fim),
    CONSTRAINT "Agendas_hr_inicio_check" CHECK (hr_inicio >= 0 AND hr_inicio <= 24 AND hr_inicio < hr_fim),
    CONSTRAINT "Agendas_status_check" CHECK (status IN ('P', 'A', 'D')),
    CONSTRAINT "Agendas_valor_check" CHECK (valor >= 0)
);
COMMENT ON TABLE public."Agendas" IS 'Tabela de agendas';
COMMENT ON COLUMN public."Agendas".status IS '''A'' - Pagamento Aberto\n''P'' - Pagamento efetuado\n''D'' - Dação';

-- Table: public.Agendas_Recursos
-- DROP TABLE IF EXISTS public."Agendas_Recursos";
CREATE TABLE IF NOT EXISTS public."Agendas_Recursos"
(
    agenda INTEGER NOT NULL,
    recurso INTEGER NOT NULL,
    executada VARCHAR(1) NOT NULL DEFAULT 'P',
    apontamentos TEXT,
    CONSTRAINT "Agendas_Recursos_PK" PRIMARY KEY (agenda, recurso),
    CONSTRAINT "Agendas_Agendas_Recursos_FK" FOREIGN KEY (agenda) REFERENCES public."Agendas" (id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT "Recursos_Agendas_Recursos_FK" FOREIGN KEY (recurso) REFERENCES public."Recursos" (id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT "Agendas_Recursos_apontamentos_check" CHECK (apontamentos IN ('A', 'P'))
);
COMMENT ON TABLE public."Agendas_Recursos" IS 'Tabela de recursos das agendas';
COMMENT ON COLUMN public."Agendas_Recursos".apontamentos IS 'A - Aberto\nP - Apontado';


--INSERTS

-- Tabela Usuarios
INSERT INTO public."Usuarios"("user", password, superusuario, ativo)
VALUES ('usr001', '14#$m0-46sA#', 'N', 'S');
INSERT INTO public."Usuarios"("user", password, superusuario, ativo)
VALUES ('usr002', '*(kl6d)Sr7(&', 'N', 'S');
INSERT INTO public."Usuarios"("user", password, superusuario, ativo)
VALUES ('adm001', '90i\ *nm132*', 'S', 'S');


-- Tabela Clientes
INSERT INTO public."Clientes"(nome, tipo, cpf_cnpj, endereco, numero, bairro, cidade, estado, telefone, "e-mail")
VALUES ('Amélia Isabela Bonilha Casanova de Garcia'
, 'F'
, '06508101048'
, 'Rua Francisco Rodrigues'
, '256'
, 'Centro'
, 'Afrânio'
, 'PE'
, '87998337681'
, 'agarcia@gmail.com');
INSERT INTO public."Clientes"(nome, tipo, cpf_cnpj, endereco, numero, bairro, cidade, estado, telefone, "e-mail")
VALUES ('Denis Abreu Balestero'
, 'F'
, ' 74236526280'
, 'Rua Santo Estevam'
, '762'
, 'Jardim Lolata'
, 'Londrina'
, 'PR'
, '43984335790'
, 'dabalestro@yahoo.com');
INSERT INTO public."Clientes"(nome, tipo, cpf_cnpj, endereco, numero, bairro, cidade, estado, telefone, "e-mail")
VALUES (' Pegolulu Ltda ME'
, 'J'
, '89722187000140'
, 'Rua Santo Estevam'
, '762'
, 'Jardim Lolata'
, 'Zé Doca'
, 'MA'
, '9822469488'
, 'contato@pegolulu.com.br');


-- Tabela Calendarios
INSERT INTO public."Calendarios"(nome, intervalo, ativo)
VALUES ('Padrão', '1', 'S');
INSERT INTO public."Calendarios"(nome, intervalo, ativo)
VALUES ('30 Mins', '2', 'S');
INSERT INTO public."Calendarios"(nome, intervalo, ativo)
VALUES ('Hora', '3', 'S');


-- Tabela Calendarios Itens
-- Para inserir os valores no tipo REAL
INSERT INTO public."Calendarios_Itens"(calendario, dia_semana, hr_inicio, hr_fim)
VALUES (1, '2', '8.00', '18.00'),
       (1, '3', '8.00', '18.00'),
       (1, '4', '8.00', '18.00'),
       (1, '5', '8.00', '18.00'),
       (1, '6', '8.00', '18.00'),
       (2, '2', '8.00', '18.00'),
       (2, '3', '8.00', '18.00'),
       (2, '4', '8.00', '18.00'),
       (2, '5', '8.00', '18.00'),
       (2, '6', '8.00', '18.00'),
       (3, '2', '8.00', '18.00'),
       (3, '3', '8.00', '18.00'),
       (3, '4', '8.00', '18.00'),
       (3, '5', '8.00', '18.00'),
       (3, '6', '8.00', '18.00');

-- Tabela Recursos
INSERT INTO public."Recursos"(nome, tipo, calendario, valor, custo, ativo)
VALUES ('Recurso 001', 'P', 1, 120, 60, 'S');
INSERT INTO public."Recursos"(nome, tipo, calendario, valor, custo, ativo)
VALUES ('Recurso 002', 'E', 1, 120, 60, 'S');
INSERT INTO public."Recursos"(nome, tipo, calendario, valor, custo, ativo)
VALUES ('Recurso 003', 'L', 1, 120, 60, 'S');

-- Tabela Agendas

INSERT INTO public."Agendas"(cliente, data, hr_inicio, hr_fim, valor)
VALUES (1, '22/08/2025', '09.00', '10.00', 2700.00);
INSERT INTO public."Agendas"(cliente, data, hr_inicio, hr_fim, valor)
VALUES (2, '13/09/2024', '13.00', '18.00', 7200.00);
INSERT INTO public."Agendas"(cliente, data, hr_inicio, hr_fim, valor, obs)
VALUES (2, '11/06/2024', '11.00', '12.00', 800.00, 'Observação da agenda... pode ser qualquer coisa');

-- Tabela Agendas_Recursos

INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (1, 1, 'A');
INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (1, 2, 'A');
INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (1, 3, 'A');
INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (2, 1, 'A');
INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (2, 3, 'A');
INSERT INTO public."Agendas_Recursos"(agenda, recurso, executada)
VALUES (3, 3, 'A');

SELECT *FROM "Agendas";

-- UPDATES

UPDATE public."Clientes"
SET nome = 'Amélia Isabela B. C. Garcia', "e-mail" = 'amelia.garcia@gmail.com'
WHERE cpf_cnpj = '06508101048';

UPDATE public."Agendas"
SET status = 'P'
WHERE id = 1;

UPDATE public."Recursos"
SET valor = 150.0, custo = 75.0
WHERE nome = 'Recurso 001';

UPDATE public."Usuarios"
SET password = 'newpassword123'
WHERE "user" = 'usr002';

UPDATE public."Calendarios"
SET intervalo = '2'
WHERE nome = 'Padrão';

-- deletes

DELETE FROM public."Usuarios"
WHERE "user" = 'usr002';

DELETE FROM public."Clientes"
WHERE cpf_cnpj = '89722187000140';

DELETE FROM public."Calendarios_Itens"
WHERE calendario = 1 AND item = 1;

DELETE FROM public."Recursos"
WHERE nome = 'Recurso 003';

DELETE FROM public."Agendas_Recursos"
WHERE agenda = 2 AND recurso = 1;


-- SELECTS COM JOIN

SELECT c.nome AS cliente_nome, c.telefone, a.data, a.hr_inicio, a.hr_fim, a.valor
FROM public."Clientes" c
JOIN public."Agendas" a ON c.id = a.cliente;

SELECT a.id AS agenda_id, a.data, a.hr_inicio, a.hr_fim, r.nome AS recurso_nome, ar.executada
FROM public."Agendas" a
JOIN public."Agendas_Recursos" ar ON a.id = ar.agenda
JOIN public."Recursos" r ON ar.recurso = r.id;

SELECT r.nome AS recurso_nome, r.tipo, r.valor, c.nome AS calendario_nome, c.ativo
FROM public."Recursos" r
JOIN public."Calendarios" c ON r.calendario = c.id;

SELECT u."user" AS usuario, a.id AS agenda_id, a.data, a.hr_inicio, a.hr_fim, c.nome AS cliente_nome
FROM public."Usuarios" u
JOIN public."Agendas" a ON u.id = a.cliente
JOIN public."Clientes" c ON a.cliente = c.id;

SELECT c.nome AS calendario_nome, ci.dia_semana, ci.hr_inicio, ci.hr_fim
FROM public."Calendarios" c
JOIN public."Calendarios_Itens" ci ON c.id = ci.calendario;

--procedures

CREATE OR REPLACE PROCEDURE insert_cliente(
    nome VARCHAR,
    tipo CHAR,
    cpf_cnpj VARCHAR,
    endereco VARCHAR,
    numero VARCHAR,
    bairro VARCHAR,
    cidade VARCHAR,
    estado CHAR,
    telefone VARCHAR,
    email VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public."Clientes" (nome, tipo, cpf_cnpj, endereco, numero, bairro, cidade, estado, telefone, "e-mail")
    VALUES (nome, tipo, cpf_cnpj, endereco, numero, bairro, cidade, estado, telefone, email);
END;
$$;

CREATE OR REPLACE PROCEDURE update_cliente_endereco(
    cliente_id INTEGER,
    novo_endereco VARCHAR,
    novo_numero VARCHAR,
    novo_bairro VARCHAR,
    nova_cidade VARCHAR,
    novo_estado CHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public."Clientes"
    SET endereco = novo_endereco, numero = novo_numero, bairro = novo_bairro, cidade = nova_cidade, estado = novo_estado
    WHERE id = cliente_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_cliente(cliente_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public."Clientes"
    WHERE id = cliente_id;
END;
$$;

CREATE OR REPLACE PROCEDURE insert_recurso(
    nome VARCHAR,
    tipo CHAR,
    calendario INTEGER,
    valor REAL,
    custo REAL,
    ativo CHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public."Recursos" (nome, tipo, calendario, valor, custo, ativo)
    VALUES (nome, tipo, calendario, valor, custo, ativo);
END;
$$;


CREATE OR REPLACE PROCEDURE update_recurso_valor(
    recurso_id INTEGER,
    novo_valor REAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public."Recursos"
    SET valor = novo_valor
    WHERE id = recurso_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_recurso(recurso_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM public."Recursos"
    WHERE id = recurso_id;
END;
$$;

-- triggers 

CREATE OR REPLACE FUNCTION validate_hr_fim()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.hr_fim <= NEW.hr_inicio THEN
        RAISE EXCEPTION 'hr_fim deve ser maior que hr_inicio';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validate_hr_fim
BEFORE INSERT OR UPDATE ON public."Agendas"
FOR EACH ROW
EXECUTE FUNCTION validate_hr_fim();


CREATE OR REPLACE FUNCTION update_recurso_status()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.custo > 1000 THEN
        NEW.ativo := 'N';
    ELSE
        NEW.ativo := 'S';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_recurso_status
BEFORE INSERT OR UPDATE ON public."Recursos"
FOR EACH ROW
EXECUTE FUNCTION update_recurso_status();


CREATE OR REPLACE FUNCTION handle_recurso_delete()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM public."Agendas_Recursos" WHERE recurso = OLD.id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_recurso_delete
AFTER DELETE ON public."Recursos"
FOR EACH ROW
EXECUTE FUNCTION handle_recurso_delete();




















-- Active: 1689168282605@@127.0.0.1@5432@resilidata

CREATE DATABASE RESILIDATA;

CREATE TYPE status_enum AS ENUM ('ativo', 'inativo');

CREATE TABLE ESTUDANTE(
	id_estudante serial primary key,
	nome_estudante varchar(50) not null,
	data_nascimento date,
	email_aluno varchar(50) not null,
	endereco_estudante varchar(100),
	telefone_estudante varchar(20),
	cpf_estudante varchar(14) unique not null,
	status status_enum default 'ativo'
	
);

CREATE TABLE TURMA(
	id_turma serial primary key,
	nome_turma varchar(30) not null,
	ano_turma int,
	quantidade_alunos int
);

CREATE TABLE CURSO(
	id_curso serial primary key,
	nome_curso varchar(50) not null,
	descricao_curso varchar(255) not null,
	duracao_curso int,
	data_inicio date,
	data_fim date
	
);

CREATE TABLE MODULO(
	id_modulo serial primary key,
	nome_modulo varchar(50) not null,
	descricao_modulo varchar(255) not null,
	carga_horaria int,
	data_inicio date,
	data_fim date
);

CREATE TABLE FACILITADOR(
	id_facilitador serial primary key,
	nome_facilitador varchar(50) not null,
	email_facilitador varchar(100) not null,
	data_nascimento date,
	endereco_facilitador varchar(100),
	cpf_facilitador varchar(14) unique not null
);

CREATE TABLE LOG_ESTUDANTE (
    id_log serial primary key,
    id_estudante int references estudante (id_estudante),
    data_hora timestamp default current_timestamp,
    status_anterior status_enum not null,
    status_atual status_enum not null
);


CREATE TABLE RESILIA(
	id serial primary key,
	estudante_id int REFERENCES ESTUDANTE(id_estudante),
	turma_id int REFERENCES TURMA(id_turma),
	modulo_id int REFERENCES MODULO(id_modulo),
	curso_id int REFERENCES CURSO(id_curso),
	facilitador_id int REFERENCES FACILITADOR(id_facilitador),
	data_registro date
);


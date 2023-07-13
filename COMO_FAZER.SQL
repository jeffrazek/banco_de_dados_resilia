--1. Selecionar a quantidade total de estudantes cadastrados no banco;
SELECT count(*) as "Quantidade de Estudantes" FROM estudante;

--2. Selecionar quais pessoas facilitadoras atuam em mais de uma turma;
SELECT facilitador_id as "id", f.nome_facilitador as "Nome", count(curso_id) as "Quantidade de turmas"
FROM resilia  
JOIN facilitador f ON facilitador_id = id_facilitador  
GROUP BY facilitador_id, f.nome_facilitador 
HAVING count(curso_id) > 1 
ORDER BY facilitador_id;

3--Crie uma view que selecione a porcentagem de estudantes com status de evasão agrupados por turma;


CREATE VIEW evasao_por_turma AS
SELECT t.nome_turma, 
       COUNT(CASE WHEN e.status = 'inativo' THEN 1 END) AS quantidade_evasao,
       COUNT(*) AS quantidade_total,
       ROUND((COUNT(CASE WHEN e.status = 'inativo' THEN 1 END) * 100.0) / COUNT(*), 2) AS porcentagem_evasao
FROM TURMA t
JOIN RESILIA r ON t.id_turma = r.turma_id
JOIN ESTUDANTE e ON r.estudante_id = e.id_estudante
GROUP BY t.nome_turma;

SELECT * FROM evasao_por_turma;


4--Crie um trigger para ser disparado quando o atributo status de um estudante for atualizado e inserir um novo dado em uma tabela de log.

CREATE OR REPLACE FUNCTION register_log_estud()
RETURNS TRIGGER AS $$
BEGIN
	IF OLD.status <> NEW.status THEN
		INSERT INTO log_estudante (
			id_estudante,
			status_anterior,
			status_atual,
			data_hora
		)
		VALUES (
			NEW.id_estudante,
			OLD.status,
			NEW.status,
			current_timestamp
		);
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

-- Criar a trigger que executa a função de log
CREATE OR REPLACE TRIGGER trigger_register
AFTER UPDATE ON estudante
FOR EACH ROW
EXECUTE FUNCTION register_log_estud();

-- Questão que deverá ser respondida por scripts SQL que combine pelo menos 3 tabelas.
-- Quantidade de alunos por turma e Curso

SELECT T.nome_turma, C.nome_curso, COUNT(*) AS numero_estudantes
FROM TURMA T
JOIN RESILIA R ON T.id_turma = R.turma_id
JOIN ESTUDANTE E ON R.estudante_id = E.id_estudante
JOIN CURSO C ON R.curso_id = C.id_curso
GROUP BY T.nome_turma, C.nome_curso
ORDER BY T.nome_turma ASC;

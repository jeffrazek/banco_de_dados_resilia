-- Criar a função que cria o log da entidade estudante
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
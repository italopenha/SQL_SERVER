USE [TESTE]

INSERT INTO TB_CLIENTE
(NOME, CPF, DATA_NASCIMENTO, EMAIL)
VALUES
('Ítalo', '23088746863', '1997-09-17', 'italo@email.com'),
('Marcos Pereira', '44444444444', '1985-09-17', 'marcos@email.com'),
('Ana Lúcia', '55555555555', '1988-09-17', 'ana@email.com'),
('Marta Fonseca', '66666666666', '1988-09-17', 'marta@email.com'),
('Marta Fonseca', '66666666666', '1988-09-17', 'marta@email.com');

SELECT TOP 3 * FROM TB_CLIENTE;

SELECT DISTINCT Nome, CPF, Data_Nascimento, Email FROM TB_CLIENTE;


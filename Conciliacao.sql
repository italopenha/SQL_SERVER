-- =============================================
-- ESTRUTURA ORGANIZADA COM CTEs SEPARADAS
-- =============================================

WITH CONSULTA_A AS (
    -- *** PRIMEIRA CTE: SELECT DO SISTEMA A ***
    SELECT 
        ID_VENDA,
        PRODUTO,
        QUANTIDADE,
        VALOR_UNITARIO,
        DATA_VENDA,
        VENDEDOR
    FROM VENDAS_SISTEMA_A
),

CONSULTA_B AS (
    -- *** SEGUNDA CTE: SELECT DO SISTEMA B ***
    SELECT 
        ID_VENDA,
        PRODUTO,
        QUANTIDADE,
        VALOR_UNITARIO,
        DATA_VENDA,
        CLIENTE
    FROM VENDAS_SISTEMA_B
),

CONCILIACAO_FINAL AS (
    -- *** TERCEIRA CTE: CONCILIAÇÃO ENTRE A E B ***
    SELECT 
        COALESCE(A.ID_VENDA, B.ID_VENDA) as ID_VENDA,
        COALESCE(A.PRODUTO, B.PRODUTO) as PRODUTO,
        A.QUANTIDADE as QTD_SISTEMA_A,
        B.QUANTIDADE as QTD_SISTEMA_B,
		CASE 
            WHEN A.QUANTIDADE IS NOT NULL AND B.QUANTIDADE IS NOT NULL 
            THEN ABS(A.QUANTIDADE - B.QUANTIDADE) 
            ELSE NULL 
        END as DIF_QTD,
		CASE
			WHEN A.QUANTIDADE IS NOT NULL AND B.QUANTIDADE IS NOT NULL THEN
				CASE
					WHEN ABS(A.QUANTIDADE - B.QUANTIDADE) = 0
					THEN 'Quantidades Batidas'
					ELSE 'Quantidades divergentes'
				END
			ELSE 'N/A'
		END AS STATUS_QTD,
        A.VALOR_UNITARIO as VALOR_SISTEMA_A,
        B.VALOR_UNITARIO as VALOR_SISTEMA_B,
		CASE 
			WHEN A.VALOR_UNITARIO IS NOT NULL AND B.VALOR_UNITARIO IS NOT NULL 
            THEN ABS(A.VALOR_UNITARIO - B.VALOR_UNITARIO) 
            ELSE NULL 
        END as DIF_VL,
		CASE 
            WHEN A.VALOR_UNITARIO IS NOT NULL AND B.VALOR_UNITARIO IS NOT NULL THEN
                CASE 
                    WHEN ABS(A.VALOR_UNITARIO - B.VALOR_UNITARIO) = 0
                    THEN 'Valores Batidos'
                    ELSE 'Valores divergentes'
                END
			ELSE 'N/A'
        END AS STATUS_VL,
        A.DATA_VENDA as DATA_SISTEMA_A,
        B.DATA_VENDA as DATA_SISTEMA_B,
		CASE 
            WHEN A.DATA_VENDA IS NOT NULL AND B.DATA_VENDA IS NOT NULL THEN
                CASE 
                    WHEN A.DATA_VENDA = B.DATA_VENDA
                    THEN 'Datas Batidas'
                    ELSE 'Datas divergentes'
                END
            ELSE 'N/A'
        END AS STATUS_DATAS,
        A.VENDEDOR,
        B.CLIENTE,
        CASE 
            WHEN A.ID_VENDA IS NULL THEN 'Apenas no Sistema B'
            WHEN B.ID_VENDA IS NULL THEN 'Apenas no Sistema A'
            WHEN A.QUANTIDADE <> B.QUANTIDADE OR A.VALOR_UNITARIO <> B.VALOR_UNITARIO THEN 'Divergência de valores'
            ELSE 'Dados iguais'
        END as STATUS_CONCILIACAO
    FROM CONSULTA_A A
    FULL JOIN CONSULTA_B B ON A.ID_VENDA = B.ID_VENDA
)

-- *** CONSULTA PRINCIPAL ***
SELECT * 
FROM CONCILIACAO_FINAL
ORDER BY ID_VENDA;
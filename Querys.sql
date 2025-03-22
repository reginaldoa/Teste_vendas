create database vendas;
use vendas;

CREATE TABLE produtos (
    ID_Venda INT AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    Produto VARCHAR(255) NOT NULL,
    Categoria VARCHAR(100) NOT NULL,
    Regiao VARCHAR(100) NOT NULL,
    Vendedor VARCHAR(100) NOT NULL,
    Quantidade INT NOT NULL,
    Valor_unidade DECIMAL(10,2) NOT NULL,
    Valor_Total DECIMAL(10,2) NOT NULL,
    Meta_do_funcionario DECIMAL(10,2) NOT NULL
);

-- Selecionando tudo para verificar se a importação ocorreu de forma perfeita.
select * from vendas.produtos;

-- Faturamento do último trimestre
SELECT 
    DATE_FORMAT(data, '%Y-%m') AS Mes,
    SUM(Valor_Total) AS Faturamento
FROM produtos
WHERE data BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), '%Y-%m-01')
               AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
GROUP BY Mes
UNION ALL
SELECT 
    'Total' AS Mes,
    SUM(Valor_Total) AS Faturamento
FROM produtos
WHERE data BETWEEN DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 3 MONTH), '%Y-%m-01')
               AND LAST_DAY(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
ORDER BY Mes;






-- Top 3 produtos com maiores receitas
SELECT 
    Produto, 
    SUM(Valor_Total) AS Receita
FROM produtos
GROUP BY Produto
ORDER BY Receita DESC
LIMIT 3;




-- Qual região teve o maior crescimento percentual nas vendas em comparação ao mês anterior?
WITH vendas_mensais AS (
    SELECT 
        Regiao,
        DATE_FORMAT(data, '%Y-%m') AS mes,
        SUM(Valor_Total) AS total_vendas
    FROM produtos
    GROUP BY Regiao, mes
),
crescimento AS (
    SELECT 
        v1.Regiao,
        v1.mes,
        v1.total_vendas,
        v2.total_vendas AS vendas_mes_anterior,
        ((v1.total_vendas - v2.total_vendas) / v2.total_vendas) * 100 AS crescimento_percentual
    FROM vendas_mensais v1
    LEFT JOIN vendas_mensais v2
        ON v1.Regiao = v2.Regiao
        AND DATE_FORMAT(v1.mes, '%Y-%m') = DATE_FORMAT(DATE_ADD(v2.mes, INTERVAL 1 MONTH), '%Y-%m')
)
SELECT Regiao, mes
FROM crescimento
ORDER BY crescimento_percentual DESC
LIMIT 1;



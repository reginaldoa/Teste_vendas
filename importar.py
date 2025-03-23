import pymysql
import pandas as pd

host = "localhost" 
user = "root"
password = "root"
database = "vendas"

#Aqui estou colocando apenas o nome do arquivo, pois está na mesma pasta, senão precisaria ser o caminho completo do CSV
caminho_arquivo = r"vendas.csv"

# Conectar ao banco de dados
conn = pymysql.connect(host=host, user=user, password=password, database=database)
cursor = conn.cursor()

try:
    df = pd.read_csv(caminho_arquivo, delimiter=";", encoding="latin1")  

    
    # Inserir os dados no banco
    for _, row in df.iterrows():
        sql = """
        INSERT INTO vendas.produtos (ID_Venda,data, Produto, Categoria, Regiao, Vendedor, Quantidade, Valor_unidade, Valor_Total, Meta_do_funcionario)
        VALUES ( %s,%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        valores = (
            row["ID_Venda"],
            row["data"], row["Produto"], row["Categoria"], row["Regiao"],
            row["Vendedor"], row["Quantidade"], row["Valor_unidade"],
            row["Valor_Total"], row["Meta_funcionario"]
        )
        cursor.execute(sql, valores)
    
    # Confirmar alterações
    conn.commit()
    print("Dados importados com sucesso!")
except Exception as e:
    print(f"Erro ao importar dados: {e}")
    conn.rollback()
finally:
    cursor.close()
    conn.close()

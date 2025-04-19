USE [Kyoto Digital];

--Creación de las tablas

CREATE TABLE Clientes (
	Cl_ID INT PRIMARY KEY IDENTITY(1,1),
	Cl_Name NVARCHAR(45),
	Cl_Email NVARCHAR(100),
	CL_Town NVARCHAR(100),
);

CREATE TABLE Pedidos(
	P_ID INT PRIMARY KEY IDENTITY(1,1),
	P_CL_ID INT FOREIGN KEY REFERENCES Clientes(Cl_ID),
	P_Date DATETIME DEFAULT GETDATE(),
	P_Cost DECIMAL(10,2),
	P_State NVARCHAR(10)
);

GO

--Inserción de datos

--Clientes

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Clientes (Cl_Name, Cl_Email, CL_Town)
    VALUES (
        'Cliente_' + CAST(@i AS NVARCHAR(10)),
        'cliente' + CAST(@i AS NVARCHAR(10)) + '@example.com',
        'Ciudad_' + CAST(@i AS NVARCHAR(10))
    );

    SET @i = @i + 1;
END;

GO

--Pedidos

DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    INSERT INTO Pedidos (P_CL_ID, P_Cost, P_State)
    VALUES (
        (SELECT TOP 1 Cl_ID FROM Clientes ORDER BY NEWID()),
        ROUND(RAND() * 500 + 50, 2),  -- Genera un costo aleatorio entre 50 y 550
        CASE WHEN @i % 2 = 0 THEN 'complete' ELSE 'uncomplete' END
    );

    SET @i = @i + 1;
END;

GO

--Consultas básicas

SELECT * FROM Clientes

SELECT * FROM Pedidos

--Consulta número de pedidos por cliente y coste medio.

SELECT c.CL_ID AS ID_Cliente,
	   c.Cl_Name AS Nombre,
       COUNT(p.P_ID) AS Número_Pedidos,
       SUM(p.P_Cost) AS Coste_Total,
       FORMAT(ROUND(AVG(p.P_Cost),2), 'N2') AS Coste_Medio
FROM clientes c
JOIN Pedidos p ON c.CL_ID = p.P_CL_ID
GROUP BY c.Cl_ID, c.Cl_Name;

--Consulta clientes que nunca han realizado pedidos.

SELECT c.Cl_ID AS ID_Cliente,
	   c.Cl_Name AS Nombre
FROM clientes c
LEFT JOIN Pedidos p ON c.Cl_ID = p.P_CL_ID
WHERE p.P_CL_ID IS NULL;

--Consulta pedidos ordenados de mayor coste a menor coste.

SELECT c.CL_ID AS ID_Cliente,
	   c.Cl_Name AS Nombre,
	   p.P_Cost AS Coste
FROM clientes c
JOIN Pedidos p ON c.CL_ID = p.P_CL_ID
ORDER BY Coste DESC;
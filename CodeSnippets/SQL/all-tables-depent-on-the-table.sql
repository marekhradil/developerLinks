declare @tableName varchar(100) = 'TableName';

-- CTE to fetch all primary key information.
WITH PrimaryKeys AS (
    SELECT 
        s.name as [Schema], 
        t.name as [Table], 
        c.name as [Column], 
        ic.index_column_id AS [ColumnNumber]
    FROM sys.index_columns ic
    JOIN sys.columns c ON ic.object_id = c.object_id and ic.column_id = c.column_id
    JOIN sys.indexes i ON ic.object_id = i.object_id and ic.index_id = i.index_id
    JOIN sys.tables t ON i.object_id = t.object_id
    JOIN sys.schemas s ON t.schema_id = s.schema_id
    WHERE i.is_primary_key = 1
),
-- CTE to fetch table information.
TableInfo AS (
    SELECT
        tab.name AS [Table],
        col.name AS [Column],
        sch.name AS [Schema],
        tab.object_id AS TableId,
        col.column_id AS ColumnId
    FROM sys.tables tab
    JOIN sys.schemas sch ON tab.schema_id = sch.schema_id
    JOIN sys.columns col ON col.object_id = tab.object_id
)

-- Primary query selecting foreign keys and primary/dependent information.
SELECT
    obj.name AS FK_NAME,
    p.[Schema] AS [PrimarySchema],
    p.[Table] AS [PrimaryTable],
    p.[Column] AS [PrimaryColumn],
    d.[Schema] AS [DependentSchema],
    d.[Table] AS [DependentTable],
    d.[Column] AS [DependentColumn],
    prim.ColumnNumber AS IsDependentPrimaryColumn -- has value if is part of dependent table's primary key
FROM  sys.foreign_key_columns fkc
JOIN sys.objects obj ON obj.object_id = fkc.constraint_object_id
JOIN TableInfo d ON d.TableId = fkc.parent_object_id AND d.ColumnId = fkc.parent_column_id
JOIN TableInfo p ON p.TableId = fkc.referenced_object_id AND p.ColumnId = fkc.referenced_column_id

-- Join in primary key information to determine if the dependent key is also
-- part of the dependent table's primary key.
LEFT JOIN PrimaryKeys prim ON prim.[Column] = d.[Column] AND prim.[Table] = d.[Table]
WHERE p.[Table] = @tableName

ORDER BY [PrimarySchema], [PrimaryTable], [DependentSchema], [DependentTable]
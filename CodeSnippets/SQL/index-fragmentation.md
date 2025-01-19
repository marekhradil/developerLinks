# Index fragmentation

### Fragmentation of indexes

```sql
SELECT a.index_id, tab.name,b.name, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(N'eon_doprava'), NULL, NULL, NULL, NULL) AS a
JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
INNER JOIN sys.tables tab ON b.object_id = tab.object_id 
order by 4 desc
```

### Tables with fragmented indexes

```sql
SELECT tab.name,MAX(avg_fragmentation_in_percent)
FROM sys.dm_db_index_physical_stats (DB_ID(N'eon_doprava'), NULL, NULL, NULL, NULL) AS a
JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id
INNER JOIN sys.tables tab ON b.object_id = tab.object_id 
GROUP by tab.name
order by 2 desc
```

### rebuild all indexes for given table

```sql
ALTER INDEX ALL ON <table>
REORGANIZE 
GO
```


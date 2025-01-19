# SQL snippets

*  [Fragmentace indexů](index-fragmentation.md) 
*  [sp_generate_inserts](https://github.com/lambacck/generate_inserts) - stored procedure for generating insert script, useful for simple data transfers, external link

### Lists  all tables containing the given column

```sql
declare @column varchar(100) = 'column_name'

select so.name as tablename, sc.name as columnname
  from sysobjects so
  join syscolumns sc on so.id=sc.id
  where sc.name = @column
```


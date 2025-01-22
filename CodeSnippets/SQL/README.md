# SQL snippets

* [Fragmentace indexů](index-fragmentation.md) 

* [sp_generate_inserts](https://github.com/lambacck/generate_inserts) - stored procedure for generating insert script, useful for simple data transfers, external link

* [sp_generate_class](sp_generate_class.sql) - stored procedure for generating C# class from a table

* [Table sizes](table-sizes.sql) - list all tables ordered from biggest to smallest one

* [All tables depent on the table](all-tables-depent-on-the-table.sql) - with key names

  

### Lists  all tables containing the given column

```sql
declare @column varchar(100) = 'column_name'

select so.name as tablename, sc.name as columnname
  from sysobjects so
  join syscolumns sc on so.id=sc.id
  where sc.name = @column
```



### Enable/disable identity inserts on a table

```sql
SET IDENTITY_INSERT <TABLE_NAME> ON

-- <... do some inserts ...>

SET IDENTITY_INSERT <TABLE_NAME> OFF
```

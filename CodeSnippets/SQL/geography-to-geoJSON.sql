IF  EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'dbo.Geo_to_json'))
    DROP FUNCTION dbo.Geo_to_json
go

CREATE FUNCTION dbo.Geo_to_json(@geo GEOGRAPHY)
returns NVARCHAR(max)
AS
  BEGIN
      RETURN
        (SELECT '{' + ( CASE @geo.STGeometryType()
                          WHEN 'POINT' THEN
'"type": "Point","coordinates":'
+
Replace(Replace(Replace(Replace(@geo.ToString(), 'POINT ', ''), '(', '['), ')', ']'), ' ', ',')
  WHEN 'POLYGON' THEN
  '"type": "Polygon","coordinates":' + '['
  +
Replace(Replace(Replace(Replace(Replace(Replace(@geo.ToString(), 'POLYGON ', ''), '(', '['), ')', ']'), '], ', ']],['), ', ', '],['), ' ', ',')
  + ']'
  WHEN 'MULTIPOLYGON' THEN
  '"type": "MultiPolygon","coordinates":'
  + '['
  +
Replace(Replace(Replace(Replace(Replace(Replace(
  @geo.ToString(), 'MULTIPOLYGON ', ''), '(', '['), ')', ']'), '], ', ']],['), ', ', '],['), ' ', ',')
  + ']'
  WHEN 'MULTILINESTRING' THEN
  '"type": "MultiLineString","coordinates":'
  + '['
  +
Replace(Replace(Replace(Replace(Replace(Replace(
  @geo.ToString(), 'MULTILINESTRING ', ''), '(', '['), ')', ']'), '], ', ']],['), ', ', '],['), ' ', ',')
  + ']'
  WHEN 'MULTIPOINT' THEN
  '"type": "MultiPoint","coordinates":'
  + Replace(
Replace(Replace(Replace(Replace(@geo.ToString(), 'MULTIPOINT ', ''), '(', '['), ')', ']'), ' ', ','), ',,', ', ')
  WHEN 'LINESTRING' THEN
  '"type": "LineString","coordinates":' + '['
  +
Replace(Replace(Replace(Replace(Replace(Replace(@geo.ToString(), 'LINESTRING ', ''), '(', '['), ')', ']'), '], ', ']],['), ', ', '],['), ' ', ',')
  + ']'
  ELSE NULL
END ) + '}')
END

go 

grant exec on dbo.Geo_to_json to public
go
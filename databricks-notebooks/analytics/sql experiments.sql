-- Databricks notebook source

-- COMMAND ----------

-- Query 1 3NF
SELECT DISTINCT part.titleId, 
  part.personId
FROM imdb_dev.silver.Participation as part
JOIN imdb_dev.silver.Category as cat on part.categoryId = cat.categoryId
WHERE cat.category = 'director'

-- COMMAND ----------

-- Query 1 Star
SELECT DISTINCT part.titleId, 
  part.personId 
FROM imdb_dev.gold.ParticipationFact as part
JOIN imdb_dev.gold.CategoryDim as cat on part.categoryId = cat.categoryId
WHERE cat.category = 'director'

-- COMMAND ----------

-- Query 1 OBT
SELECT DISTINCT obt.titleId, 
  obt.personId 
FROM imdb_dev.gold.OneBigTable as obt
WHERE obt.category = 'director'

-- COMMAND ----------

-- Query 2 3NF
SELECT DISTINCT tit.primaryTitle, 
  part.personId
FROM imdb_dev.silver.Participation as part
JOIN imdb_dev.silver.Title as tit on part.titleId = tit.titleId
WHERE tit.isAdult = TRUE 
  AND tit.startYear > 2000 
  AND tit.endYear < 2010 
  AND tit.runtimeMinutes > 10

-- COMMAND ----------

-- Query 2 Star
SELECT DISTINCT tit.primaryTitle, 
  part.personId
FROM imdb_dev.gold.ParticipationFact as part
JOIN imdb_dev.gold.TitleDim as tit on tit.titleId = part.titleId
WHERE tit.isAdult = TRUE 
  AND tit.startYear > 2000 
  AND tit.endYear < 2010 
  AND tit.runtimeMinutes > 10

-- COMMAND ----------

-- Query 2 OBT
SELECT DISTINCT obt.primaryTitle, 
  obt.personId
FROM imdb_dev.gold.OneBigTable as obt
WHERE obt.isAdult = TRUE 
  AND obt.startYear > 2000 
  AND obt.endYear < 2010 
  AND obt.runtimeMinutes > 10

-- COMMAND ----------

-- Query 3 3NF
SELECT DISTINCT part.personId, 
  part.titleId, 
  tit.primaryTitle, 
  tit.startYear
FROM imdb_dev.silver.Participation as part
JOIN imdb_dev.silver.Title as tit on part.titleId = tit.titleId
JOIN imdb_dev.silver.GenreOfTitle as got on part.titleId = got.titleId
JOIN imdb_dev.silver.Genre as gen on gen.genreId = got.genreId
WHERE (gen.genre = 'Comedy') 
  AND tit.startYear > 2012 
  AND tit.runtimeMinutes > 60

-- COMMAND ----------

-- Query 3 star
SELECT DISTINCT pf.personId, 
  pf.titleId, 
  td.primaryTitle, 
  td.startYear
FROM imdb_dev.gold.ParticipationFact AS pf
JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
JOIN imdb_dev.gold.GenreBridge AS gb ON pf.titleId = gb.titleId
JOIN imdb_dev.gold.GenreDim AS gd ON gb.genreId = gd.genreId
WHERE gd.genre = 'Comedy'
  AND td.startYear > 2012
  AND td.runtimeMinutes > 60


-- COMMAND ----------

-- Query 3 obt
SELECT DISTINCT obt.personId, 
  obt.titleId, 
  obt.primaryTitle, 
  obt.startYear
FROM imdb_dev.gold.OneBigTable as obt
WHERE obt.genre = 'Comedy'
  AND obt.startYear > 2012
  AND obt.runtimeMinutes > 60

-- COMMAND ----------

-- Query 4 3NF
SELECT uq_parts.personId, 
  AVG(uq_parts.averageRating) as average_rating
FROM 
(
  SELECT DISTINCT part.personId,
    part.titleId,
    rat.averageRating
  FROM imdb_dev.silver.Participation as part
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  WHERE rat.numVotes > 200
) as uq_parts
GROUP BY uq_parts.personId

-- COMMAND ----------

-- Query 4 star
SELECT uq_parts.personId, 
  AVG(uq_parts.averageRating) AS average_rating
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId,
    pf.averageRating
  FROM imdb_dev.gold.ParticipationFact AS pf
  WHERE pf.numVotes > 200
) as uq_parts
GROUP BY uq_parts.personId

-- COMMAND ----------

-- Query 4 obt
SELECT deduped_obt.personId, 
  AVG(deduped_obt.averageRating) AS average_rating
FROM (
  SELECT DISTINCT obt.personId, 
    obt.titleId, 
    obt.averageRating, 
    obt.numVotes
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.numVotes > 200
) AS deduped_obt
GROUP BY deduped_obt.personId

-- COMMAND ----------

-- Query 5 3NF
SELECT uq_parts.personId, 
  uq_parts.parentTitleId, 
  avg(uq_parts.averageRating) as average_rating, 
  min(uq_parts.averageRating) as minimum_rating, 
  max(uq_parts.averageRating) as maximum_rating
FROM (
  SELECT DISTINCT part.personId,
    part.titleId,
    ep.parentTitleId,
    rat.averageRating
  FROM imdb_dev.silver.Participation as part
  JOIN imdb_dev.silver.TitleEpisode as ep on part.titleId = ep.titleId 
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  WHERE rat.numVotes > 100
) as uq_parts
GROUP BY uq_parts.personId, uq_parts.parentTitleId

-- COMMAND ----------

-- Query 5 star
SELECT uq_parts.personId,
  uq_parts.parentTitleId,
  AVG(uq_parts.averageRating) AS average_rating,
  MIN(uq_parts.averageRating) AS minimum_rating,
  MAX(uq_parts.averageRating) AS maximum_rating
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId,
    pf.parentTitleId,
    pf.averageRating
  FROM imdb_dev.gold.ParticipationFact AS pf
  WHERE pf.numVotes > 100
    AND pf.parentTitleId IS NOT NULL
) as uq_parts
GROUP BY uq_parts.personId, uq_parts.parentTitleId

-- COMMAND ----------

-- Query 5 obt
SELECT deduped_obt.personId, 
  deduped_obt.parentTitleId,
  AVG(deduped_obt.averageRating) AS average_rating, 
  MIN(deduped_obt.averageRating) AS minimum_rating, 
  MAX(deduped_obt.averageRating) AS maximum_rating
FROM (
  SELECT DISTINCT obt.personId, 
    obt.titleId, 
    obt.parentTitleId, 
    obt.averageRating, 
    obt.numVotes
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.numVotes > 100
    AND obt.parentTitleId IS NOT NULL
) AS deduped_obt
GROUP BY deduped_obt.personId, deduped_obt.parentTitleId

-- COMMAND ----------

-- Query 6 3NF
SELECT uq_parts.personId, 
  AVG(uq_parts.averageRating) as average_rating,
  MIN(uq_parts.averageRating) AS minimum_rating, 
  MAX(uq_parts.averageRating) AS maximum_rating
FROM (
  SELECT DISTINCT part.personId,
    part.titleId,
    rat.averageRating
  FROM imdb_dev.silver.Participation as part
  JOIN imdb_dev.silver.Title as tit on part.titleId = tit.titleId
  JOIN imdb_dev.silver.TitleRating as rat on tit.titleId = rat.titleId
  JOIN imdb_dev.silver.GenreOfTitle as got on part.titleId = got.titleId
  JOIN imdb_dev.silver.Genre as gen on gen.genreId = got.genreId
  WHERE (gen.genre = "Romance") 
    AND tit.startYear > 2012 
    AND tit.runtimeMinutes BETWEEN 60 AND 150
) as uq_parts
GROUP BY uq_parts.personId
ORDER BY average_rating DESC


-- COMMAND ----------

-- Query 6 star
SELECT uq_parts.personId,
  AVG(uq_parts.averageRating) AS average_rating,
  MIN(uq_parts.averageRating) AS minimum_rating, 
  MAX(uq_parts.averageRating) AS maximum_rating
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId,
    pf.averageRating
  FROM imdb_dev.gold.ParticipationFact AS pf
  JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
  JOIN imdb_dev.gold.GenreBridge AS gb ON pf.titleId = gb.titleId
  JOIN imdb_dev.gold.GenreDim AS gd ON gb.genreId = gd.genreId
  WHERE gd.genre = 'Romance'
    AND td.startYear > 2012
    AND td.runtimeMinutes BETWEEN 60 AND 150
    AND pf.averageRating IS NOT NULL
) as uq_parts
GROUP BY uq_parts.personId
ORDER BY average_rating DESC

-- COMMAND ----------

-- Query 6 obt
SELECT deduped_obt.personId, 
  AVG(deduped_obt.averageRating) AS average_rating,
  MIN(deduped_obt.averageRating) AS minimum_rating, 
  MAX(deduped_obt.averageRating) AS maximum_rating
FROM (
  SELECT DISTINCT obt.personId, 
    obt.titleId, 
    obt.averageRating
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.genre = 'Romance'
    AND obt.startYear > 2012
    AND obt.runtimeMinutes BETWEEN 60 AND 150
    AND obt.averageRating IS NOT NULL
) AS deduped_obt
GROUP BY deduped_obt.personId
ORDER BY average_rating DESC


-- COMMAND ----------

-- Query 7 3NF
WITH relevant_titles AS (
  SELECT DISTINCT got.titleId
  FROM imdb_dev.silver.GenreOfTitle AS got
  JOIN imdb_dev.silver.Genre AS gen ON gen.genreId = got.genreId
  WHERE gen.genre IN ('Comedy', 'Romance')  
)

SELECT uq_parts.personId, 
  SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes) as weighted_average, 
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT part.personId,
    part.titleId,
    rat.averageRating,
    rat.numVotes
  FROM imdb_dev.silver.Participation as part
  JOIN relevant_titles as revtit on part.titleId = revtit.titleId
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  JOIN imdb_dev.silver.Title AS tit ON tit.titleId = part.titleId
  WHERE tit.startYear BETWEEN 2000 AND 2020
    AND tit.runtimeMinutes BETWEEN 45 AND 100
) as uq_parts
GROUP BY uq_parts.personId
ORDER BY weighted_average DESC, titles_count DESC

-- COMMAND ----------

-- Query 7 star schema
WITH relevant_titles AS (
  SELECT DISTINCT gb.titleId
  FROM imdb_dev.gold.GenreBridge AS gb
  JOIN imdb_dev.gold.GenreDim AS gd ON gb.genreId = gd.genreId
  WHERE gd.genre IN ('Comedy', 'Romance')
)

SELECT uq_parts.personId,
  SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes) AS weighted_average,
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT pf.titleId,
    pf.personId,
    pf.averageRating,
    pf.numVotes
  FROM imdb_dev.gold.ParticipationFact AS pf
  JOIN relevant_titles AS rt ON pf.titleId = rt.titleId
  JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
  WHERE td.startYear BETWEEN 2000 AND 2020
    AND td.runtimeMinutes BETWEEN 45 AND 100
    AND pf.averageRating is not NULL
) as uq_parts
GROUP BY uq_parts.personId
ORDER BY weighted_average DESC, titles_count DESC


-- COMMAND ----------

-- Query 7 obt
SELECT 
  deduped_obt.personId, 
  SUM(deduped_obt.averageRating * deduped_obt.numVotes) / SUM(deduped_obt.numVotes) AS weighted_average,
  COUNT(deduped_obt.titleId) AS titles_count
FROM (
  SELECT DISTINCT obt.personId, 
    obt.titleId, 
    obt.averageRating, 
    obt.numVotes
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.genre IN ('Comedy', 'Romance')
    AND obt.startYear BETWEEN 2000 AND 2020
    AND obt.runtimeMinutes BETWEEN 45 AND 100
    AND obt.averageRating is not NULL
) AS deduped_obt
GROUP BY deduped_obt.personId
ORDER BY weighted_average DESC, titles_count DESC

-- COMMAND ----------

-- Query 8 3NF
WITH relevant_titles AS (
  SELECT DISTINCT got.titleId
  FROM imdb_dev.silver.GenreOfTitle AS got
  JOIN imdb_dev.silver.Genre AS gen ON gen.genreId = got.genreId
  WHERE gen.genre IN ('Sci-Fi', 'Fantasy', 'Adventure', 'Action')  
)

SELECT uq_parts.personId, 
  SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes) as weighted_average, 
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT part.personId,
    part.titleId,
    rat.averageRating,
    rat.numVotes
  FROM imdb_dev.silver.Participation as part
  JOIN relevant_titles as revtit on part.titleId = revtit.titleId
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  JOIN imdb_dev.silver.Title AS tit ON tit.titleId = part.titleId
  JOIN imdb_dev.silver.TitleType AS typ ON tit.titleTypeId = typ.titleTypeId
  WHERE (typ.titleType = 'movie' or typ.titleType = 'tvSeries')
    AND tit.startYear > 1980
    AND tit.endYear < 2000
    AND tit.runtimeMinutes > 300
) as uq_parts
GROUP BY uq_parts.personId
HAVING (SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes)) > 5.0
ORDER BY weighted_average DESC, titles_count DESC

-- COMMAND ----------

-- Query 8 star
WITH relevant_titles AS (
  SELECT DISTINCT gb.titleId
  FROM imdb_dev.gold.GenreBridge AS gb
  JOIN imdb_dev.gold.GenreDim AS gd ON gb.genreId = gd.genreId
  WHERE gd.genre IN ('Sci-Fi', 'Fantasy', 'Adventure', 'Action')
)

SELECT uq_parts.personId,
  SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes) AS weighted_average,
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId,
    pf.averageRating,
    pf.numVotes
    FROM imdb_dev.gold.ParticipationFact AS pf
  JOIN relevant_titles AS rt ON pf.titleId = rt.titleId
  JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
  WHERE td.titleType IN ('movie', 'tvSeries')
    AND td.startYear > 1980
    AND td.endYear < 2000
    AND td.runtimeMinutes > 300
    AND pf.averageRating is not NULL
) as uq_parts
GROUP BY uq_parts.personId
HAVING (SUM(uq_parts.averageRating * uq_parts.numVotes) / SUM(uq_parts.numVotes)) > 5.0
ORDER BY weighted_average DESC, titles_count DESC

-- COMMAND ----------

-- Query 8 obt
SELECT 
  deduped_obt.personId, 
  SUM(deduped_obt.averageRating * deduped_obt.numVotes) / SUM(deduped_obt.numVotes) AS weighted_average,
  COUNT(deduped_obt.titleId) AS titles_count
FROM (
  SELECT DISTINCT obt.personId, obt.titleId, obt.averageRating, obt.numVotes
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.genre IN ('Sci-Fi', 'Fantasy', 'Adventure', 'Action')
    AND obt.titleType IN ('movie', 'tvSeries')
    AND obt.startYear > 1980
    AND obt.endYear < 2000
    AND obt.runtimeMinutes > 300
    AND obt.averageRating is not NULL
) AS deduped_obt
GROUP BY deduped_obt.personId
HAVING SUM(deduped_obt.averageRating * deduped_obt.numVotes) / SUM(deduped_obt.numVotes) > 5.0
ORDER BY weighted_average DESC, titles_count DESC


-- COMMAND ----------

-- Query 9 3NF
WITH relevant_participations AS (
  SELECT DISTINCT prim.personId, kn.titleId
  FROM imdb_dev.silver.PersonPrimaryProfession AS prim
  JOIN imdb_dev.silver.Profession AS per ON prim.professionId = per.professionId
  JOIN imdb_dev.silver.KnownForParticipation AS kn ON prim.personId = kn.personId
  JOIN imdb_dev.silver.Participation AS part ON part.personId = kn.personId and kn.titleId = part.titleId
  WHERE per.profession IN ('director', 'writer', 'producer')  
)

SELECT uq_parts.personId, 
  AVG(uq_parts.averageRating) as average_rating, 
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT part.personId,
    part.titleId,
    rat.averageRating
  FROM imdb_dev.silver.Participation as part
  JOIN relevant_participations as revpart on part.titleId = revpart.titleId and part.personId = revpart.personId
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  JOIN imdb_dev.silver.Title AS tit ON tit.titleId = part.titleId
  JOIN imdb_dev.silver.TitleType AS typ ON tit.titleTypeId = typ.titleTypeId
  WHERE typ.titleType = 'short'
    AND tit.startYear > 1900
    AND tit.endYear < 2000
    AND tit.runtimeMinutes > 3
) as uq_parts
GROUP BY uq_parts.personId
HAVING COUNT(uq_parts.titleId) > 1
  AND AVG(uq_parts.averageRating) > 6.0
ORDER BY average_rating DESC, titles_count DESC

-- COMMAND ----------

-- Query 9 star
WITH relevant_participations AS (
  SELECT DISTINCT ppb.personId, pf.titleId
  FROM imdb_dev.gold.PrimaryProfessionBridge AS ppb
  JOIN imdb_dev.gold.PrimaryProfessionDim AS ppd ON ppb.professionId = ppd.professionId
  JOIN imdb_dev.gold.ParticipationFact AS pf ON pf.personId = ppb.personId
  WHERE ppd.profession IN ('director', 'writer', 'producer')  
  AND pf.isKnownForParticipation = true
)

SELECT uq_parts.personId,
  AVG(uq_parts.averageRating) AS average_rating,
  COUNT(uq_parts.titleId) AS titles_count
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId,
    pf.averageRating
  FROM imdb_dev.gold.ParticipationFact AS pf
  JOIN relevant_participations AS rp ON pf.personId = rp.personId AND pf.titleId = rp.titleId
  JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
  WHERE td.titleType = 'short'
    AND td.startYear > 1900
    AND td.endYear < 2000
    AND td.runtimeMinutes > 3
    AND pf.averageRating is not NULL
) as uq_parts
GROUP BY uq_parts.personId
HAVING COUNT(uq_parts.titleId) > 1
  AND AVG(uq_parts.averageRating) > 6.0
ORDER BY average_rating DESC, titles_count DESC


-- COMMAND ----------

-- Query 9 obt
SELECT 
  deduped_obt.personId, 
  AVG(deduped_obt.averageRating) AS average_rating, 
  COUNT(deduped_obt.titleId) AS titles_count
FROM (
  SELECT DISTINCT obt.personId, obt.titleId, obt.averageRating
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.profession IN ('director', 'writer', 'producer')
    AND obt.isKnownForParticipation = TRUE
    AND obt.titleType = 'short'
    AND obt.startYear > 1900
    AND obt.endYear < 2000
    AND obt.runtimeMinutes > 3
    AND obt.averageRating is not NULL
) AS deduped_obt
GROUP BY deduped_obt.personId
HAVING COUNT(deduped_obt.titleId) > 1
   AND AVG(deduped_obt.averageRating) > 6.0
ORDER BY average_rating DESC, titles_count DESC


-- COMMAND ----------

-- Query 10 3NF
WITH relevant_participations AS (
  SELECT DISTINCT prim.personId, kn.titleId
  FROM imdb_dev.silver.PersonPrimaryProfession AS prim
  JOIN imdb_dev.silver.KnownForParticipation AS kn ON prim.personId = kn.personId
  JOIN imdb_dev.silver.Profession AS per ON prim.professionId = per.professionId
  JOIN imdb_dev.silver.Participation AS part ON part.personId = kn.personId and kn.titleId = part.titleId
  WHERE per.profession IN ('actor', 'producer')  
),
relevant_titles AS (
  SELECT DISTINCT akas.titleId
  FROM imdb_dev.silver.TitleAKAS AS akas
  JOIN imdb_dev.silver.Region AS reg ON akas.regionId = reg.regionId
  WHERE reg.region IN ('US', 'GB')
)

SELECT uq_parts.titleId, 
  COUNT(uq_parts.personId) AS num_actors_producers
FROM (
  SELECT DISTINCT part.personId,
    part.titleId
  FROM imdb_dev.silver.Participation as part
  JOIN relevant_participations as revpart on part.titleId = revpart.titleId and part.personId = revpart.personId
  JOIN relevant_titles as revtit on part.titleId = revtit.titleId
  JOIN imdb_dev.silver.TitleRating as rat on part.titleId = rat.titleId
  JOIN imdb_dev.silver.Title AS tit ON tit.titleId = part.titleId
  JOIN imdb_dev.silver.TitleType AS typ ON tit.titleTypeId = typ.titleTypeId
  JOIN imdb_dev.silver.Category as cat on part.categoryId = cat.categoryId
  WHERE (typ.titleType = 'short' or typ.titleType = 'tvSeries')
    AND (cat.category = 'actor' or cat.category = 'producer')
    AND rat.averageRating > 3.0
    AND rat.numVotes > 100
) as uq_parts
GROUP BY uq_parts.titleId
HAVING COUNT(uq_parts.personId) BETWEEN 3 and 10
ORDER BY num_actors_producers DESC

-- COMMAND ----------

-- Query 10 star
WITH relevant_participations AS (
  SELECT DISTINCT ppb.personId, pf.titleId
  FROM imdb_dev.gold.PrimaryProfessionBridge AS ppb
  JOIN imdb_dev.gold.PrimaryProfessionDim AS ppd ON ppb.professionId = ppd.professionId
  JOIN imdb_dev.gold.ParticipationFact AS pf ON ppb.personId = pf.personId
  WHERE ppd.profession IN ('actor', 'producer')
    AND pf.isKnownForParticipation = TRUE
),
relevant_titles AS (
  SELECT DISTINCT ab.titleId
  FROM imdb_dev.gold.AKASBridge AS ab
  JOIN imdb_dev.gold.AKASDim AS ad ON ab.AKASId = ad.AKASId
  WHERE ad.region IN ('US', 'GB')
)

SELECT uq_parts.titleId,
  COUNT(uq_parts.personId) AS num_actors_producers
FROM (
  SELECT DISTINCT pf.personId,
    pf.titleId
  FROM imdb_dev.gold.ParticipationFact AS pf
  JOIN relevant_participations AS rp ON pf.titleId = rp.titleId AND pf.personId = rp.personId
  JOIN relevant_titles AS rt ON pf.titleId = rt.titleId
  JOIN imdb_dev.gold.TitleDim AS td ON pf.titleId = td.titleId
  JOIN imdb_dev.gold.CategoryDim AS cd ON pf.categoryId = cd.categoryId
  WHERE td.titleType IN ('short', 'tvSeries')
    AND cd.category IN ('actor', 'producer')
    AND pf.averageRating > 3.0
    AND pf.numVotes > 100
) as uq_parts
GROUP BY uq_parts.titleId
HAVING COUNT(uq_parts.personId) BETWEEN 3 AND 10
ORDER BY num_actors_producers DESC


-- COMMAND ----------

-- Query 10 obt
SELECT 
  deduped_obt.titleId, 
  COUNT(deduped_obt.personId) AS num_actors_producers
FROM (
  SELECT DISTINCT titleId, personId
  FROM imdb_dev.gold.OneBigTable as obt
  WHERE obt.profession IN ('actor', 'producer')
    AND obt.isKnownForParticipation = TRUE
    AND obt.region IN ('US', 'GB')
    AND obt.titleType IN ('short', 'tvSeries')
    AND obt.category IN ('actor', 'producer')
    AND obt.averageRating > 3.0
    AND obt.numVotes > 100
) AS deduped_obt
GROUP BY deduped_obt.titleId
HAVING COUNT(deduped_obt.personId) BETWEEN 3 AND 10
ORDER BY num_actors_producers DESC

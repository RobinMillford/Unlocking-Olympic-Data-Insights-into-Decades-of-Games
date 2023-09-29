create database portfolioprojects;

use portfolioprojects;

select * from olympics;
select * from nocregions;

-- 1. Number of olympics games
SELECT COUNT(DISTINCT Year) as NumberOfOlympicGames
FROM olympics;

-- 2.  all Olympic games held so far
select distinct year
from olympics
order by Year;

-- 3. Total number of nations who participated in each olympics
select Year as olympicgame, count(distinct Team) as TotalNationParticipated
from olympics
group by Year
order by Year;

-- 4. Nation That participated in all of the olympic games
SELECT subq1.NOC as Nation , subq2.TotalGamesParticipated
FROM
  (SELECT NOC, COUNT(DISTINCT Year) as TotalGames
   FROM olympics
   GROUP BY NOC) as subq1
JOIN
  (SELECT COUNT(DISTINCT Year) as TotalGamesParticipated
   FROM olympics) as subq2
ON subq1.TotalGames = subq2.TotalGamesParticipated
WHERE subq1.TotalGames = (SELECT COUNT(DISTINCT Year) FROM olympics)
ORDER BY subq1.NOC;


-- 5. Unique athletes who have won a gold medal
select count(distinct Name) as GoldMedalWinners
from olympics
where Medal = 'Gold';


-- 6. Sports that played only ones in the olymics
SELECT subq1.Sport, subq2.NumGames
FROM (
    SELECT DISTINCT Sport, Year FROM olympics
) AS subq1
JOIN (
    SELECT Sport, COUNT(DISTINCT Year) AS NumGames
    FROM olympics
    GROUP BY Sport
) AS subq2 ON subq1.Sport = subq2.Sport
WHERE subq2.NumGames = 1;


-- 7. the total number of sports played in each olymics games
select subq1.Year as olympicGame, count(subq1.Sport) as TotalSports
from (select distinct Year, Sport from olympics) as subq1
group by subq1.Year
order by TotalSports Desc;


--8. oldest athlete to win a gold medal
SELECT TOP 1 Name, Age
FROM olympics
WHERE Medal = 'Gold'
ORDER BY Age DESC;

--9. Top  athletes who have won the most gold medels
SELECT Name, TotalGoldMedals
FROM (
    SELECT Name, COUNT(*) as TotalGoldMedals,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as AthleteRank
    FROM olympics
    WHERE Medal = 'Gold'
    GROUP BY Name
) as RankAthletes
WHERE AthleteRank <= 5
ORDER BY TotalGoldMedals DESC;


-- 10. Top athletes who have won the most medals(gold/silver/bronze)
SELECT Name TotalMedals
FROM (
    SELECT Name, COUNT(*) as TotalMedals,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as AthleteRank
    FROM olympics
    WHERE Medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY Name
) as RankedAthletes
WHERE AthleteRank <= 5
ORDER BY TotalMedals DESC;


-- 11. Most successful countries in olympics
SELECT Team, TotalMedals
FROM (
    SELECT Team, COUNT(*) as TotalMedals,
           DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) as CountryRank
    FROM olympics
    WHERE Medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY Team
) as RankedCountries
WHERE CountryRank <= 5
ORDER BY TotalMedals DESC;


--12. sport/event in which india has won the highest number of medals
SELECT Sport, Event, TotalMedals
FROM (
    SELECT Sport, Event, COUNT(*) as TotalMedals,
           RANK() OVER (ORDER BY COUNT(*) DESC) as SportRank
    FROM olympics
    WHERE Team = 'India' AND Medal IN ('Gold', 'Silver', 'Bronze')
    GROUP BY Sport, Event
) as RankedSports
WHERE SportRank = 1;


--13. all olympic games where india won medal for Hockey
SELECT Year as OlympicGame, COUNT(*) as TotalMedals
FROM olympics
WHERE Team = 'India' AND Sport = 'Hockey' AND Medal IN ('Gold', 'Silver', 'Bronze')
GROUP BY Year
ORDER BY TotalMedals DESC;
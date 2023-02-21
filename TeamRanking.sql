select *from dbo.[Dataset Football txt]

select home_team, sum(home_score)  from dbo.[Dataset Football txt]
group by home_team

/* Adding columns to an existing table and Setting Values for for it */
ALTER TABLE dbo.[Dataset Football txt]
ADD PointsHomeTeam int;


update dbo.[Dataset Football txt]
SET PointsHomeTeam = CASE
			WHEN (home_score >away_score AND Confederations = 'FRIENDLY')
							THEN  2
			WHEN (home_score < away_score AND Confederations = 'FRIENDLY')
							THEN  0
			WHEN (home_score = away_score AND Confederations = 'FRIENDLY')
							THEN  1
			
			WHEN (home_score >away_score AND Confederations = 'FIFA')
							THEN  2*2
			WHEN (home_score < away_score AND Confederations = 'FIFA')
							THEN  2*0
			WHEN (home_score = away_score AND Confederations = 'FIFA')
							THEN  2*1
			WHEN (home_score >away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  3*2
			WHEN (home_score < away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  3*0
			WHEN (home_score = away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  3*1
			END
select *from dbo.[Dataset Football txt]


/* Adding columns to an existing table and Setting Values for for it */
ALTER TABLE dbo.[Dataset Football txt]
ADD PointsAwayTeam int;


update dbo.[Dataset Football txt]
SET PointsAwayTeam = CASE
			WHEN (home_score >away_score AND Confederations = 'FRIENDLY')
							THEN  0
			WHEN (home_score < away_score AND Confederations = 'FRIENDLY')
							THEN  4
			WHEN (home_score = away_score AND Confederations = 'FRIENDLY')
							THEN  1			
			WHEN (home_score >away_score AND Confederations = 'FIFA')
							THEN  0
			WHEN (home_score < away_score AND Confederations = 'FIFA')
							THEN  4*2
			WHEN (home_score = away_score AND Confederations = 'FIFA')
							THEN  2*1
			WHEN (home_score >away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  0
			WHEN (home_score < away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  3*4
			WHEN (home_score = away_score AND Confederations != 'FIFA' and Confederations !='FRIENDLY')
								THEN  3*1
			END
select *from dbo.[Dataset Football txt]


/* Create New table where total score by each team till now is stored */
select tb.home_team, sum(tb.PointsHomeTeam) as 'TotalPoints' into TotalPointsHomeTable from dbo.[Dataset Football txt] as tb
group by home_team 

select *from TotalPointsHomeTable


select away_team, sum(PointsAwayTeam) as 'TotalPointsaway' into TotalPointsAwayTable from dbo.[Dataset Football txt]
group by away_team 

select *from TotalPointsAwayTable

/* Apply Joins on table to join it */

SELECT TotalPointsAwayTable.away_team, TotalPointsAwayTable.TotalPointsaway, TotalPointsHomeTable.TotalPoints into MergeRankingTAble from TotalPointsAwayTable 
left JOIN TotalPointsHomeTable  ON TotalPointsAwayTable.away_team = TotalPointsHomeTable.home_team;

alter table MergeRankingTAble
add TotalScore int;

select *from MergeRankingTAble

update MergeRankingTAble
set TotalScore = TotalPoints + TotalPointsaway

select *from MergeRankingTAble

/* Ranking of the team */
SELECT away_team, TotalScore, 
	   RANK() OVER(ORDER BY TotalScore DESC) Rank
       FROM MergeRankingTAble
	   order by away_team, Rank;

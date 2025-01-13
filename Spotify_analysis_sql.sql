create database Spotify_data_analysis

use Spotify_data_analysis

select * from spotify_data

alter table spotify_data
alter column Licensed bit

alter table spotify_data
alter column official_video bit

--Data exploration  
select count(*) from spotify_data

select count(distinct artist) from spotify_data

select count(distinct album) from spotify_data

select distinct album_type from spotify_data 

select max(duration_min) from spotify_data

select min(duration_min) from spotify_data

select 
		most_playedon,
		count(*) from spotify_data
group by 
		most_playedon

--Data Analysis

--Q1.Retrieve the names of all tracks that have more than 1 billion streams.

select 
	Track
from 
	spotify_data
where
	stream >1000000000


--Q2.List all albums along with their respective artists.

select distinct 
	Album,
	Artist
from
	spotify_data


--Q3.Get the total number of comments for tracks where licensed = TRUE.

select 
	sum(Comments) as Total_comments
from 
	spotify_data
where 
	Licensed = 1

--Q4.Find all tracks that belong to the album type single.

select 
	Track
from
	spotify_data
where 
	album_type = 'single'

--Q5.Count the total number of tracks by each artist.

select 
	Artist,
	count(Track) as Total_Track
from 
	spotify_data
group by 
	Artist
order by
	count(Track) desc

--Q6.Calculate the average danceability of tracks in each album.

select
	Album,
	round(AVG(Danceability),3) as Avg_danceability
from 
	spotify_data
group by 
	Album
order by 
	AVG(Danceability) desc

--Q7.Find the top 5 tracks with the highest energy values.

select top 5
	Track,
	round(Energy,2) as Energy
from 
	spotify_data
order by 
	Energy desc

--Q8.List all tracks along with their views and likes where official_video = TRUE.

select 
	Track,
	Views,
	Likes
from 
	spotify_data
where
	official_video = 1

--Q9.For each album, calculate the total views of all associated tracks.

select
	Album,
	Track,
	sum(Views) as Total_views
from 
	spotify_data
group by 
	Album,
	Track
order by
	sum(Views) desc

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.

select
	Track,
	sum(Stream) as Total_Spotify_stream
from 
	spotify_data as s
where 
	most_playedon = 'Spotify'
group by 
	Track
having sum(Stream) > 
(
select
	
	sum(Stream) as Total_yt_stream
from	
	spotify_data as y
where 
	most_playedon = 'Youtube'
	and
	s.Track = y.Track
group by 
	Track
)

--Q11.Find the top 3 most-viewed tracks for each artist using window functions.

select 
	Artist,
	Track,
	Views,
	ranks
from
	(select Artist,Track,Views,
	dense_rank() over(partition by artist order by Views desc) as ranks
	from spotify_data) as ABC
where 
	ranks in(1,2,3)

--Q12.Write a query to find tracks where the liveness score is above the average.


select 
	Track,
	round(Liveness,2) as Liveness
from 
	spotify_data
where Liveness >
	(select
		Avg(Liveness) as Avg_Liveness
from 
	spotify_data)

/*Q13.Use a WITH clause to calculate the difference between 
the highest and lowest energy values for tracks in each album.*/

with EnergyValue as
(
select 
	Album,
	round(max(energy),2) as highest_energy,
	round(min(energy),2) as lowest_energy
from 
	spotify_data
group by 
	Album
)
select 
	*,
	 highest_energy-lowest_energy as Energy_diff
from 
	EnergyValue

--Q14.Find tracks where the energy-to-liveness ratio is greater than 1.2.

select 
	Track,
	Energy/Liveness as Ratio 
from 
	spotify_data
where
	Energy/Liveness > 1.2

/*Q15.Calculate the cumulative sum of likes for tracks ordered by the number of views, 
using window functions*/

select
	sum(Likes) over(partition by Track order by Views) as Cumulative_Sum_Like
from	
	spotify_data

--Query Optimisation 

select 
	Artist,
	track,
	Views
from 
	spotify_data
where
	Artist = 'Gorillaz'
	and
	most_playedon = 'Youtube'
order by 
	stream

create clustered index CL_Artist
on spotify_data(Artist)


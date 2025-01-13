# Spotify_analysis_sql
# Spotify Advanced SQL Project and Query Optimization 
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/Arman0106/Spotify_analysis_sql/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.
1. Data Exploration.
2. Data Analysis.
3. Querying data.
4. Query optimization.

**Create Database**
```sql
create database Spotify_data_analysis
```

**use Spotify_data**

```sql
select * from spotify_data
```
```sql
alter table spotify_data
alter column Licensed bit
```
```sql
alter table spotify_data
alter column official_video bit
```
--**Data exploration **
```sql
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
```
--**Data Analysis**

--**Q1.Retrieve the names of all tracks that have more than 1 billion streams.**

```sql
select 
	Track
from 
	spotify_data
where
	stream >1000000000
```

--**Q2.List all albums along with their respective artists.**
```sql
select distinct 
	Album,
	Artist
from
	spotify_data
```

--**Q3.Get the total number of comments for tracks where licensed = TRUE.**
```sql
select 
	sum(Comments) as Total_comments
from 
	spotify_data
where 
	Licensed = 1
```

--**Q4.Find all tracks that belong to the album type single.**
```sql
select 
	Track
from
	spotify_data
where 
	album_type = 'single'
```

--**Q5.Count the total number of tracks by each artist.**
```sql
select 
	Artist,
	count(Track) as Total_Track
from 
	spotify_data
group by 
	Artist
order by
	count(Track) desc
```

--**Q6.Calculate the average danceability of tracks in each album.**
```sql
select
	Album,
	round(AVG(Danceability),3) as Avg_danceability
from 
	spotify_data
group by 
	Album
order by 
	AVG(Danceability) desc
```

--**Q7.Find the top 5 tracks with the highest energy values.**
```sql
select top 5
	Track,
	round(Energy,2) as Energy
from 
	spotify_data
order by 
	Energy desc
```
--**Q8.List all tracks along with their views and likes where official_video = TRUE.**
```sql
select 
	Track,
	Views,
	Likes
from 
	spotify_data
where
	official_video = 1
```

--**Q9.For each album, calculate the total views of all associated tracks.**
```sql
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
```

--**Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.**
```sql
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
```
--**Q11.Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```

--**Q12.Write a query to find tracks where the liveness score is above the average.**
```sql
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
```

**Q13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
```

--**Q14.Find tracks where the energy-to-liveness ratio is greater than 1.2.**
```sql
select 
	Track,
	Energy/Liveness as Ratio 
from 
	spotify_data
where
	Energy/Liveness > 1.2
```
**Q15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions**
```sql
select
	sum(Likes) over(partition by Track order by Views) as Cumulative_Sum_Like
from	
	spotify_data
```
--## **Query Optimisation**
To improve query performance, we carried out the following optimization process:
- **Initial Query Performance Analysis:**
    - We began analyze the performance of the query by running without creating index on the table column.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Estimated operator cost : 0.787(98%)
        - Estimated I/O cost      : 0.764
        - Estimated CPU cost      : 0.0227
    - Below is the **screenshot** of the result before optimization:
      ![EXPLAIN Before Index](https://github.com/Arman0106/Spotify_analysis_sql/blob/main/spotify_1.png)
      
```sql
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
```
- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
```sql
create clustered index CL_Artist
on spotify_data(Artist)
```
- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Estimated operator cost : 0.003293(22%)
        - Estimated I/O cost      : 0.003125
        - Estimated CPU cost      : 0.000168
    - Below is the **screenshot** of the result after index creation:
      ![EXPLAIN After Index](https://github.com/Arman0106/Spotify_analysis_sql/blob/main/spotify_2.png)

**This optimization shows how indexing can drastically reduce query time, improving the overall performance of our database operations in the Spotify project.**


**If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.**
Author - Mohd Arman Mansuri
github - https://github.com/Arman0106
linkedIn - www.linkedin.com/in/arman-mansuri-0a731a173

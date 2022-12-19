-- Q1. Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from (Reviewer join Rating using (rID)) join Movie using(mID)
where title = "Gone with the Wind";

-- Q2. For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select name, title, stars
from (Reviewer join Rating using (rID)) join Movie using(mID)
where name = director

-- Q3. Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
select name
from Reviewer
union 
select title
from Movie

-- Q4. Find the titles of all movies not reviewed by Chris Jackson.
select title
from Movie
where mID not in
	(select mID from Reviewer join Rating using (rID)
	 where name = 'Chris Jackson')

-- Q5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 
select distinct W1.name, W2.name
from (Rating R1 join Reviewer W1 using(rID)) RW1 join 
	 (Rating R2 join Reviewer W2 using(rID)) RW2 using(mID)
where RW1.name < RW2.name
order by W1.name, W2.name

-- Q6. For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from (Reviewer join Rating using (rID)) join Movie using(mID)
where stars in (select min(stars) from Rating)

-- Q7. List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as avgStars
from Movie join Rating using (mID)
group by title
order by avgStars desc, title

-- Q8. Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
select distinct name
from Reviewer join Rating R1 using (rID)
where 3 <= (select count(*) from Rating R2 where R2.rID = R1.rID)

-- Q9. Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
select title, director
from Movie
where director in (select director from Movie group by director having count(*) > 1)
order by director, title

select M1.title, M1.director
from Movie M1 join Movie M2 using(director)
group by M1.mID
having count(*) > 1
order by M1.director, M1.title

select M1.title, M1.director
from Movie M1 join Movie M2 using(director)
where M1.mID <> M2.mID
order by M1.director, M1.title

select title, director
from Movie
where 1 < (select count(*) from Movie M2 where M2.director = M1.director)
order by director, title

-- Q10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
select title, avgStars
from (select mID, avg(stars) as avgStars from Rating group by mID)
	  join Movie using(mID)
where avgStars = (select max(avgStars)
 			      from (select mID, avg(stars) as avgStars
				   		from Rating
				        group by mID))

-- Q11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
select title, avgStars
from (select mID, avg(stars) as avgStars from Rating group by mID) Gman
	  join Movie using(mID)
where avgStars = (select min(avgStars)
 			 from (select mID, avg(stars) as avgStars
				   from Rating
				   group by mID))

-- Q12. For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
select director, title, max(stars)
from Movie join Rating using (mID)
where director is not null
group by director

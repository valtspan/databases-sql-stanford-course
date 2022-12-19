-- Q1. Find the titles of all movies directed by Steven Spielberg.
select title
from Movie
where director = "Steven Spielberg";

-- Q2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select distinct year
from Movie, Rating
where Movie.mId == Rating.mId and stars >= 4
order by year;

-- Q3. Find the titles of all movies that have no ratings.
select title
from Movie
where mID not in (select mID from Rating);

-- Q4. Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
select name
from Reviewer join Rating using(rID)
where ratingDate is NULL;

-- Q5. Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name, title, stars, ratingDate
from (Reviewer join Rating using(rID)) join Movie using(mID)
order by name, title, stars;

-- Q6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
select name, title
from ((Rating R1 join Rating R2 using(rID, mID))
        join Movie using(mID))
        join Reviewer using(rID)
where R1.ratingDate < R2.ratingDate and R1.stars < R2.stars

-- Q7. For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from Rating join Movie using(mID)
group by title
order by title;

select distinct title, stars
from Rating R1, Movie
where R1.mID = Movie.mID and 
    not exists (select * from Rating R2
                where R2.mID = R1.mID
                and R1.stars < R2.stars)
order by title;

-- Q8. For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
select title, (mx - mn) as ratingSpread
from (select mID, max(stars) as mx, min(stars) as mn
        from Rating
        group by mID) M, Movie
where Movie.mID = M.mID
order by ratingSpread desc, title;

-- Q9. Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
select avg(before80.avgStars) - avg(after80.avgStars)
from
    (select avg(stars) as avgStars
    from Movie join Rating using (mID)
    group by mID
    having year < 1980) before80,
    (select avg(stars) as avgStars
    from Movie join Rating using (mID)
    group by mID
    having year >= 1980) after80

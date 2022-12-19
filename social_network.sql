-- Q1. Find the names of all students who are friends with someone named Gabriel.
select name
from Highschooler
where ID in (select ID2
             from Highschooler join Friend
             on Highschooler.ID = Friend.ID1
             where name = 'Gabriel')

select H2.name
from (Friend F1 join Highschooler H1 on F1.ID1 = H1.ID) F2
      join Highschooler H2 on F2.ID2 = H2.ID
where H1.name = 'Gabriel'

-- Q2. For every student who likes someone 2 or more grades younger than
-- themselves, return that student's name and grade, and the name and grade of
-- the student they like.
select H1.name, H1.grade, H2.name, H2.grade
from (Likes L1 join Highschooler H1 on L1.ID1 = H1.ID) L2 
      join Highschooler H2 on L2.ID2 = H2.ID
where H1.grade - H2.grade >= 2

-- Q3. For every pair of students who both like each other, return the name and
-- grade of both students. Include each pair only once, with the two names in
-- alphabetical order.
select H1.name, H1.grade, H2.name, H2.grade
from (Likes L1 join Highschooler H1 on L1.ID1 = H1.ID) Lk
      join Highschooler H2 on Lk.ID2 = H2.ID
where exists (select * from Likes L2 where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1)
    and H1.name < H2.name
    
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2
where L1.ID1 = L2.ID2 and 
      L1.ID2 = L2.ID1 and 
      L1.ID1 = H1.ID and 
      L1.ID2 = H2.ID and
      H1.name < H2.name

-- Q4. Find all students who do not appear in the Likes table (as a student who
-- likes or is liked) and return their names and grades. Sort by grade,
-- then by name within each grade.
select name, grade
from Highschooler 
where ID not in (select ID1 from Likes) and ID not in (select ID2 from Likes)
order by grade, name

select name, grade
from Highschooler
where ID not in (select ID1 from Likes union select ID2 from Likes)
order by grade, name

-- Q5. For every situation where student A likes student B, but we have no
-- information about whom B likes (that is, B does not appear as an ID1 in the
-- Likes table), return A and B's names and grades.
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1, Highschooler H1, Highschooler H2
where L1.ID1 = H1.ID and L1.ID2 = H2.ID and ID2 not in (select ID1 from Likes L2)

-- Q6. Find names and grades of students who only have friends in the same
-- grade. Return the result sorted by grade, then by name within each grade.
select H1.name, H1.grade
from Friend F1, Highschooler H1, Highschooler H2
where F1.ID1 = H1.ID and F1.ID2 = H2.ID and H1.grade = H2.grade 
except
select H1.name, H1.grade
from Friend F1, Highschooler H1, Highschooler H2
where F1.ID1 = H1.ID and F1.ID2 = H2.ID and H1.grade <> H2.grade  
order by H1.grade, H1.name

select name, grade
from Highschooler H1
where ID not in (select ID1 from Friend F1, Highschooler H2
                 where F1.ID1 = H1.ID and
                       F1.ID2 = H2.ID and
                       H1.grade <> H2.grade)
order by H1.grade, H1.name

-- Q7. For each student A who likes a student B where the two are not friends,
-- find if they have a friend C in common (who can introduce them!). For all
-- such trios, return the name and grade of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Friend F1, Friend F2, Highschooler H1, Highschooler H2, Highschooler H3
where not exists (select * from Likes L2 where L2.ID1 = L1.ID2 and L2.ID2 = L1.ID1)
and not exists (select * from Friend F3 where F3.ID1 = L1.ID1 and F3.ID2 = L1.ID2)
and L1.ID1 = F1.ID1 and L1.ID2 = F2.ID2 and F1.ID2 = F2.ID1
and L1.ID1 = H1.ID and L1.ID2 = H2.ID and F1.ID2 = H3.ID

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Likes L1, Highschooler H1, Highschooler H2, Highschooler H3, Friend F1, Friend F2
where L1.ID1 = H1.ID and L1.ID2 = H2.ID and L1.ID1 not in
(select ID1 from Friend where ID2 = L1.ID2) and L1.ID1 not in
(select ID2 from Likes L2 where ID1 = L1.ID2 and ID1 = L1.ID2)
and F1.ID2 = F2.ID1 and L1.ID1 = F1.ID1
and L1.ID2 = F2.ID2 and F1.ID2 = H3.ID

-- Q8. Find the difference between the number of students in the school and the
-- number of different first names.
select count(*) - count(distinct name)
from Highschooler

-- Q9. Find the name and grade of all students who are liked by more than one
-- other student.
select distinct name, grade
from Highschooler, Likes L1 
where L1.ID2 = Highschooler.ID and 
    1 < (select count(*) from Likes L2 where L2.ID2 = L1.ID2)

select name, grade
from Highschooler, Likes
where Likes.ID2 = Highschooler.ID
group by ID2 
having count(*) > 1

-- Q1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from Highschooler
where grade = 12

-- Q2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from Likes
where ID1 not in (select ID2 from Likes L2 where L2.ID1 = Likes.ID2) and
 ID1 in (select ID1 from Friend where Friend.ID2 = Likes.ID2)

-- Q3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)
insert into Friend
select F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F1.ID1 <> F2.ID2
except
select ID1, ID2
from Friend

insert into Friend
select distinct F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F1.ID1 <> F2.ID2
    and F1.ID1 not in (select ID2 from Friend F3 where ID1 = F2.ID2)

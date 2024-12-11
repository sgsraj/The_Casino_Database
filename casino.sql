CREATE TABLE Players(
	birth_day DATE,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    is_dealer BOOL,
    g_id INT PRIMARY KEY
);

INSERT INTO Players (birth_day, first_name, last_name, is_dealer, g_id) VALUES
('1990-05-12', 'John', 'Doe', false, 1),
('1985-11-7', 'Jane', 'Smith', false, 2),
('1992-03-07', 'Alice', 'Johnson', true, 3),
('1980-01-15', 'Bob', 'Brown', false, 4),
('1995-07-30', 'Charlie', 'Davis', true, 5),
('2005-11-05', 'Eve', 'Wilson', false, 6),
('1993-12-22', 'Frank', 'Miller', false, 7),
('2004-09-18', 'Grace', 'Moore', false, 8),
('2004-10-30', 'Hank', 'Taylor', false, 9),
('1987-04-25', 'Ivy', 'Anderson', false, 10),
('1994-08-14', 'Jack', 'Thomas', false, 11);

CREATE TABLE Hands(
	time DATETIME,
    game_type VARCHAR(20),
    g_id INT,
    r_id INT,
    h_id INT PRIMARY KEY,
    FOREIGN KEY (g_id) REFERENCES Players(g_id)
);

INSERT INTO Hands (time, game_type, g_id, r_id, h_id) VALUES
('2023-10-01 11:15:01','Blackjack', 8,1,1),
('2023-10-01 11:15:35','Blackjack', 3,1,2),
('2023-10-08 09:53:12','Blackjack', 10,2,3),
('2023-10-08 09:53:52','Blackjack', 5,2,4),
('2024-09-23 17:08:51','Blackjack', 9,3,5),
('2024-09-23 17:09:23','Blackjack', 3,3,6),
('2024-10-02 15:08:01','Blackjack', 9,4,7),
('2024-10-02 15:08:34','Blackjack', 3,4,8),
('2024-10-31 16:38:23','Poker', 8,5,9),
('2024-10-31 16:38:23','Poker', 10,5,10),
('2024-10-31 16:38:23','Poker', 2,5,11),
('2024-10-31 16:38:23','Poker', 4,5,12),
('2024-11-01 15:28:11','Poker', 1,6,13),
('2024-11-01 15:28:11','Poker', 2,6,14),
('2024-11-01 15:28:11','Poker', 8,6,15),
('2024-10-02 15:08:01','Blackjack', 2,7,16),
('2024-10-02 15:08:34','Blackjack', 5,7,17),
('2024-09-30 20:13:21','Poker', 6,6,18),
('2024-09-30 20:13:21','Poker', 7,6,19),
('2024-09-30 20:13:21','Poker', 11,6,20);

CREATE TABLE Cards(
	rnk INT,
    suit VARCHAR(20),
    h_id INT,
    FOREIGN KEY (h_id) REFERENCES Hands(h_id)
);

INSERT INTO Cards(rnk,suit,h_id) VALUES
(2,'Diamonds',1),(5,'Diamonds',1),(3,'Spades',1), -- value 10
(10,'Hearts',2),(10,'Spades',2), -- value 20
(9,'Diamonds',3),(10,'Clubs',3),(3,'Clubs',3), -- value 0
(2,'Hearts',4),(2,'Spades',4),(2,'Diamonds',4),(2,'Clubs',4),(3,'Hearts',4),
(3,'Spades',4),(3,'Diamonds',4),(4,'Clubs',4), -- value 21
(10,'Hearts',5),(10,'Spades',5),(10,'Clubs',5), -- value 0
(1,'Hearts',6),(10,'Diamonds',6), -- value 21
(13,'Hearts',7),(12,'Diamonds',7), -- value 20
(1,'Hearts',8),(1,'Diamonds',8),(11,'Hearts',8),(5,'Diamonds',8), -- value 17
(1,'Hearts',9),(10,'Hearts',9),(11,'Hearts',9),(12,'Hearts',9),(13,'Hearts',9), -- Straight-flush
(9,'Hearts',10),(9,'Diamonds',10),(9,'Spades',10),(9,'Clubs',10),(2,'Hearts',10),-- Four of a kind
(8,'Hearts',11),(8,'Diamonds',11),(8,'Spades',11),(7,'Clubs',11),(7,'Hearts',11),-- Full house
(3,'Clubs',12),(4,'Clubs',12),(5,'Clubs',12),(6,'Clubs',12),(11,'Clubs',12), -- Flush
(1,'Clubs',13),(2,'Clubs',13),(3,'Hearts',13),(4,'Hearts',13),(5,'Diamonds',13), -- Straight
(10,'Hearts',14),(10,'Diamonds',14),(10,'Clubs',14),(9,'Hearts',14),
(8,'Diamonds',14), -- Three of a kind
(8,'Hearts',15),(8,'Spades',15),(7,'Clubs',15),(7,'Hearts',15),(3,'Diamonds',15),-- Two pairs
(1,'Diamonds',16),(1,'Hearts',16), -- value 12
(2,'Diamonds',17),(5,'Diamonds',17), -- value 7
(1,'Hearts',18),(1,'Spades',18),(8,'Clubs',18),(9,'Hearts',18),(6,'Diamonds',18),-- Pair
(1,'Diamonds',19),(2,'Diamonds',19),(11,'Diamonds',19),(12,'Diamonds',19),
(13,'Hearts',19), -- High card
(4,'Diamonds',20),(5,'Diamonds',20),(10,'Diamonds',20),(12,'Hearts',20),
(13,'Diamonds',20); -- High card

CREATE TABLE Bets(
	amount INT,
    h_id INT,
    FOREIGN KEY (h_id) REFERENCES Hands(h_id)
);

INSERT INTO Bets (amount,h_id) VALUES (12,1),(4,3),(19,5),
(2,7),(1,9),(4,9),(1,10),(4,10),(5,11),(5,12), -- these are in October 2024
(17,13),(6,14),(11,14),(8,15),(9,15),
(42,16),-- and this one is in October 2024
(1,18),(1,19),(1,20);

CREATE VIEW October2024Bets AS
SELECT SUM(B.amount) AS total_bets
FROM Bets B
NATURAL JOIN Hands H
WHERE H.time >= '2024-10-01' AND H.time < '2024-11-01';

SELECT * FROM October2024Bets;

CREATE VIEW Above20 AS
SELECT h.h_id,p.first_name,p.last_name,
DATEDIFF(h.time, p.birth_day) >= 7305 AS Above20
FROM Hands h
NATURAL JOIN Players p 
ORDER BY h.h_id;

SELECT * FROM Above20 ORDER BY h_id;

CREATE VIEW BirthdaySorting AS
(SELECT birth_day, first_name, last_name,
1 AS birthday_group
FROM Players
WHERE 
(MONTH(birth_day) = 11 AND DAY(birth_day) >= 6) OR 
(MONTH(birth_day) > 11))
UNION 
(SELECT birth_day,first_name,last_name,
2 AS birthday_group
FROM Players
WHERE 
(MONTH(birth_day) < 11) OR 
(MONTH(birth_day) = 11 AND DAY(birth_day) < 6)) 
ORDER BY 
birthday_group,
MONTH(birth_day), 
DAY(birth_day);

SELECT * FROM BirthdaySorting;

CREATE VIEW UpcomingBirthdays AS 
SELECT birth_day,first_name,last_name
FROM BirthdaySorting 
ORDER BY 
birthday_group,
MONTH(birth_day), 
DAY(birth_day);

SELECT * FROM UpcomingBirthdays;

CREATE VIEW SimpleBlackjack AS
SELECT h_id,
(SUM(rnk) * (SUM(rnk) <= 21)) AS Hand_value
FROM Cards
WHERE rnk >= 2 AND rnk <= 10 AND h_id IN (SELECT h_id FROM Hands WHERE game_type = 'Blackjack')
GROUP BY h_id;

SELECT * FROM SimpleBlackjack WHERE h_id<=5 ORDER BY h_id;

CREATE VIEW NotSoSimpleBlackjack AS
SELECT h.h_id,h.r_id,
SUM((c.rnk >= 2 AND c.rnk <= 10) * c.rnk + (c.rnk >= 11 AND c.rnk <= 13) * 10) +
(SUM(c.rnk = 1) * (IF(SUM((c.rnk >= 2 AND c.rnk <= 10) * c.rnk + (c.rnk >= 11 AND c.rnk <= 13) * 10) <= 10, 11, 1)))
AS hand_value
FROM Cards c
NATURAL JOIN Hands h
WHERE h.h_id > 5 AND h.game_type = 'Blackjack'
GROUP BY h.h_id, h.r_id;

CREATE VIEW CombinedBlackjack AS
SELECT h_id,Hand_value
FROM 
(SELECT h_id,
(SUM(rnk) * (SUM(rnk) <= 21)) AS Hand_value
FROM Cards
WHERE rnk >= 2 AND rnk <= 10 AND h_id <= 5
GROUP BY h_id
UNION ALL
SELECT h.h_id,
SUM((c.rnk >= 2 AND c.rnk <= 10) * c.rnk + (c.rnk >= 11 AND c.rnk <= 13) * 10) +
(SUM(c.rnk = 1) * (IF(SUM((c.rnk >= 2 AND c.rnk <= 10) * c.rnk + (c.rnk >= 11 AND c.rnk <= 13) * 10) <= 10, 11, 1)))
AS hand_value
FROM Cards c
NATURAL JOIN Hands h 
WHERE h.h_id > 5 AND h.game_type = 'Blackjack'
GROUP BY h.h_id) 
AS unified_hand_values
ORDER BY h_id;

CREATE VIEW BlackjackSummary AS
SELECT o_rounds.r_id,
o.hand_value AS outsider_hand_value,
d.hand_value AS dealer_hand_value,
(o.hand_value > d.hand_value) AS outsider_wins
FROM (SELECT r_id, MIN(h_id) AS h_id FROM Hands WHERE game_type = 'Blackjack' GROUP BY r_id) AS o_rounds
JOIN (SELECT r_id, MAX(h_id) AS h_id FROM Hands WHERE game_type = 'Blackjack' GROUP BY r_id) AS d_rounds
ON o_rounds.r_id = d_rounds.r_id
JOIN CombinedBlackjack AS o ON o_rounds.h_id = o.h_id
JOIN CombinedBlackjack AS d ON d_rounds.h_id = d.h_id
ORDER BY o_rounds.r_id;

SELECT * FROM BlackjackSummary ORDER BY r_id;

CREATE VIEW Blackjack AS
SELECT r_id,outsider_wins
FROM BlackjackSummary
ORDER BY r_id;

SELECT * FROM Blackjack ORDER BY r_id;




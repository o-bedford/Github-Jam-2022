LOW
UPDATE Cards
SET SP = abs(random()) % (5 - 1) + 1
WHERE ID = 2 OR ID = 5 OR ID = 6 OR ID = 9 OR ID = 13 OR ID = 18 OR ID = 19 OR ID = 21 OR ID = 25 OR ID = 26 OR ID = 27 OR ID = 32 OR ID = 33 OR ID = 35 OR ID = 43 OR ID = 50

MED
UPDATE Cards
SET SP = abs(random() % (3-5) + 5)
WHERE ID = 3 OR ID = 4 OR ID = 11 OR ID = 14 OR ID = 15 OR ID = 20 OR ID = 22 OR ID = 24 OR ID = 30 OR ID = 38 OR ID = 42 OR ID = 47 OR ID = 49 OR ID = 51 OR ID = 52 OR ID = 53 OR ID = 57 OR ID = 58

HIGH
UPDATE Cards
SET SP = abs(random()) % (10 - 7) + 7
WHERE ID = 8 OR ID = 10 OR ID = 17 OR ID = 28 OR ID = 29 OR ID = 34 OR ID = 37 OR ID = 40 OR ID = 41 OR ID = 44 OR ID = 46 OR ID = 48 OR ID = 55
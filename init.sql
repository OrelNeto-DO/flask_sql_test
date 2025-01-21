CREATE DATABASE IF NOT EXISTS mydatabase;
USE mydatabase;

CREATE TABLE IF NOT EXISTS images (
    id INT AUTO_INCREMENT PRIMARY KEY, 
    image_url VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS visit_count (
    id INT AUTO_INCREMENT PRIMARY KEY,
    count INT DEFAULT 0
);

-- הוספת שורה בה מתחילים את הספירה
INSERT INTO visit_count (count) VALUES (0);

-- הוספת תמונות
INSERT INTO images (image_url) VALUES 
("https://media3.giphy.com/media/v1.Y2lkPTc5MGI3NjExbjkyZm9vZGR6MXhsYWJidm1hOGY5Zm9qZDdkbjRyc2pzenZwZ2hrYSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/wJ2dyF1tznkqMaq0ju/giphy.webp"),
("https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExeDE4OXo4amFjdmw4NGpuYmhieGs0ZHR5NGVpbTN0enI5cnQyNWs1dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/eLXnKnW3eU9FGX0rdr/giphy.webp"),
("https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExb2pqcWl4MTNzeGQ4ZGxtMzZteTd1ZzM4aTVreWZuODh5NmV3bDg3eiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/TIKlnvZRky3CTFXdHi/giphy.webp"),
("https://media1.giphy.com/media/v1.Y2lkPTc5MGI3NjExdHRneXZkaGNydDY3end0YWhjdHV6cGF4ZWRiaW90ZWVmMmhqZnI3cSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/tPKmFhIOtrP6rguGSF/giphy.webp"),
("https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExcXVsNTZ6cHozaHBid2NlMTFnamc1dGl2a2gxZnk3cHZwNjJ6d2gwYyZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/tlAWLAuyX9EvgV9BnD/giphy.webp"),
("https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExenZraTJuY29meGVkczVxZjcwZWg3Yno0azM0OHNhM2F1ZXM2cWlvOCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/7VxqgDYjpIibFzVIb6/giphy.webp");

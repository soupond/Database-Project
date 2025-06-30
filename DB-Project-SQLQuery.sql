CREATE DATABASE TrainingSystem;
GO

USE TrainingSystem;
GO

CREATE TABLE Trainee (
    trainee_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
    email NVARCHAR(100) UNIQUE NOT NULL,
    background NVARCHAR(200)
);


CREATE TABLE Trainer (
    trainer_id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    specialty NVARCHAR(100),
    phone VARCHAR(20),
    email NVARCHAR(100) UNIQUE
);


CREATE TABLE Course (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(100) NOT NULL,
    category NVARCHAR(50),
    duration_hours INT,
    level VARCHAR(20) CHECK (level IN ('Beginner', 'Intermediate', 'Advanced'))
);


CREATE TABLE Schedule (
    schedule_id INT PRIMARY KEY IDENTITY(1,1),
    course_id INT,
    trainer_id INT,
    start_date DATE,
    end_date DATE,
    time_slot VARCHAR(20) CHECK (time_slot IN ('Morning', 'Evening', 'Weekend')),
    FOREIGN KEY (course_id) REFERENCES Course(course_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT PRIMARY KEY IDENTITY(1,1),
    trainee_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (trainee_id) REFERENCES Trainee(trainee_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

SET IDENTITY_INSERT Trainee ON;

INSERT INTO Trainee (trainee_id, name, gender, email, background) VALUES
(1, 'Aisha Al-Harthy', 'Female', 'aisha@example.com', 'Engineering'),
(2, 'Sultan Al-Farsi', 'Male', 'sultan@example.com', 'Business'),
(3, 'Mariam Al-Saadi', 'Female', 'mariam@example.com', 'Marketing'),
(4, 'Omar Al-Balushi', 'Male', 'omar@example.com', 'Computer Science'),
(5, 'Fatma Al-Hinai', 'Female', 'fatma@example.com', 'Data Science');

SET IDENTITY_INSERT Trainee OFF;

SET IDENTITY_INSERT Trainer ON;

INSERT INTO Trainer (trainer_id, name, specialty, phone, email) VALUES
(1, 'Khalid Al-Maawali', 'Databases', '96891234567', 'khalid@example.com'),
(2, 'Noura Al-Kindi', 'Web Development', '96892345678', 'noura@example.com'),
(3, 'Salim Al-Harthy', 'Data Science', '96893456789', 'salim@example.com');

SET IDENTITY_INSERT Trainer OFF;

SET IDENTITY_INSERT Course ON;

INSERT INTO Course (course_id, title, category, duration_hours, level) VALUES
(1, 'Database Fundamentals', 'Databases', 20, 'Beginner'),
(2, 'Web Development Basics', 'Web', 30, 'Beginner'),
(3, 'Data Science Introduction', 'Data Science', 25, 'Intermediate'),
(4, 'Advanced SQL Queries', 'Databases', 15, 'Advanced');

SET IDENTITY_INSERT Course OFF;

SET IDENTITY_INSERT Schedule ON;

INSERT INTO Schedule (schedule_id, course_id, trainer_id, start_date, end_date, time_slot) VALUES
(1, 1, 1, '2025-07-01', '2025-07-10', 'Morning'),
(2, 2, 2, '2025-07-05', '2025-07-20', 'Evening'),
(3, 3, 3, '2025-07-10', '2025-07-25', 'Weekend'),
(4, 4, 1, '2025-07-15', '2025-07-22', 'Morning');

SET IDENTITY_INSERT Schedule OFF;


SET IDENTITY_INSERT Enrollment ON;

INSERT INTO Enrollment (enrollment_id, trainee_id, course_id, enrollment_date) VALUES
(1, 1, 1, '2025-06-01'),
(2, 2, 1, '2025-06-02'),
(3, 3, 2, '2025-06-03'),
(4, 4, 3, '2025-06-04'),
(5, 5, 3, '2025-06-05'),
(6, 1, 4, '2025-06-06');

SET IDENTITY_INSERT Enrollment OFF;

-- View all Trainees
SELECT * FROM Trainee;

-- View all Trainers
SELECT * FROM Trainer;

-- View all Courses
SELECT * FROM Course;

-- View all Schedules
SELECT * FROM Schedule;

-- View all Enrollments
SELECT * FROM Enrollment;


-- Get all courses where the level is Beginner
SELECT course_id, title, category, level
FROM Course
WHERE level = 'Beginner';


-- Show the courses and schedule details for a trainee named 'Aisha Al-Harthy'
SELECT 
    t.name AS trainee_name,
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Enrollment AS e
JOIN Trainee AS t ON e.trainee_id = t.trainee_id
JOIN Course AS c ON e.course_id = c.course_id
LEFT JOIN Schedule AS s ON s.course_id = c.course_id
WHERE t.name = 'Aisha Al-Harthy';


-- List trainers along with the courses they are scheduled to teach
SELECT 
    tr.name AS trainer_name,
    c.title AS course_title,
    s.time_slot
FROM Schedule AS s
JOIN Trainer AS tr ON s.trainer_id = tr.trainer_id
JOIN Course AS c ON s.course_id = c.course_id
ORDER BY tr.name;


-- Count total enrollments per course
SELECT 
    c.title AS course_title,
    COUNT(e.trainee_id) AS total_enrollments
FROM Course AS c
LEFT JOIN Enrollment AS e ON c.course_id = e.course_id
GROUP BY c.title
ORDER BY total_enrollments DESC;


-- Display course schedules with trainer and time slot, ordered by start date
SELECT 
    c.title AS course_title,
    tr.name AS trainer_name,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
JOIN Trainer AS tr ON s.trainer_id = tr.trainer_id
ORDER BY s.start_date;

-- Get trainees enrolled in the course 'Data Science Introduction'
SELECT 
    t.name AS trainee_name,
    t.email,
    c.title AS course_title,
    e.enrollment_date
FROM Enrollment AS e
JOIN Trainee AS t ON e.trainee_id = t.trainee_id
JOIN Course AS c ON e.course_id = c.course_id
WHERE c.title = 'Data Science Introduction';


-- Show all courses and the trainers assigned to them
SELECT 
    c.title AS course_title,
    tr.name AS trainer_name,
    tr.specialty
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
JOIN Trainer AS tr ON s.trainer_id = tr.trainer_id
ORDER BY c.title;


-- Retrieve all course titles with their level and category
SELECT 
    title, 
    level, 
    category
FROM Course;

-- Get only beginner-level courses that belong to the 'Data Science' category
SELECT 
    title, 
    level, 
    category
FROM Course
WHERE level = 'Beginner' AND category = 'Data Science';


-- List course titles the trainee with ID 1 is enrolled in
SELECT 
    c.title
FROM Enrollment AS e
JOIN Course AS c ON e.course_id = c.course_id
WHERE e.trainee_id = 1;


-- Show schedule (start date and time slot) for courses the trainee with ID 1 is enrolled in
SELECT 
    c.title AS course_title,
    s.start_date,
    s.time_slot
FROM Enrollment AS e
JOIN Course AS c ON e.course_id = c.course_id
JOIN Schedule AS s ON c.course_id = s.course_id
WHERE e.trainee_id = 1;


-- Count the number of enrollments for trainee ID 1
SELECT 
    COUNT(*) AS total_courses
FROM Enrollment
WHERE trainee_id = 1;


-- Show course title, trainer name, and time slot for each course the trainee with ID 1 attends
SELECT 
    c.title AS course_title,
    tr.name AS trainer_name,
    s.time_slot
FROM Enrollment AS e
JOIN Course AS c ON e.course_id = c.course_id
JOIN Schedule AS s ON c.course_id = s.course_id
JOIN Trainer AS tr ON s.trainer_id = tr.trainer_id
WHERE e.trainee_id = 1;


-- Get all courses assigned to trainer with ID 1
SELECT 
    c.title AS course_title
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
WHERE s.trainer_id = 1;
-- Show sessions (start/end date and time slot) scheduled in the future for trainer ID 1
SELECT 
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
WHERE s.trainer_id = 1 AND s.start_date > GETDATE();


-- Count enrolled trainees per course taught by trainer ID 1
SELECT 
    c.title AS course_title,
    COUNT(e.trainee_id) AS total_trainees
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
LEFT JOIN Enrollment AS e ON c.course_id = e.course_id
WHERE s.trainer_id = 1
GROUP BY c.title;


-- List names and emails of trainees in courses taught by trainer ID 1
SELECT 
    c.title AS course_title,
    t.name AS trainee_name,
    t.email AS trainee_email
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
JOIN Enrollment AS e ON c.course_id = e.course_id
JOIN Trainee AS t ON e.trainee_id = t.trainee_id
WHERE s.trainer_id = 1
ORDER BY c.title;


-- Display phone, email, and course titles for trainer ID 1
SELECT 
    tr.name AS trainer_name,
    tr.phone,
    tr.email,
    c.title AS course_title
FROM Trainer AS tr
JOIN Schedule AS s ON tr.trainer_id = s.trainer_id
JOIN Course AS c ON s.course_id = c.course_id
WHERE tr.trainer_id = 1;


-- Count the number of unique courses assigned to trainer ID 1
SELECT 
    COUNT(DISTINCT course_id) AS course_count
FROM Schedule
WHERE trainer_id = 1;


-- Add a new course to the Course table
INSERT INTO Course (title, category, duration_hours, level)
VALUES ('Python Programming Basics', 'Programming', 40, 'Beginner');


-- Create a schedule assigning trainer 2 to course 1 starting on August 1
INSERT INTO Schedule (course_id, trainer_id, start_date, end_date, time_slot)
VALUES (1, 2, '2025-08-01', '2025-08-15', 'Evening');


-- Show which trainees are enrolled in which courses, along with schedule details
SELECT 
    t.name AS trainee_name,
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Enrollment AS e
JOIN Trainee AS t ON e.trainee_id = t.trainee_id
JOIN Course AS c ON e.course_id = c.course_id
LEFT JOIN Schedule AS s ON c.course_id = s.course_id
ORDER BY t.name;

-- Count the number of courses assigned to each trainer
SELECT 
    tr.name AS trainer_name,
    COUNT(DISTINCT s.course_id) AS total_courses
FROM Trainer AS tr
LEFT JOIN Schedule AS s ON tr.trainer_id = s.trainer_id
GROUP BY tr.name;


-- Get names and emails of trainees enrolled in the course titled "Data Basics"
SELECT 
    t.name AS trainee_name,
    t.email
FROM Enrollment AS e
JOIN Trainee AS t ON e.trainee_id = t.trainee_id
JOIN Course AS c ON e.course_id = c.course_id
WHERE c.title = 'Data Basics';


-- Find the course with the most enrollments
SELECT TOP 1 
    c.title AS course_title,
    COUNT(e.enrollment_id) AS total_enrollments
FROM Enrollment AS e
JOIN Course AS c ON e.course_id = c.course_id
GROUP BY c.title
ORDER BY total_enrollments DESC;


-- List all schedules ordered by the start date
SELECT 
    s.schedule_id,
    c.title AS course_title,
    s.start_date,
    s.end_date,
    s.time_slot
FROM Schedule AS s
JOIN Course AS c ON s.course_id = c.course_id
ORDER BY s.start_date ASC;


-- ADVANCED SQL LAB FILE
-- Author:  Vasamsetti Bhavika
-- This SQL file covers multiple topics:
-- DDL, DML, Joins, Subqueries, Views, Functions, Constraints,
-- Window Functions, Triggers, Stored Procedures, Indexing

/* ================================
   1. CREATE DATABASE & TABLES
================================ */

-- Create Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    course VARCHAR(50)
);

-- Create Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    duration INT
);

-- Create Enrollments table
CREATE TABLE Enrollments (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

/* ================================
   2. INSERT DATA
================================ */

INSERT INTO Students VALUES
(1, 'Amit', 21, 'BCA'),
(2, 'Priya', 22, 'BBA'),
(3, 'Sneha', 20, 'BTech'),
(4, 'Rahul', 23, 'BTech');

INSERT INTO Courses VALUES
(101, 'SQL', 30),
(102, 'Python', 45),
(103, 'Machine Learning', 60);

INSERT INTO Enrollments VALUES
(201, 1, 101, '2023-01-10'),
(202, 2, 102, '2023-02-15'),
(203, 3, 103, '2023-03-20'),
(204, 1, 103, '2023-04-12');

/* ================================
   3. BASIC SELECT & FILTERS
================================ */

SELECT * FROM Students;
SELECT * FROM Students WHERE age > 21;
SELECT name, course FROM Students ORDER BY name;

/* ================================
   4. JOINS
================================ */

-- INNER JOIN
SELECT s.name, c.course_name
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c ON e.course_id = c.course_id;

-- LEFT JOIN
SELECT s.name, e.enrollment_date
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id;

/* ================================
   5. AGGREGATE & GROUP BY
================================ */

SELECT course_id, COUNT(student_id) AS total_students
FROM Enrollments
GROUP BY course_id;

SELECT course, AVG(age) AS average_age
FROM Students
GROUP BY course;

/* ================================
   6. SUBQUERIES
================================ */

-- Students enrolled in more than one course
SELECT name FROM Students
WHERE student_id IN (
    SELECT student_id
    FROM Enrollments
    GROUP BY student_id
    HAVING COUNT(course_id) > 1
);

-- Highest‐duration course
SELECT course_name
FROM Courses
WHERE duration = (SELECT MAX(duration) FROM Courses);

/* ================================
   7. VIEWS
================================ */

CREATE VIEW StudentCourseInfo AS
SELECT s.name, c.course_name, e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON c.course_id = e.course_id;

SELECT * FROM StudentCourseInfo;

/* ================================
   8. FUNCTIONS
================================ */

-- UDF Example (MySQL style)
-- returns age category
CREATE FUNCTION AgeCategory(age INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF age < 21 THEN RETURN 'Teen';
    ELSE RETURN 'Adult';
    END IF;
END;

SELECT name, AgeCategory(age) AS category FROM Students;

/* ================================
   9. WINDOW FUNCTIONS
================================ */

SELECT 
    s.name,
    e.course_id,
    ROW_NUMBER() OVER (PARTITION BY s.student_id ORDER BY e.enrollment_date) AS course_order
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id;

/* ================================
   10. TRIGGER
================================ */

CREATE TABLE Logs (
    log_id INT PRIMARY KEY,
    operation VARCHAR(20),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER StudentInsertLog
AFTER INSERT ON Students
FOR EACH ROW
INSERT INTO Logs(log_id, operation) VALUES (NEW.student_id, 'INSERT');

/* ================================
   11. STORED PROCEDURE
================================ */

-- Procedure to list all courses with duration > given input
CREATE PROCEDURE ListLongCourses(IN min_duration INT)
BEGIN
    SELECT * FROM Courses WHERE duration > min_duration;
END;

CALL ListLongCourses(40);

/* ================================
   12. INDEXING
================================ */

CREATE INDEX idx_student_course
ON Students(course);


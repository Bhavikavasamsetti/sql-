
-- ===============================================

/* -----------------------------------------------
   1. CREATE DATABASE
------------------------------------------------ */
CREATE DATABASE StudentManagement;
USE StudentManagement;

/* -----------------------------------------------
   2. CREATE TABLES
------------------------------------------------ */

-- Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    course_id INT
);

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    duration_months INT
);

-- Marks Table
CREATE TABLE Marks (
    mark_id INT PRIMARY KEY,
    student_id INT,
    subject VARCHAR(50),
    marks INT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- Attendance Table
CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY,
    student_id INT,
    date DATE,
    status VARCHAR(10),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

/* -----------------------------------------------
   3. INSERT DATA
------------------------------------------------ */

INSERT INTO Courses VALUES
(101, 'Computer Science', 36),
(102, 'Business Management', 24),
(103, 'Mechanical Engineering', 48);

INSERT INTO Students VALUES
(1, 'Amit', 'Kumar', 20, 'Male', 101),
(2, 'Priya', 'Sharma', 21, 'Female', 102),
(3, 'Rohan', 'Singh', 22, 'Male', 101),
(4, 'Sneha', 'Reddy', 19, 'Female', 103),
(5, 'Rahul', 'Verma', 23, 'Male', 103);

INSERT INTO Marks VALUES
(1, 1, 'Math', 88),
(2, 1, 'Programming', 92),
(3, 2, 'Business Studies', 75),
(4, 3, 'Math', 81),
(5, 4, 'Mechanics', 90),
(6, 5, 'Thermodynamics', 85);

INSERT INTO Attendance VALUES
(1, 1, '2024-01-01', 'Present'),
(2, 1, '2024-01-02', 'Absent'),
(3, 2, '2024-01-01', 'Present'),
(4, 3, '2024-01-01', 'Present'),
(5, 4, '2024-01-01', 'Absent');

/* -----------------------------------------------
   4. BASIC QUERIES
------------------------------------------------ */

-- View all students
SELECT * FROM Students;

-- List all courses
SELECT * FROM Courses;

-- Check marks of a specific student
SELECT * FROM Marks WHERE student_id = 1;

/* -----------------------------------------------
   5. JOINS
------------------------------------------------ */

-- Student with their course
SELECT s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Courses c ON s.course_id = c.course_id;

-- Student with marks
SELECT s.first_name, m.subject, m.marks
FROM Students s
JOIN Marks m ON s.student_id = m.student_id;

/* -----------------------------------------------
   6. GROUP BY & AGGREGATIONS
------------------------------------------------ */

-- Average marks per student
SELECT student_id, AVG(marks) AS average_marks
FROM Marks
GROUP BY student_id;

-- Count students in each course
SELECT course_id, COUNT(student_id) AS total_students
FROM Students
GROUP BY course_id;

/* -----------------------------------------------
   7. SUBQUERIES
------------------------------------------------ */

-- Students with marks above average
SELECT first_name, last_name FROM Students
WHERE student_id IN (
    SELECT student_id FROM Marks
    GROUP BY student_id
    HAVING AVG(marks) > 80
);

-- Students who have perfect attendance
SELECT first_name, last_name FROM Students
WHERE student_id NOT IN (
    SELECT student_id FROM Attendance WHERE status = 'Absent'
);

/* -----------------------------------------------
   8. VIEWS
------------------------------------------------ */

CREATE VIEW StudentFullInfo AS
SELECT s.student_id, s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Courses c ON s.course_id = c.course_id;

SELECT * FROM StudentFullInfo;

/* -----------------------------------------------
   9. TRIGGER
------------------------------------------------ */

CREATE TABLE ActivityLog (
    log_id INT PRIMARY KEY,
    action VARCHAR(50),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogNewStudent
AFTER INSERT ON Students
FOR EACH ROW
INSERT INTO ActivityLog (log_id, action)
VALUES (NEW.student_id, 'New Student Added');

/* -----------------------------------------------
   10. STORED PROCEDURE
------------------------------------------------ */

DELIMITER //
CREATE PROCEDURE GetStudentMarks(IN sid INT)
BEGIN
    SELECT subject, marks FROM Marks WHERE student_id = sid;
END //
DELIMITER ;

-- Call example
CALL GetStudentMarks(1);

/* -----------------------------------------------
   11. FUNCTIONS
------------------------------------------------ */

DELIMITER //
CREATE FUNCTION Grade(m INT)
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    IF m >= 90 THEN RETURN 'A';
    ELSEIF m >= 75 THEN RETURN 'B';
    ELSEIF m >= 60 THEN RETURN 'C';
    ELSE RETURN 'D';
    END IF;
END //
DELIMITER ;

SELECT student_id, subject, marks, Grade(marks) AS grade FROM Marks;

/* -----------------------------------------------
   12. WINDOW FUNCTIONS
------------------------------------------------ */

SELECT 
    student_id,
    subject,
    marks,
    RANK() OVER (PARTITION BY student_id ORDER BY marks DESC) AS rank_in_subjects
FROM Marks;

/* -----------------------------------------------
   13. INDEXING
------------------------------------------------ */

CREATE INDEX idx_student_course ON Students(course_id);



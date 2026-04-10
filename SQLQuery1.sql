CREATE DATABASE hico69_laba3

USE hico69_laba3


CREATE TABLE faculty(
    id INT IDENTITY(1,1) PRIMARY KEY,
    faculty_name NVARCHAR(50)
);

CREATE TABLE form(
    id INT IDENTITY(1,1) PRIMARY KEY, 
    form_name NVARCHAR(30)
);

CREATE TABLE stud(
    id INT IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(30),
    f_name NVARCHAR(30),
    s_name NVARCHAR(30),
    br_date DATE,
    in_date DATE,
    exm INT 
);

CREATE TABLE teach(
    id INT IDENTITY(1,1) PRIMARY KEY,
    last_name NVARCHAR(30),
    f_name NVARCHAR(30),
    s_name NVARCHAR(30),
    br_date DATE,
    start_work_date DATE
);

CREATE TABLE subj(
    id INT IDENTITY(1,1) PRIMARY KEY,
    subj NVARCHAR(100),
    [hours] INT
);

CREATE TABLE [hours](
    id INT IDENTITY(1,1) PRIMARY KEY,
    cours INT,
    faculty_id INT FOREIGN KEY REFERENCES faculty(id),
    form_id INT FOREIGN KEY REFERENCES form(id),   
    all_h INT,
    inclass_h INT
);

CREATE TABLE process(
    stud_id INT FOREIGN KEY REFERENCES stud(id),   
    hours_id INT FOREIGN KEY REFERENCES [hours](id),
    PRIMARY KEY (stud_id, hours_id) 
);

CREATE TABLE work(
    teach_id INT FOREIGN KEY REFERENCES teach(id),
    subj_id INT FOREIGN KEY REFERENCES subj(id),
    hours_id INT FOREIGN KEY REFERENCES [hours](id),
    PRIMARY KEY (teach_id, subj_id, hours_id)
);

--ALTER  TABLE process ADD CONSTRAINT FK_process_stud FOREIGN KEY (stud_id) REFERENCES stud(id);
--ALTER  TABLE process ADD CONSTRAINT FK_process_hours FOREIGN KEY (hours_id) REFERENCES [hours](id);
--ALTER  TABLE [hours] ADD CONSTRAINT FK_hours_faculty FOREIGN KEY (faculty_id) REFERENCES faculty(id);
--ALTER  TABLE [hours] ADD CONSTRAINT FK_hours_form FOREIGN KEY (form_id) REFERENCES form(id)

--ALTER  TABLE work ADD CONSTRAINT FK_work_hours FOREIGN KEY (hours_id) REFERENCES [hours](id);
--ALTER  TABLE work ADD CONSTRAINT FK_work_subj FOREIGN KEY (subj_id) REFERENCES subj(id);
--ALTER  TABLE work ADD CONSTRAINT FK_work_teach FOREIGN KEY (teach_id) REFERENCES teach(id);

--insert    

INSERT INTO stud (last_name, f_name, s_name, br_date, in_date, exm) VALUES
(N'Зингель', N'Иван', N'Иванович', '1980-01-01', '2018-09-01', 7),
(N'Петров', N'Петр', N'Петрович', '2001-02-02', '2015-09-01', 8),
(N'Зайцева', N'Мария', N'Валильевна', '2000-03-03', '2018-09-01', 4),
(N'Кузнецов', N'Алексей', N'Игоревич', '2002-04-04', '2014-09-01', 9),
(N'Смирнов', N'Дмитрий', N'Олегович', '2001-05-05', '2019-09-01', 6),
(N'Аграар', N'Джордан', N'', '2001-05-05', '2019-09-01', 9),
(N'Ботяновский', N'Альберт', N'', '2001-05-05', '2019-09-01', 7);

INSERT INTO faculty (faculty_name) VALUES
(N'ФПМ'),
(N'ФПК');

INSERT INTO form (form_name) VALUES
(N'очная'),
(N'заочная');

INSERT INTO [hours] (cours, faculty_id, form_id, all_h, inclass_h) VALUES
(1, 1, 1, 210, 50), 
(2, 1, 2, 120, 60),
(3, 2, 2, 110, 55), 
(1, 2, 1, 90, 45),
(1, 1, 1, 100, 50);

INSERT INTO process (stud_id, hours_id) VALUES
(1, 2),
(2, 2),
(3, 1),
(4, 4),
(5, 3),
(6, 2),
(7, 2);

INSERT INTO teach (last_name, f_name, s_name, br_date, start_work_date) VALUES
(N'Смирнов', N'Иван', N'Андреевич', '1980-05-15', '2005-09-01'),
(N'Крылов', N'Олег', N'Петрович', '1975-08-20', '2000-09-01'),
(N'Бортников', N'Дмитрий', N'Сергеевич', '1988-11-10', '2010-09-01'),
(N'Енмильоо', N'Дмитрий', N'', '1981-11-10', '2010-09-06'),
(N'Иванов', N'Алексей', N'Петрович', '1985-07-12', '2023-09-01');

INSERT INTO subj (subj, [hours]) VALUES
(N'Математика',2),
(N'Физика', 3 ),
(N'Информатика', 2),
(N'История', 2);

INSERT INTO work (teach_id, subj_id, hours_id) VALUES
(1, 1, 1), 
(1, 3, 3), 
(2, 2, 3), 
(3, 4, 4), 
(3, 1, 1),
(4, 2, 1);

--

--SELECT 1

SELECT f.faculty_name,AVG(CAST(s.exm AS FLOAT)) AS AvgeExam FROM stud s
JOIN (
    SELECT p.stud_id, h.faculty_id
    FROM process p
    JOIN [hours] h ON p.hours_id = h.id
    JOIN form fm ON h.form_id = fm.id
    WHERE fm.form_name = 'заочная'
) AS t ON s.id = t.stud_id
JOIN faculty f ON t.faculty_id = f.id
GROUP BY f.faculty_name;

--SELECT 2

SELECT f.faculty_name AS Факультет,h.cours AS Курс,MAX(s.exm) AS Макс_средний_балл
FROM 
    stud s, 
    process p, 
    [hours] h, 
    faculty f
WHERE 
    s.id = p.stud_id                
    AND p.hours_id = h.id           
    AND h.faculty_id = f.id         
GROUP BY 
    f.faculty_name, h.cours
ORDER BY 
    f.faculty_name, h.cours;

--SELECT 3

SELECT f.faculty_name AS Факультет,AVG(CAST(s.exm AS FLOAT)) AS Общий_средний_балл
FROM 
    stud s, 
    process p, 
    [hours] h, 
    faculty f
WHERE 
    s.id = p.stud_id               
    AND p.hours_id = h.id           
    AND h.faculty_id = f.id         
GROUP BY 
    f.faculty_name
HAVING 
    AVG(CAST(s.exm AS FLOAT)) > 7;  

--SELECT 4

SELECT 
    h.cours AS Курс,
    f.faculty_name AS Факультет,
    fm.form_name AS Форма_обучения,
    AVG(CAST(s.exm AS FLOAT)) AS Средний_балл
FROM 
    stud s, 
    process p, 
    [hours] h, 
    faculty f, 
    form fm
WHERE 
    s.id = p.stud_id              
    AND p.hours_id = h.id      
    AND h.faculty_id = f.id     
    AND h.form_id = fm.id         
GROUP BY 
    h.cours, 
    f.faculty_name, 
    fm.form_name
HAVING 
    AVG(CAST(s.exm AS FLOAT)) > 7.5;

--SELECT 5

SELECT 
    f.faculty_name AS Факультет,
    h.cours AS Курс,
    MIN(s.exm) AS Мин_средний_балл
FROM 
    stud s, 
    process p, 
    [hours] h, 
    faculty f
WHERE 
    s.id = p.stud_id                
    AND p.hours_id = h.id           
    AND h.faculty_id = f.id         
GROUP BY 
    f.faculty_name, h.cours
ORDER BY 
    f.faculty_name, h.cours;

--SELECT 6

SELECT 
    f.faculty_name AS Факультет,
    fm.form_name AS Форма_обучения,
    MIN(s.exm) AS Мин_средний_балл
FROM 
    stud s, 
    process p, 
    [hours] h, 
    faculty f,
    form fm
WHERE 
    s.id = p.stud_id                
    AND p.hours_id = h.id           
    AND h.faculty_id = f.id
    AND h.form_id = fm.id
GROUP BY 
    f.faculty_name, fm.form_name
HAVING 
    MIN(s.exm) > 6
ORDER BY 
    f.faculty_name, fm.form_name;

--SELECT 7

SELECT 
    (h.all_h - h.inclass_h) AS Самостоятельная_подготовка_часов
FROM 
    [hours] h, 
    faculty f, 
    form fm
WHERE 
    h.faculty_id = f.id           
    AND h.form_id = fm.id         
    AND f.faculty_name = N'ФПК'    
    AND h.cours = 3               
    AND fm.form_name = N'Заочная';

--SELECT 8

SELECT 
    f.faculty_name AS Факультет,
    h.cours AS Курс,
    fm.form_name AS Форма_обучения,
    (h.all_h - h.inclass_h) AS Самостоятельные_часы
FROM 
    [hours] h,
    faculty f,
    form fm
WHERE 
    h.faculty_id = f.id
    AND h.form_id = fm.id
    AND (h.all_h - h.inclass_h) = 150
ORDER BY 
    f.faculty_name, h.cours, fm.form_name;

--SELECT 9

SELECT 
    t.last_name AS Фамилия,
    t.f_name AS Имя,
    t.s_name AS Отчество,
    COUNT(w.subj_id) AS Количество_предметов
FROM 
    teach t,
    work w
WHERE 
    t.id = w.teach_id
GROUP BY 
    t.id, t.last_name, t.f_name, t.s_name
ORDER BY 
    Количество_предметов DESC, t.last_name;

--SELECT 10

SELECT 
    f.faculty_name AS Факультет,
    COUNT(DISTINCT w.teach_id) AS Количество_преподавателей
FROM 
    faculty f, 
    [hours] h, 
    work w
WHERE 
    f.id = h.faculty_id      
    AND h.id = w.hours_id   
GROUP BY 
    f.faculty_name;

--SELECT 11

SELECT 
    s.subj AS Предмет,
    MAX(s.[hours]) AS Максимальное_количество_часов
FROM 
    subj s
GROUP BY 
    s.subj
ORDER BY 
    s.subj;

--SELECT 12

SELECT 
    t.last_name AS Фамилия, 
    t.f_name AS Имя
FROM 
    teach t, 
    work w
WHERE 
    t.id = w.teach_id          
GROUP BY 
    t.id, t.last_name, t.f_name 
HAVING 
    COUNT(DISTINCT w.subj_id) > 1; 

--SELECT 13

SELECT 
    f.faculty_name AS Факультет, 
    h.cours AS Курс, 
    SUM(h.all_h) AS Всего_часов
FROM 
    faculty f, 
    [hours] h
WHERE 
    f.id = h.faculty_id  
GROUP BY 
    f.faculty_name,       
    h.cours;   
    
--SELECT 14

SELECT 
    f.faculty_name AS Факультет,
    COUNT(DISTINCT w.subj_id) AS Количество_предметов
FROM 
    faculty f
    INNER JOIN [hours] h ON f.id = h.faculty_id
    INNER JOIN work w ON h.id = w.hours_id
    INNER JOIN teach t ON w.teach_id = t.id
WHERE 
    (t.s_name IS NULL OR t.s_name = '')
GROUP BY 
    f.faculty_name
ORDER BY 
    f.faculty_name; 
    
--SELECT 15

SELECT 
    f.faculty_name AS Факультет, 
    COUNT(DISTINCT w.subj_id) AS Количество_предметов
FROM 
    faculty f, 
    [hours] h, 
    work w, 
    teach t
WHERE 
    f.id = h.faculty_id            
    AND h.id = w.hours_id            
    AND w.teach_id = t.id            
    AND (t.s_name IS NULL OR t.s_name = '') 
GROUP BY 
    f.faculty_name;

--JOIN 1

SELECT STUD.f_name, STUD.last_name, STUD.s_name, STUD.br_date, STUD.in_date, STUD.exm, [hours].cours, FACULTY.faculty_name FROM PROCESS 
JOIN STUD ON PROCESS.stud_id = STUD.id
JOIN HOURS ON PROCESS.hours_id = HOURS.id
JOIN FACULTY ON HOURS.faculty_id = FACULTY.id
JOIN FORM ON HOURS.form_id = FORM.id
WHERE FORM.form_name='Заочная' AND (DATEDIFF(YEAR, STUD.br_date, GETDATE()) < 37)

--JOIN 2

SELECT FACULTY.id, FACULTY.faculty_name, COUNT(STUD.id) FROM FACULTY 
JOIN HOURS ON FACULTY.id = HOURS.faculty_id
JOIN PROCESS ON HOURS.id = PROCESS.hours_id
JOIN STUD ON PROCESS.stud_id = STUD.id
GROUP BY FACULTY.id, FACULTY.faculty_name

--JOIN 3

SELECT FORM.id, FORM.form_name, COUNT(STUD.id) FROM FORM
JOIN HOURS ON FORM.id = HOURS.form_id
JOIN PROCESS ON HOURS.id = PROCESS.hours_id
JOIN STUD ON PROCESS.stud_id = STUD.id
GROUP BY FORM.id, FORM.form_name

--JOIN 4 

SELECT FACULTY.id, FACULTY.faculty_name, AVG(DATEDIFF(YEAR, STUD.br_date, GETDATE())) FROM FACULTY
JOIN HOURS ON FACULTY.id = HOURS.faculty_id
JOIN PROCESS ON HOURS.id = PROCESS.hours_id
JOIN STUD ON PROCESS.stud_id = STUD.id
GROUP BY FACULTY.id, FACULTY.faculty_name;

--JOIN 5 

SELECT STUD.f_name, STUD.last_name, STUD.s_name, STUD.in_date, [hours].cours, FACULTY.faculty_name, FORM.form_name FROM PROCESS
JOIN STUD ON PROCESS.stud_id = STUD.id
JOIN HOURS ON PROCESS.hours_id = HOURS.id
JOIN FACULTY ON HOURS.faculty_id = FACULTY.id
JOIN FORM ON HOURS.form_id = FORM.id
WHERE STUD.last_name IS NULL OR STUD.last_name = ''

--JOIN 6

SELECT TOP 1 f.faculty_name,COUNT(*) AS ПоступСтуденты FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
WHERE YEAR(s.in_date) = 2015
GROUP BY f.faculty_name
ORDER BY ПоступСтуденты DESC;

--JOIN 7

SELECT f.faculty_name,fr.form_name,COUNT(DISTINCT s.id) AS ЧислоСтудентов FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fr ON h.form_id = fr.id
WHERE YEAR(s.in_date) = 2014
GROUP BY f.faculty_name,fr.form_name
ORDER BY f.faculty_name,fr.form_name;

--JOIN 8

SELECT DISTINCT f.faculty_name FROM faculty f
JOIN hours h ON f.id = h.faculty_id
JOIN form fr ON h.form_id = fr.id
WHERE fr.form_name = N'заочная';

--JOIN 9

SELECT f.faculty_name,fr.form_name,h.cours FROM faculty f
JOIN hours h ON f.id = h.faculty_id
JOIN form fr ON h.form_id = fr.id
ORDER BY f.faculty_name,fr.form_name,h.cours;

--JOIN 10

SELECT f.faculty_name,fr.form_name,COUNT(DISTINCT s.id) AS ЧислоСтудентов FROM faculty f
JOIN hours h ON f.id = h.faculty_id
JOIN form fr ON h.form_id = fr.id
JOIN process p ON h.id = p.hours_id
JOIN stud s ON p.stud_id = s.id
GROUP BY f.faculty_name,fr.form_name
ORDER BY f.faculty_name,fr.form_name;

--JOIN 11 

SELECT COUNT(DISTINCT s.id) AS ОбщееЧислоСтудентов FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
WHERE h.cours IN (1, 3);

--JOIN 12 

SELECT f.faculty_name,h.cours,COUNT(DISTINCT s.id) AS ЧислоИностранныхСтудентов
FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
WHERE s.s_name IS NULL OR s.s_name = ''
GROUP BY f.faculty_name,h.cours
ORDER BY f.faculty_name,h.cours;

--JOIN 13

SELECT f.faculty_name,h.cours,COUNT(DISTINCT s.id) AS ЧислоСтудентов
FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
WHERE s.exm > 7.5
GROUP BY f.faculty_name,h.cours
ORDER BY f.faculty_name,h.cours;

--JOIN 14

SELECT f.faculty_name,fr.form_name,COUNT(DISTINCT s.id) AS ЧислоСтудентовсСтарше45лет FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fr ON h.form_id = fr.id
WHERE DATEDIFF(year, s.br_date, GETDATE()) > 45
GROUP BY f.faculty_name,fr.form_name
ORDER BY f.faculty_name,fr.form_name;

--JOIN 15

SELECT f.faculty_name,fr.form_name,h.cours,COUNT(DISTINCT s.id) AS ЧислоСтудентовМладше27лет FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fr ON h.form_id = fr.id
WHERE DATEDIFF(year, s.br_date, GETDATE()) < 27
GROUP BY f.faculty_name,fr.form_name,h.cours
ORDER BY f.faculty_name,fr.form_name,h.cours;

--JOIN 16

SELECT f.faculty_name,COUNT(DISTINCT s.id) AS СтудентыФамилияНаС FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN hours h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
WHERE s.last_name LIKE 'С%' OR s.last_name LIKE 'с%'
GROUP BY f.faculty_name
ORDER BY f.faculty_name;

--SUBQUERY 1

SELECT last_name, f_name, s_name, exm FROM stud
WHERE exm >= (SELECT MAX(exm) * 0.8 FROM stud);

--SUBQUERY 2

SELECT last_name, f_name, s_name, exm FROM stud
WHERE exm = (SELECT MAX(exm) FROM stud);

--SUBQUERY 3

SELECT s.last_name FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
WHERE f.id = ( SELECT TOP 1 faculty_id FROM [hours] h
JOIN process p ON h.id = p.hours_id GROUP BY faculty_id ORDER BY COUNT(DISTINCT p.stud_id) DESC
);

--SUBQUERY 4

SELECT DISTINCT s.last_name, s.f_name, s.s_name, f.faculty_name, fo.form_name, h.cours FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fo ON h.form_id = fo.id
INNER JOIN (
    SELECT h2.faculty_id, h2.form_id, h2.cours FROM stud s2
    JOIN process p2 ON s2.id = p2.stud_id
    JOIN [hours] h2 ON p2.hours_id = h2.id
    GROUP BY h2.faculty_id, h2.form_id, h2.cours
    HAVING COUNT(CASE WHEN s2.s_name IS NULL OR s2.s_name = '' THEN 1 END) = 0
) AS ValidGroups ON 
    h.faculty_id = ValidGroups.faculty_id AND 
    h.form_id = ValidGroups.form_id AND 
    h.cours = ValidGroups.cours;

--SUBQUERY 5

SELECT DISTINCT s.last_name, s.f_name, s.s_name, f.faculty_name, fo.form_name, h.cours
FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fo ON h.form_id = fo.id
WHERE h.cours IN (
    SELECT h2.cours 
    FROM [hours] h2
    JOIN process p2 ON h2.id = p2.hours_id
    JOIN stud s2 ON p2.stud_id = s2.id
    WHERE s2.last_name = N'Ботяновский'
)
AND s.last_name <> N'Ботяновский'
ORDER BY h.cours, s.last_name;

--SUBQUERY 6

SELECT DISTINCT s.last_name, s.f_name, s.s_name, f.faculty_name, fo.form_name, h.cours
FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN form fo ON h.form_id = fo.id
WHERE h.cours IN (
    SELECT h2.cours 
    FROM [hours] h2
    JOIN process p2 ON h2.id = p2.hours_id
    JOIN stud s2 ON p2.stud_id = s2.id
    WHERE s2.last_name IN (N'Зингель', N'Зайцева')
)
AND s.last_name NOT IN (N'Зингель', N'Зайцева')
ORDER BY h.cours, s.last_name;

--SUBQUERY 7

SELECT last_name, f_name, faculty_name, cours FROM stud
JOIN process ON stud.id = process.stud_id
JOIN [hours] ON process.hours_id = [hours].id
JOIN faculty ON [hours].faculty_id = faculty.id
WHERE (s_name IS NULL OR s_name = '') 
  AND hours_id IN (
      SELECT hours_id 
      FROM stud 
      JOIN process ON stud.id = process.stud_id
      WHERE s_name IS NULL OR s_name = ''
      GROUP BY hours_id
      HAVING COUNT(*) > 1
  );

--SUBQUERY 8

SELECT s.last_name, s.f_name, f.faculty_name, h.cours, t.total_count FROM stud s
JOIN process p ON s.id = p.stud_id
JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id
JOIN (
    SELECT h2.faculty_id, h2.cours, COUNT(DISTINCT p2.stud_id) total_count FROM process p2
    JOIN [hours] h2 ON p2.hours_id = h2.id
    GROUP BY h2.faculty_id, h2.cours
) t ON h.faculty_id = t.faculty_id AND h.cours = t.cours
WHERE s.s_name IS NULL OR s.s_name = ''
GROUP BY s.last_name, s.f_name, f.faculty_name, h.cours, t.total_count;

--PROCEDURE 1

GO
CREATE OR ALTER PROCEDURE GetStudentCount 
    @facName NVARCHAR(50), 
    @frmName NVARCHAR(30)
AS
BEGIN
    SELECT f.faculty_name, frm.form_name, COUNT(p.stud_id) as cnt
    FROM faculty f
    JOIN [hours] h ON f.id = h.faculty_id
    JOIN form frm ON h.form_id = frm.id
    JOIN process p ON h.id = p.hours_id
    WHERE f.faculty_name = @facName AND frm.form_name = @frmName
    GROUP BY f.faculty_name, frm.form_name;
END;
GO

--PROCEDURE 2

GO
CREATE OR ALTER PROCEDURE CalculateSubjects
AS
BEGIN
    DECLARE @fpk INT, @fpm INT, @total INT, @shared INT;
    SELECT @fpk = COUNT(DISTINCT w.subj_id) FROM work w JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id WHERE f.faculty_name = 'ФПК';
    SELECT @fpm = COUNT(DISTINCT w.subj_id) FROM work w JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id WHERE f.faculty_name = 'ФПМ';
    SELECT @total = COUNT(DISTINCT id) FROM subj;
    SELECT @shared = COUNT(DISTINCT w1.subj_id)
    FROM work w1 JOIN [hours] h1 ON w1.hours_id = h1.id JOIN faculty f1 ON h1.faculty_id = f1.id
    JOIN work w2 ON w1.subj_id = w2.subj_id JOIN [hours] h2 ON w2.hours_id = h2.id JOIN faculty f2 ON h2.faculty_id = f2.id
    WHERE f1.faculty_name = 'ФПК' AND f2.faculty_name = 'ФПМ';
    PRINT 'Для ФПК читается ' + CAST(@fpk AS VARCHAR) + ' предметов, для ФПМ читается ' + CAST(@fpm AS VARCHAR) + 
          ' предметов, всего ' + CAST(@total AS VARCHAR) + ' предметов (' + CAST(@shared AS VARCHAR) + ' из которых идентичны)';
END;
GO

--PROCEDURE 3

GO
CREATE OR ALTER PROCEDURE AddNewStudent
    @fName NVARCHAR(30), @sName NVARCHAR(30), @lName NVARCHAR(30),
    @bDate DATE, @iDate DATE, @facName NVARCHAR(50), @frmName NVARCHAR(30)
AS
BEGIN
    DECLARE @hId INT;
    SELECT @hId = h.id FROM [hours] h 
    JOIN faculty f ON h.faculty_id = f.id 
    JOIN form frm ON h.form_id = frm.id
    WHERE f.faculty_name = @facName AND frm.form_name = @frmName AND h.cours = 1;
    IF @hId IS NULL
        THROW 50001, 'Ошибка: Комбинация факультета и формы не найдена!', 1;
    ELSE
    BEGIN
        INSERT INTO stud (f_name, s_name, last_name, br_date, in_date, exm)
        VALUES (@fName, @sName, @lName, @bDate, @iDate, 0);
        INSERT INTO process (stud_id, hours_id) VALUES (SCOPE_IDENTITY(), @hId);
    END
END;
GO

--FUNCTION 1

GO
CREATE OR ALTER FUNCTION GetCitizenship(@sName NVARCHAR(30))
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN CASE WHEN @sName IS NULL OR @sName = '' THEN N'Иностранец' ELSE N'Гражданин' END;
END;
GO

--FUNCTION 2

GO
CREATE OR ALTER FUNCTION GetTeacherLoad()
RETURNS TABLE
AS
RETURN (
    SELECT t.last_name, t.f_name, t.s_name, SUM(sj.[hours]) as total_h
    FROM teach t
    JOIN work w ON t.id = w.teach_id
    JOIN subj sj ON w.subj_id = sj.id
    GROUP BY t.id, t.last_name, t.f_name, t.s_name
);
GO

--VIEW 1

GO
CREATE VIEW V_FPK_Students AS
SELECT s.s_name + ' ' + s.f_name AS FullName, h.cours, frm.form_name
FROM stud s JOIN process p ON s.id = p.stud_id JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id JOIN form frm ON h.form_id = frm.id
WHERE f.faculty_name = N'ФПК';
GO

CREATE VIEW V_ZaochnoHours AS
SELECT f.faculty_name, h.cours, SUM(h.all_h) as total_all_hours
FROM faculty f JOIN [hours] h ON f.id = h.faculty_id JOIN form frm ON h.form_id = frm.id
WHERE frm.form_name = N'Заочная' GROUP BY f.faculty_name, h.cours;
GO

CREATE VIEW V_TopStudents AS
SELECT f.faculty_name, h.cours, frm.form_name, COUNT(s.id) as excellence_count
FROM stud s JOIN process p ON s.id = p.stud_id JOIN [hours] h ON p.hours_id = h.id
JOIN faculty f ON h.faculty_id = f.id JOIN form frm ON h.form_id = frm.id
WHERE s.exm > 8 GROUP BY f.faculty_name, h.cours, frm.form_name;
GO

CREATE VIEW V_WeakStudents AS
SELECT s.s_name, s.f_name, s.exm FROM stud s WHERE s.exm < 6;
GO

--VIEW 2

--Ответ: Данные представления являются "Только для чтения", так как используют JOIN, GROUP BY и агрегатные функции. 

--UNION 1

SELECT t.last_name, t.f_name, t.s_name, '20%' as bonus 
FROM teach t 
JOIN work w ON t.id = w.teach_id 
JOIN subj s ON w.subj_id = s.id 
GROUP BY t.id, t.last_name, t.f_name, t.s_name 
HAVING SUM(s.[hours]) > 450
UNION
SELECT t.last_name, t.f_name, t.s_name, '10%' 
FROM teach t 
JOIN work w ON t.id = w.teach_id 
JOIN subj s ON w.subj_id = s.id 
GROUP BY t.id, t.last_name, t.f_name, t.s_name 
HAVING SUM(s.[hours]) BETWEEN 301 AND 450
UNION
SELECT t.last_name, t.f_name, t.s_name, '0%' 
FROM teach t 
JOIN work w ON t.id = w.teach_id 
JOIN subj s ON w.subj_id = s.id 
GROUP BY t.id, t.last_name, t.f_name, t.s_name 
HAVING SUM(s.[hours]) <= 300;


--UNION 2

SELECT last_name, f_name, N'РБ' as Country FROM stud WHERE ISNULL(s_name, '') <> ''
UNION
SELECT last_name, f_name, N'Иностранное' FROM stud WHERE ISNULL(s_name, '') = ''
UNION
SELECT last_name, f_name, N'РБ' FROM teach WHERE ISNULL(s_name, '') <> ''
UNION
SELECT last_name, f_name, N'Иностранное' FROM teach WHERE ISNULL(s_name, '') = '';


--UNION 3

SELECT t.last_name, t.f_name FROM teach t 
JOIN work w ON t.id = w.teach_id JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id 
WHERE f.faculty_name = N'ФПК'
INTERSECT
SELECT t.last_name, t.f_name FROM teach t 
JOIN work w ON t.id = w.teach_id JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id 
WHERE f.faculty_name = N'ФПМ';


--UNION 4

SELECT t.last_name, t.f_name FROM teach t 
JOIN work w ON t.id = w.teach_id JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id 
WHERE f.faculty_name = N'ФПК'
EXCEPT
SELECT t.last_name, t.f_name FROM teach t 
JOIN work w ON t.id = w.teach_id JOIN [hours] h ON w.hours_id = h.id JOIN faculty f ON h.faculty_id = f.id 
WHERE f.faculty_name = N'ФПМ';

--UNION 5

SELECT N'Студентов' as Category, COUNT(*) as Total FROM stud
UNION ALL
SELECT N'Преподавателей', COUNT(*) FROM teach
UNION ALL
SELECT N'Всего человек', (SELECT COUNT(*) FROM stud) + (SELECT COUNT(*) FROM teach);
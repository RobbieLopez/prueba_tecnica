--Creacion de candidato
DELIMITER //

CREATE PROCEDURE CreateCandidate(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_resume TEXT
)
BEGIN
    INSERT INTO Candidates (first_name, last_name, email, phone, resume, Is_Deleted)
    VALUES (p_first_name, p_last_name, p_email, p_phone, p_resume, 0);
END //

DELIMITER ;

CALL CreateCandidate('Roberto','Valderrama','rvalderrama44@gmail.com','5610972174', 'resumen')

--Crear Puesto
DELIMITER //

CREATE PROCEDURE CreateJob(
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_location VARCHAR(150),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Jobs (title, description, location, salary)
    VALUES (p_title, p_description, p_location, p_salary);
END //

DELIMITER ;

CALL CreateJob('Desarrollador Backend','Descripcion para puesto de desarrollador backend', 'CDMX', '20000')

--Aplicacion al puesto
DELIMITER //

CREATE PROCEDURE ApplyToJob(
    IN p_candidate_id INT,
    IN p_job_id INT
)
BEGIN
    INSERT INTO Applications (candidate_id, job_id, status_id, applied_at)
    VALUES (p_candidate_id, p_job_id, 1, NOW()); 
END //

DELIMITER ;

CALL ApplyToJob (1,1);

--Actualizar estado de la aplicacion
DELIMITER //

CREATE PROCEDURE UpdateApplicationStatus(
    IN p_application_id INT,
    IN p_status_id INT
)
BEGIN
    UPDATE Applications
    SET status_id = p_status_id
    WHERE id = p_application_id;
END //

DELIMITER ;

CALL UpdateApplicationStatus(1, 3)

--Actualizar datos del candidato
DELIMITER //

CREATE PROCEDURE UpdateCandidate(
    IN p_candidate_id INT,
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_resume TEXT
)
BEGIN
    UPDATE Candidates
    SET email = p_email,
        phone = p_phone,
        resume = p_resume
    WHERE id = p_candidate_id AND Is_Deleted = 0;
END //

DELIMITER ;

CALL UpdateCandidate(1,'rvalderrama44@gmail.com','5610972174', 'resumen actualizado');

--Eliminar candidato
DELIMITER //

CREATE PROCEDURE DeleteCandidate(
    IN p_candidate_id INT
)
BEGIN
    UPDATE Candidates
    SET Is_Deleted = 1
    WHERE id = p_candidate_id;
END //

DELIMITER ;

--Obtener todas las aplicaciones a puestos
DELIMITER //

CREATE PROCEDURE GetAllApplications()
BEGIN
    SELECT a.id, c.first_name, c.last_name, j.title, s.description AS status, a.applied_at
    FROM Applications a
    JOIN Candidates c ON a.candidate_id = c.id
    JOIN Jobs j ON a.job_id = j.id
    JOIN StatusDescription s ON a.status_id = s.status_id
    WHERE c.Is_Deleted = 0;
END //

DELIMITER ;

CALL GetAllApplications()

--Obtener todos los puestos
DELIMITER //

CREATE PROCEDURE GetAllJobs()
BEGIN
    SELECT * FROM Jobs;
END //

DELIMITER ;

CALL GetAllJobs()

--Obtener todos los candidatos
DELIMITER //

CREATE PROCEDURE GetAllCandidates()
BEGIN
    SELECT id, first_name, last_name, email, phone, resume
    FROM Candidates
    WHERE Is_Deleted = 0;
END //

DELIMITER ;

CALL GetAllCandidates()

--Actualizar puesto
DELIMITER //

CREATE PROCEDURE UpdateJob(
    IN p_id INT,
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_location VARCHAR(150),
    IN p_salary DECIMAL(10,2)
)
BEGIN
    UPDATE Jobs
    SET 
        title = p_title,
        description = p_description,
        location = p_location,
        salary = p_salary,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_id;
END //

DELIMITER ;

CALL UpdateJob(1,'Desarrollador Backend Actualizado', 'Descripcion para puesto de desarrollador backend actualizado', 'CDMX', 20500)
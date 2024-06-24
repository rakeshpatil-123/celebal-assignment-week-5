-- celebal assignment 5
CREATE TABLE SubjectAllotments (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20),
    Is_valid BIT
);

CREATE TABLE SubjectRequest (
    StudentId VARCHAR(20),
    SubjectId VARCHAR(20)
);

INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid) VALUES
('159103036', 'PO1491', 1),
('159103036', 'PO1492', 0),
('159103036', 'PO1493', 0),
('159103036', 'PO1494', 0),
('159103036', 'PO1495', 0);

INSERT INTO SubjectRequest (StudentId, SubjectId) VALUES
('159103036', 'PO1496');

-- ------------------------

CREATE PROCEDURE UpdateSubjectAllotment
AS
BEGIN
    DECLARE @StudentId VARCHAR(20);
    DECLARE @SubjectId VARCHAR(20);

    DECLARE subject_cursor CURSOR FOR
    SELECT StudentId, SubjectId
    FROM SubjectRequest;

    OPEN subject_cursor;

    FETCH NEXT FROM subject_cursor INTO @StudentId, @SubjectId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId)
        BEGIN
            IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId AND SubjectId = @SubjectId AND Is_valid = 1)
            BEGIN
                CONTINUE;
            END
            ELSE
            BEGIN
                UPDATE SubjectAllotments
                SET Is_valid = 0
                WHERE StudentId = @StudentId AND Is_valid = 1;

                INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
                VALUES (@StudentId, @SubjectId, 1);
            END
        END
        ELSE
        BEGIN
            INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_valid)
            VALUES (@StudentId, @SubjectId, 1);
        END

        FETCH NEXT FROM subject_cursor INTO @StudentId, @SubjectId;
    END;

    CLOSE subject_cursor;
    DEALLOCATE subject_cursor;
END;

-- ------------------------------

EXEC UpdateSubjectAllotment;

-- ----------------------------

SELECT * FROM SubjectAllotments;



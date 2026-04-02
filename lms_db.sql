CREATE DATABASE  lms_db;
USE lms_db;


CREATE TABLE users (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100)        NOT NULL,
    email       VARCHAR(150)        NOT NULL UNIQUE,
    password    VARCHAR(255)        NOT NULL,          
    role        ENUM('member','admin') NOT NULL DEFAULT 'member',
    avatar_url  VARCHAR(500)        NULL,
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE categories (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)  NOT NULL UNIQUE,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE books (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(255)        NOT NULL,
    author          VARCHAR(150)        NOT NULL,
    isbn            VARCHAR(20)         NULL UNIQUE,
    category_id     INT UNSIGNED        NULL,
    publisher       VARCHAR(150)        NULL,
    published_year  YEAR                NULL,
    description     TEXT                NULL,
    cover_image_url VARCHAR(500)        NULL,
    total_copies    INT UNSIGNED        NOT NULL DEFAULT 3,
    available_copies INT UNSIGNED       NOT NULL DEFAULT 3,
    created_at      TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 
    CONSTRAINT fk_books_category
        FOREIGN KEY (category_id) REFERENCES categories(id)
        ON DELETE SET NULL ON UPDATE CASCADE,
 
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies)
);

CREATE TABLE reservations (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id         INT UNSIGNED        NOT NULL,
    book_id         INT UNSIGNED        NOT NULL,
    reserved_at     TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at      TIMESTAMP           NULL,
    status          ENUM('pending','fulfilled','cancelled','expired') NOT NULL DEFAULT 'pending',
 
    CONSTRAINT fk_reservations_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
 
    CONSTRAINT fk_reservations_book
        FOREIGN KEY (book_id) REFERENCES books(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE activity_logs (
    id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id     INT UNSIGNED        NULL,
    action      VARCHAR(100)        NOT NULL,   -- e.g. 'book_added', 'user_registered'
    description TEXT                NULL,
    created_at  TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
 
    CONSTRAINT fk_logs_user
        FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL ON UPDATE CASCADE
);
 
 CREATE INDEX idx_books_title    ON books(title);
 CREATE INDEX idx_books_author   ON books(author);
CREATE INDEX idx_borrow_user    ON borrowings(user_id);
CREATE INDEX idx_borrow_book    ON borrowings(book_id);
CREATE INDEX idx_borrow_status  ON borrowings(status);
CREATE INDEX idx_reserve_user   ON reservations(user_id);
CREATE INDEX idx_reserve_book   ON reservations(book_id);

CREATE OR REPLACE VIEW v_book_availability AS
SELECT
    b.id,
    b.title,
    b.author,
    c.name          AS category,
    b.total_copies,
    b.available_copies,
    (b.total_copies - b.available_copies) AS borrowed_copies
FROM books b
LEFT JOIN categories c ON c.id = b.category_id;

CREATE OR REPLACE VIEW v_my_books AS
SELECT
    bw.id           AS borrowing_id,
    bw.user_id,
    u.full_name,
    b.id            AS book_id,
    b.title,
    b.author,
    b.cover_image_url,
    bw.borrowed_at,
    bw.due_date,
    bw.returned_at,
    bw.status,
    CASE
        WHEN bw.status = 'borrowed' AND bw.due_date < CURDATE()
        THEN DATEDIFF(CURDATE(), bw.due_date)
        ELSE 0
    END             AS days_overdue
FROM borrowings bw
JOIN users u  ON u.id  = bw.user_id
JOIN books b  ON b.id  = bw.book_id;

DELIMITER $$
 
CREATE PROCEDURE sp_borrow_book(
    IN  p_user_id  INT UNSIGNED,
    IN  p_book_id  INT UNSIGNED,
    IN  p_days     INT,           -- loan period in days
    OUT p_result   VARCHAR(100)
)
BEGIN
    DECLARE v_available INT DEFAULT 0;
 
    START TRANSACTION;
 
    SELECT available_copies INTO v_available
    FROM books WHERE id = p_book_id FOR UPDATE;
 
    IF v_available <= 0 THEN
        SET p_result = 'ERROR: No copies available';
        ROLLBACK;
    ELSE
        -- Create borrowing record
        INSERT INTO borrowings (user_id, book_id, borrowed_at, due_date, status)
        VALUES (p_user_id, p_book_id, CURDATE(), DATE_ADD(CURDATE(), INTERVAL p_days DAY), 'borrowed');
 
        -- Decrement available copies
        UPDATE books SET available_copies = available_copies - 1 WHERE id = p_book_id;
 
        -- Log the activity
        INSERT INTO activity_logs (user_id, action, description)
        VALUES (p_user_id, 'book_borrowed',
                CONCAT('User ', p_user_id, ' borrowed book ', p_book_id));
 
        SET p_result = 'SUCCESS';
        COMMIT;
    END IF;
END$$

DELIMITER $$

CREATE PROCEDURE sp_return_book(
    IN  p_borrowing_id INT UNSIGNED,
    OUT p_fine_amount  DECIMAL(8,2),
    OUT p_result       VARCHAR(100)
)
BEGIN
    DECLARE v_book_id INT UNSIGNED;
    DECLARE v_due_date DATE;
    DECLARE v_return_date DATE;

    -- example logic
    SET v_return_date = CURDATE();
    SET p_fine_amount = 0;
    SET p_result = 'Success';

END$$

DELIMITER ;

INSERT INTO categories (name) VALUES
    ('Fiction'),
    ('Non-Fiction'),
    ('Science'),
    ('Technology'),
    ('History'),
    ('Biography'),
    ('Children');
 
INSERT INTO users (full_name, email, password, role) VALUES
    ('Admin User',   'admin@lms.com',  '$2b$10$examplehashedpassword1', 'admin'),
    ('John Doe',     'john@mail.com',  '$2b$10$examplehashedpassword2', 'member'),
    ('Jane Smith',   'jane@mail.com',  '$2b$10$examplehashedpassword3', 'member');
 
INSERT INTO books (title, author, isbn, category_id, publisher, published_year, total_copies, available_copies) VALUES
    ('The Great Gatsby',       'F. Scott Fitzgerald', '9780743273565', 1, 'Scribner',         1925, 5, 5),
    ('Clean Code',             'Robert C. Martin',    '9780132350884', 4, 'Prentice Hall',    2008, 3, 3),
    ('A Brief History of Time','Stephen Hawking',     '9780553380163', 3, 'Bantam Books',     1988, 4, 4),
    ('Sapiens',                'Yuval Noah Harari',   '9780062316097', 5, 'Harper Perennial', 2015, 6, 6),
    ('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', '9780439708180', 7, 'Bloomsbury', 1997, 8, 8);
 
 
 
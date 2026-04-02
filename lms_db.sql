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


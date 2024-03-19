-- Active: 1710830947867@@database-1203.c5iywe822rl5.ap-northeast-2.rds.amazonaws.com@3306
create DATABASE Books;

use Books;
CREATE table Categories (
    category_id int PRIMARY KEY AUTO_INCREMENT, 
    category_name VARCHAR(255) NOT NULL, 
    category_index INT
);

CREATE Table Authors (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    age INT
);

CREATE Table Books (
    book_id int PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(100) NOT NULL,
    pub_year DATETIME NOT NULL,
    price INT NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY(category_id) references Categories (category_id),
    author_id INT NOT NULL,
    Foreign Key (author_id) REFERENCES Authors (author_id)
);

CREATE Table Users (
    user_id int PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    age INT
);

CREATE Table Purchases(
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_date DATETIME NOT NULL,
    quantity INT NOT NULL,
    purchase_price INT NOT NULL,
    user_id INT NOT NULL,
    Foreign Key (user_id) REFERENCES Users (user_id),
    book_id INT NOT NULL,
    Foreign Key (book_id) REFERENCES Books (book_id)
);

###############################################################

# 1. 모든 저자의 이름과 나이 출력
SELECT name, age from Authors;

# 2. 출판 연도가 2020년 이후인 모든 책 출력
SELECT book_id, title, author_id, pub_year, price, category_id
FROM `Books`
WHERE year(pub_year) >= 2020;

# 3. 2024년에 구매한 모든 내역을 출력
SELECT user_id, book_id, purchase_date 
FROM Purchases
WHERE year(purchase_date) = 2024;

# 4. 서울에서 거주하는 유저 출력
SELECT name, address
FROM Users
WHERE address='서울';

# 5. 가격이 높은 순서대로 책
 SELECT book_id, title, author_id, pub_year, price, category_id
 FROM Books
 ORDER BY price DESC;

# 6. 카테고리 이름에 '과학' 포함된 것
SELECT category_id, category_name, category_index
FROM Categories
WHERE category_name like '과학';

# 7. 28세 ~ 30세 사이 유저
SELECT email, age
FROM Users
WHERE age BETWEEN 28 and 30;

# 8. 매년 출판된 책의 수 연도순 내림차순
SELECT year(pub_year) as year, count(title) as total_books
FROM Books
GROUP BY year(pub_year)
ORDER BY year DESC;

# 9. 구매내역에서 구매 수량이 4보다 큰 내역
SELECT 
purchase_id, user_id, book_id, purchase_date, quantity, purchase_price
FROM Purchases
WHERE quantity > 4;

# 10. 모든 책의 이름과 카테고리
SELECT title, category_name FROM Books, Categories
WHERE Books.category_id = Categories.category_id;

# 11. 이름이 '김'으로 시작하는 유저
SELECT * FROM Users
WHERE name like '김%';

# 12. 가장 비싼 책 5권
SELECT * FROM Books 
ORDER BY price DESC
limit 5;

# 13. 모든 사용자의 평균 나이
SELECT AVG(age) as average_age FROM Users;

# 14. 각 작가가 출판한 총 책의 수
SELECT author_id, count(title) as total_books FROM `Books`
GROUP BY author_id;

# 15. 각 작가가 출판한 총 책의 수 (3권 이상인 경우만)
SELECT author_id, count(title) as total_books FROM `Books`
GROUP BY author_id
having total_books >=3;

# 16. 책을 구매한 모든 유저
SELECT DISTINCT name FROM Users as u, Purchases as pc
WHERE u.user_id = pc.user_id;

# 17. 책의 평균 가격보다 비싼 책
SELECT title, price FROM Books
WHERE price > (SELECT AVG(price) as avg_price FROM Books);

# 18. 각 유저의 최근 구매 날짜
SELECT user_id, max(purchase_date) FROM Purchases
GROUP BY user_id;

# 19. 책 10번 초과 구매한 사용자
SELECT name FROM Purchases, Users
WHERE Purchases.user_id = Users.user_id
GROUP BY Purchases.user_id
having count(book_id) > 10;

# 20. 책 10번 이상 구매한 사용자, 총 구매수, 구매 가격 합계
SELECT name, count(quantity) as total_purchases, sum(purchase_price) as total_spent
FROM Purchases, Users
WHERE Purchases.user_id = Users.user_id
GROUP BY Purchases.user_id
having count(book_id) >= 10;


###############################################################
